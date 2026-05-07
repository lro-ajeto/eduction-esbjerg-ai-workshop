from __future__ import annotations

import os
import shutil
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Any


@dataclass(frozen=True)
class RunnerResult:
    name: str
    command: list[str]
    exit_code: int


def resolve_executable(name: str) -> str:
    if os.name == "nt" and Path(name).suffix == "":
        for candidate in (f"{name}.cmd", f"{name}.exe", f"{name}.bat", name):
            resolved = shutil.which(candidate)
            if resolved:
                return resolved

    resolved = shutil.which(name)
    if resolved:
        return resolved

    raise SystemExit(f"Could not find '{name}' on PATH.")


def extra_args(config: dict[str, Any]) -> list[str]:
    values = config.get("extraArgs", [])
    if not isinstance(values, list):
        raise SystemExit("Runner config 'extraArgs' must be a list.")
    return [str(value) for value in values]


class CliRunner:
    name = "base"

    def __init__(self, config: dict[str, Any], repo_root: Path):
        self.config = config
        self.repo_root = repo_root

    def command(self) -> list[str]:
        raise NotImplementedError

    def run(self, prompt: str) -> RunnerResult:
        command = self.command()
        result = subprocess.run(
            command,
            input=prompt,
            cwd=str(self.repo_root),
            text=True,
            encoding="utf-8",
            errors="replace",
            check=False,
        )
        return RunnerResult(self.name, command, result.returncode)


class CodexCliRunner(CliRunner):
    name = "codex"

    def command(self) -> list[str]:
        executable = resolve_executable(str(self.config.get("executable", "codex")))
        command = [
            executable,
            "exec",
            "--cd",
            str(self.repo_root),
            "--sandbox",
            str(self.config.get("sandbox", "workspace-write")),
            "--color",
            "never",
        ]

        with_model(command, self.config)
        command.extend(extra_args(self.config))
        command.append("-")
        return command


class ClaudeCliRunner(CliRunner):
    name = "claude"

    def command(self) -> list[str]:
        executable = resolve_executable(str(self.config.get("executable", "claude")))
        command = [
            executable,
            "--print",
            "--output-format",
            str(self.config.get("outputFormat", "text")),
        ]

        with_model(command, self.config)

        input_format = self.config.get("inputFormat")
        if input_format:
            command.extend(["--input-format", str(input_format)])

        max_turns = self.config.get("maxTurns")
        if max_turns:
            command.extend(["--max-turns", str(max_turns)])

        permission_mode = self.config.get("permissionMode")
        if permission_mode:
            command.extend(["--permission-mode", str(permission_mode)])

        if self.config.get("verbose"):
            command.append("--verbose")

        if self.config.get("includePartialMessages"):
            command.append("--include-partial-messages")

        command.extend(extra_args(self.config))
        return command


RUNNERS = {
    "codex": CodexCliRunner,
    "claude": ClaudeCliRunner,
}


def runner_names() -> list[str]:
    return sorted(RUNNERS)


def with_model(command: list[str], config: dict[str, Any]) -> None:
    model = config.get("model")
    if model:
        command.extend(["--model", str(model)])


def runner_config(
    workflow: dict[str, Any],
    runner_name: str | None,
    model: str | None = None,
) -> tuple[str, dict[str, Any]]:
    runners = workflow.get("runners", {})
    if not isinstance(runners, dict):
        runners = {}

    selected = runner_name or str(runners.get("default", "codex"))
    if selected not in RUNNERS:
        raise SystemExit(f"Unknown runner: {selected}. Available runners: {', '.join(runner_names())}")

    config = runners.get(selected, {})
    if not isinstance(config, dict):
        raise SystemExit(f"Runner config for '{selected}' must be an object.")

    if selected == "codex":
        config = {
            "executable": "codex",
            "sandbox": workflow.get("defaultSandbox", "workspace-write"),
            **config,
        }
    elif selected == "claude":
        config = {
            "executable": "claude",
            "outputFormat": "stream-json",
            "permissionMode": "acceptEdits",
            "verbose": True,
            **config,
        }

    if model:
        config["model"] = model

    return selected, config


def create_runner(
    workflow: dict[str, Any],
    runner_name: str | None,
    repo_root: Path,
    model: str | None = None,
) -> CliRunner:
    selected, config = runner_config(workflow, runner_name, model)
    return RUNNERS[selected](config, repo_root)
