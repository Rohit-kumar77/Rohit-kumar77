import subprocess
from typing import Optional


def run(cmd, cwd: Optional[str] = None, check: bool = True):
    return subprocess.run(cmd, cwd=cwd, check=check)


def create_branch(name: str):
    run(["git", "checkout", "-b", name])


def commit_all(message: str):
    run(["git", "add", "-A"])
    run(["git", "commit", "-m", message])


def push(branch: str):
    run(["git", "push", "-u", "origin", branch])
