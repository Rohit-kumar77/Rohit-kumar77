import os
import shlex
import subprocess
import sys
from typing import List, Optional

import click


def run_cmd(cmd: List[str], cwd: Optional[str] = None) -> int:
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
    """Simple Terraform agent CLI to run common terraform commands."""
    if not terraform_installed():
        click.echo("terraform binary not found in PATH. Please install Terraform.")
        sys.exit(1)


@cli.command()
@click.argument("path", required=False, default=".")
def init(path):
    """Run `terraform init` in the given directory."""
    rc = run_cmd(["terraform", "init"], cwd=path)
    sys.exit(rc)


@cli.command()
@click.argument("path", required=False, default=".")
@click.option("--out", "out_file", default="plan.tfplan", help="Path to write plan file")
@click.option("--var", "vars", multiple=True, help="Set variable as key=value (can repeat)")
def plan(path, out_file, vars):
    """Run `terraform plan` and save the plan to a file."""
    cmd = ["terraform", "plan", "-out", out_file]
    for v in vars:
        cmd.extend(["-var", v])
    rc = run_cmd(cmd, cwd=path)
    sys.exit(rc)


@cli.command()
@click.argument("path", required=False, default=".")
@click.option("--plan-file", default=None, help="Apply from an existing plan file")
@click.option("--auto-approve", is_flag=True, help="Skip interactive approval")
def apply(path, plan_file, auto_approve):
    """Run `terraform apply` (optionally from a plan file)."""
    if plan_file:
        cmd = ["terraform", "apply", plan_file]
    else:
        cmd = ["terraform", "apply"]
        if auto_approve:
            cmd.append("-auto-approve")
    rc = run_cmd(cmd, cwd=path)
    sys.exit(rc)


@cli.command()
@click.argument("path", required=False, default=".")
@click.option("--auto-approve", is_flag=True, help="Skip interactive approval")
def destroy(path, auto_approve):
    """Run `terraform destroy` in the given directory."""
    cmd = ["terraform", "destroy"]
    if auto_approve:
        cmd.append("-auto-approve")
    rc = run_cmd(cmd, cwd=path)
    sys.exit(rc)


@cli.command()
@click.argument("path", required=False, default=".")
def validate(path):
    """Run `terraform validate`."""
    rc = run_cmd(["terraform", "validate"], cwd=path)
    sys.exit(rc)


@cli.command()
@click.argument("path", required=False, default=".")
def fmt(path):
    """Run `terraform fmt` to format configuration files."""
    rc = run_cmd(["terraform", "fmt", "-recursive"], cwd=path)
    sys.exit(rc)


@cli.command(name="show")
@click.argument("plan_file", required=False, default=None)
def show_cmd(plan_file):
    """Run `terraform show` to display state or a plan file."""
    cmd = ["terraform", "show"]
    if plan_file:
        cmd.append(plan_file)
    rc = run_cmd(cmd)
    sys.exit(rc)


if __name__ == "__main__":
    cli()
