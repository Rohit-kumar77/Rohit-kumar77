import os
import sys
import subprocess
from pathlib import Path
from typing import Optional

import click

# allow imports when running as a script
sys.path.insert(0, os.path.dirname(__file__))

from llm import call_llm
import git_utils
import github as gh


def run_cmd(cmd, cwd: Optional[str] = None) -> int:
    proc = subprocess.Popen(cmd, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    assert proc.stdout is not None
    for line in proc.stdout:
        print(line, end="")
    proc.wait()
    return proc.returncode


def terraform_installed() -> bool:
    try:
        return subprocess.call(["terraform", "version"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) == 0
    except FileNotFoundError:
        return False


@click.group()
def cli():
    """Mini Copilot-like agent skeleton for repo assistance."""


@cli.command()
def analyze():
    """Run quick repo checks: git status and terraform validate (if present)."""
    print("git status (porcelain):")
    run_cmd(["git", "status", "--porcelain"])

    if terraform_installed():
        print("\nterraform validate:")
        run_cmd(["terraform", "validate"])
    else:
        print("\nterraform not found; skipping validate.")


@cli.command()
@click.argument("file", type=click.Path(exists=True))
@click.option("--apply/--no-apply", default=False, help="Overwrite file with suggestion if set")
def suggest(file, apply):
    """Ask the LLM for a suggested improvement for a file.

    Prints the suggested content. Use `--apply` to overwrite the file with the suggestion.
    """
    p = Path(file)
    original = p.read_text()
    prompt = f"Suggest an improved version of this file:\n\n{original}"
    suggestion = call_llm(prompt)

    click.echo("\n--- Suggestion start ---\n")
    click.echo(suggestion)
    click.echo("\n--- Suggestion end ---\n")

    if apply:
        confirm = click.confirm(f"Overwrite {file} with suggestion?", default=False)
        if confirm:
            p.write_text(suggestion)
            click.echo(f"Wrote suggestion to {file}")


@cli.command(name="apply-branch")
@click.argument("branch")
@click.option("--message", default="Apply agent changes", help="Commit message")
def apply_branch(branch, message):
    """Create a branch, commit current changes, and push to origin."""
    git_utils.create_branch(branch)
    git_utils.commit_all(message)
    git_utils.push(branch)
    click.echo(f"Branch {branch} created and pushed")


@cli.command()
@click.argument("repo")
@click.argument("head")
@click.option("--base", default="main")
@click.option("--title", default="Automated PR from agent")
@click.option("--body", default="")
def pr(repo, head, base, title, body):
    """Open a pull request on GitHub. `repo` is owner/repo (e.g. me/repo)."""
    resp = gh.create_pr(repo, head, base=base, title=title, body=body)
    click.echo(f"PR created: {resp.get('html_url')}")


if __name__ == "__main__":
    cli()
