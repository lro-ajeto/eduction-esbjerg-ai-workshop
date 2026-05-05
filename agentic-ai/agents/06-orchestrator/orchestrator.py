from __future__ import annotations

SCRIPT_DIR = Path(__file__).resolve().parent
AGENTIC_DIR = SCRIPT_DIR.parent.parent
REPO_ROOT = AGENTIC_DIR.parent
WORKFLOW_FILE = AGENTIC_DIR / "workflow.json"
SCREENS_DIR = AGENTIC_DIR / "screens"
SUMMARY_FILE = AGENTIC_DIR / "work-products" / "06-orchestrator-summary.md"
RUN_AGENT_SCRIPT = AGENTIC_DIR / "scripts" / "run_agent.py"


# TODO


if __name__ == "__main__":
    sys.exit(main())
