import os
from typing import Any, Dict

import requests


def create_pr(owner_repo: str, head: str, base: str = "main", title: str = "Automated PR", body: str = "") -> Dict[str, Any]:
    token = os.getenv("GITHUB_TOKEN")
    if not token:
        raise RuntimeError("GITHUB_TOKEN not set")
    url = f"https://api.github.com/repos/{owner_repo}/pulls"
    headers = {"Authorization": f"token {token}", "Accept": "application/vnd.github.v3+json"}
    data = {"title": title, "head": head, "base": base, "body": body}
    resp = requests.post(url, json=data, headers=headers)
    resp.raise_for_status()
    return resp.json()
