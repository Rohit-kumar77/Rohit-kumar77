# Terraform Agent (tf_agent)

A small Python CLI wrapper to run common Terraform commands from a single place.

Quick start

1. Create a virtual environment and install dependencies:

```bash
python -m venv .venv
source .venv/bin/activate    # or .venv\Scripts\activate on Windows
pip install -r tf_agent/requirements.txt
```

2. Run the agent:

```bash
python tf_agent/agent.py init path/to/infra
python tf_agent/agent.py plan path/to/infra --out myplan.tfplan
python tf_agent/agent.py apply path/to/infra --auto-approve
```

Notes
- This tool is a lightweight convenience wrapper around the `terraform` binary; Terraform must be installed and available in `PATH`.
- It intentionally keeps behaviour close to the upstream CLI. You can extend it to add logging, remote state helpers, or integrations with cloud SDKs or LLM-based explainers.

Next steps (optional):
- Add support for `-var-file` and more advanced argument parsing
- Add JSON parsing of `terraform show -json` for programmatic outputs
- Add a `--dry-run` LLM-backed explain command to summarize changes
