from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any


SCRIPT_DIR = Path(__file__).resolve().parent
AGENTIC_DIR = SCRIPT_DIR.parent
REPO_ROOT = AGENTIC_DIR.parent
WORKFLOW_FILE = AGENTIC_DIR / "workflow.json"
SCREENS_DIR = AGENTIC_DIR / "screens"


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(read_text(path))


def load_workflow() -> dict[str, Any]:
    return load_json(WORKFLOW_FILE)


def agent_label(agent: dict[str, Any]) -> str:
    return f"{agent['id']} - {agent['name']}"


def resolve_agent(workflow: dict[str, Any], selector: str) -> dict[str, Any]:
    value = selector.strip().lower()
    if value.isdigit():
        value = f"{int(value):02d}"

    matches = [
        agent
        for agent in workflow["agents"]
        if agent["id"].lower() == value
        or agent["id"].lower().startswith(value)
        or agent["name"].lower() == value
    ]

    if len(matches) == 1:
        return matches[0]
    if not matches:
        raise SystemExit(f"Unknown agent: {selector}")
    raise SystemExit(f"Ambiguous agent: {selector}")


def load_screen(screen_id: str | None) -> dict[str, Any]:
    if not screen_id:
        raise SystemExit("This agent requires --screen <screen-id>.")

    screen_file = SCREENS_DIR / screen_id / "screen.json"
    if not screen_file.exists():
        raise SystemExit(f"Unknown screen: {screen_id}. Run agent 01 first.")

    screen = load_json(screen_file)
    screen["_path"] = screen_file.parent
    return screen


def screen_context_files(screen: dict[str, Any]) -> list[Path]:
    screen_dir = Path(screen["_path"])
    files = [screen_dir / "screen.json"]

    for pattern in [
        "forms/*.md",
        "docs/*.md",
        "work-products/*.md",
        "review/*.md",
        "review/*.json",
    ]:
        files.extend(sorted(screen_dir.glob(pattern)))

    return [path for path in files if path.exists()]


def expand_screen(value: str, screen: dict[str, Any] | None) -> str:
    screen_id = str(screen["id"]) if screen else "_global"
    return value.replace("{screen}", screen_id).replace("${screen}", screen_id)


def add_file_section(parts: list[str], title: str, path: Path) -> None:
    if path.exists():
        parts.append(f"# {title}: {path}\n\n{read_text(path).strip()}\n")


def resolve_executable(name: str) -> str:
    if os.name == "nt" and Path(name).suffix == "":
        for candidate in (f"{name}.cmd", f"{name}.exe", f"{name}.bat", name):
            resolved = shutil.which(candidate)
            if resolved:
                return resolved

    resolved = shutil.which(name)
    if resolved:
        return resolved

    raise SystemExit(
        f"Could not find '{name}' on PATH. Try running 'where {name}' or install/login to Codex CLI."
    )


def build_prompt(
    workflow: dict[str, Any],
    agent: dict[str, Any],
    screen: dict[str, Any] | None,
) -> str:
    parts = [
        "# Run metadata\n\n"
        f"- Agent: {agent_label(agent)}\n"
        f"- Repository root: {REPO_ROOT}\n"
        f"- Agentic AI folder: {AGENTIC_DIR}\n"
    ]

    if screen:
        parts.append(
            "# Current screen\n\n"
            f"- Screen id: {screen['id']}\n"
            f"- Screen title: {screen.get('title', '')}\n"
            f"- Screen folder: {screen['_path']}\n"
        )

    for relative_path in workflow.get("context", []):
        add_file_section(parts, f"Shared context: {relative_path}", AGENTIC_DIR / relative_path)

    if screen:
        for path in screen_context_files(screen):
            add_file_section(parts, "Screen context", path)

    if "prompt" in agent:
        add_file_section(parts, f"Agent prompt: {agent['prompt']}", AGENTIC_DIR / agent["prompt"])
    elif "script" in agent:
        add_file_section(parts, f"Agent script: {agent['script']}", AGENTIC_DIR / agent["script"])
    else:
        raise SystemExit(f"Agent {agent_label(agent)} has neither 'prompt' nor 'script' in workflow.json.")

    required = [expand_screen(item, screen) for item in agent.get("requires", [])]
    if required:
        parts.append("# Required input artefacts\n\n" + "\n".join(f"- {item}" for item in required) + "\n")

    writes = [expand_screen(item, screen) for item in agent.get("writes", [])]
    if writes:
        parts.append("# Expected output artefacts\n\n" + "\n".join(f"- {item}" for item in writes) + "\n")

    return "\n\n".join(parts).strip() + "\n"


def codex_command(workflow: dict[str, Any]) -> list[str]:
    return [
        resolve_executable("codex"),
        "exec",
        "--cd",
        str(REPO_ROOT),
        "--sandbox",
        workflow.get("defaultSandbox", "workspace-write"),
        "--color",
        "never",
        "-",
    ]


def run_codex(workflow: dict[str, Any], prompt: str) -> int:
    result = subprocess.run(
        codex_command(workflow),
        input=prompt,
        cwd=str(REPO_ROOT),
        text=True,
        encoding="utf-8",
        errors="replace",
        check=False,
    )
    return result.returncode


def main() -> int:
    parser = argparse.ArgumentParser(description="Start one workshop agent.")
    parser.add_argument("--agent", required=True, help="Agent id, e.g. 01 or 03-generate-code.")
    parser.add_argument("--screen", help="Screen id for screen-specific agents.")
    args = parser.parse_args()

    workflow = load_workflow()
    agent = resolve_agent(workflow, args.agent)

    if agent.get("perScreen"):
        screen = load_screen(args.screen)
    else:
        screen = None
        if args.screen:
            raise SystemExit(f"{agent_label(agent)} is global and does not use --screen.")

    print(f"Starting {agent_label(agent)}")
    if screen:
        print(f"Screen: {screen['id']} - {screen.get('title', '')}")

    prompt = build_prompt(workflow, agent, screen)
    return run_codex(workflow, prompt)


if __name__ == "__main__":
    sys.exit(main())
