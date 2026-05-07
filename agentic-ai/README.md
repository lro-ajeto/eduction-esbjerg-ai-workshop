# Agentic AI workshop

## 1. Start her

Åbn først disse to fælles kontekstfiler:

- `context/kontekst.md`
- `context/quality-contract.md`

Udfyld TODO'erne, så agenterne ved:

- hvad workshopcasen handler om,
- hvilke kvalitetsprincipper de skal følge,
- hvornår de skal stoppe og bede om menneskelig afklaring,
- hvordan output skal være reviewbart.

## 2. Udfyld agentprompterne

Udfyld derefter TODO'erne i agenternes promptfiler.

| Agent | Fil | Hvad skal deltagerne tage stilling til?                                                                                      |
| --- | --- |------------------------------------------------------------------------------------------------------------------------------|
| 01 Indlæsning | `agents/01-collection/prompt.md` | Hvordan legacy-skærmbilleder opdages, hvilken metadata der skal oprettes, og hvornår indlæsning er god nok.                  |
| 02 Spec | `agents/02-generate-spec/prompt.md` | Hvordan en god, testbar specifikation skal struktureres.                                                                     |
| 03 Kode | `agents/03-generate-code/prompt.md` | Hvordan kodeagenten holder scope, dokumenterer ændringer og reagerer på reviewfund.                                          |
| 04 Test | `agents/04-generate-tests/prompt.md` | Hvilken teststrategi der passer til projektet, og hvad nok test betyder.                                                     |
| 05 Review | `agents/05-review-fix/prompt.md` | Hvordan reviewfund prioriteres, og hvornår status skal være `satisfied`, `needs-code-fix`, `needs-test-fix` eller `blocked`. |
| 06 Orkestrator | `agents/06-orchestrator/orchestrator.py` | Byg orkestratoren hvis der er tid                                                                                            |

## 3. Tilpas screen-skabelonen

Åbn:

- `screens/_template/screen.json`
- `screens/_template/forms/intake.md`
- `screens/_template/docs/legacy-notes.md`
- `screens/_template/docs/data-notes.md`
- `screens/_template/review/review-status.json`

`screen.json` har kun minimumsfelterne:

```json
{
  "id": "screen-id",
  "title": "Skærmbilledetitel",
  "status": "loaded"
}
```

Beslut selv hvilke ekstra metadatafelter der gør downstream-agenterne bedre. Typiske kandidater er `priority`, `legacy`, `target`, `dependencies`, `businessRules`, `risks`, `openQuestions`, `clarifications`, `artefacts` og `recommendedNextAgent`.

## 4. Tjek workflowet

Åbn:

- `workflow.json`

Her kan du se agenternes rækkefølge, hvilke filer de læser, og hvilke filer de forventes at skrive.

Normalt skal du ikke ændre runneren:

- `run-agent.cmd`
- `scripts/run_agent.py`
- `scripts/runners.py`

## 5. Kør agenterne

Fra denne mappe:

```powershell
.\run-agent.cmd --agent 01
```

Se hvilke skærmbilleder agent 01 har oprettet:

```powershell
.\run-agent.cmd --list-screens
```

Kør derefter et enkelt skærmbillede manuelt:

```powershell
.\run-agent.cmd --agent 02 --screen <screen-id>
.\run-agent.cmd --agent 03 --screen <screen-id>
.\run-agent.cmd --agent 04 --screen <screen-id>
.\run-agent.cmd --agent 05 --screen <screen-id>
```

Runneren bruger som standard `codex`, men kan også køre via Claude Code CLI:

```powershell
.\run-agent.cmd --runner codex --agent 03 --screen <screen-id>
.\run-agent.cmd --runner claude --agent 03 --screen <screen-id>
```

Model kan sættes i `workflow.json` eller overrides for en enkelt kørsel:

```powershell
.\run-agent.cmd --runner codex --model gpt-5.5 --agent 03 --screen <screen-id>
.\run-agent.cmd --runner claude --model sonnet --agent 03 --screen <screen-id>
```

Hvis review ikke er tilfreds, gentag:

```powershell
.\run-agent.cmd --agent 03 --screen <screen-id>
.\run-agent.cmd --agent 04 --screen <screen-id>
.\run-agent.cmd --agent 05 --screen <screen-id>
```

Loopet er færdigt, når:

```text
screens/<screen-id>/review/review-status.json
```

har:

```json
{
  "status": "satisfied"
}
```

Vigtige handoff-filer:

- `screens/<screen-id>/screen.json`
- `screens/<screen-id>/forms/intake.md`
- `screens/<screen-id>/review/review-status.json`
- `screens/<screen-id>/work-products/`

## 7. Runner-konfiguration

`workflow.json` vælger standardrunner og CLI-indstillinger:

```json
{
  "runners": {
    "default": "codex",
    "codex": {
      "executable": "codex",
      "model": "gpt-5.5",
      "sandbox": "workspace-write"
    },
    "claude": {
      "executable": "claude",
      "model": "sonnet",
      "outputFormat": "stream-json",
      "permissionMode": "acceptEdits",
      "verbose": true
    }
  }
}
```

Begge runners får samme prompt og samme handoff-kontekst. Forskellen er kun den lokale CLI, der udfører agenten.

Claude Code kører som standard med `stream-json` og `--verbose`, fordi `--print` i almindelig teksttilstand ofte først skriver output til sidst. `permissionMode: "acceptEdits"` gør headless-kørsler bedre egnet til at oprette og rette workshopartefakter uden at stoppe ved almindelige filredigeringer.

## 8. Workshopens vigtigste spørgsmål

Når en agent har kørt, så spørg:

- Var agentens scope tydeligt?
- Var outputtet testbart?
- Kan vi se evidens i filer?
- Er der noget agenten gættede på?
- Skal et menneske godkende noget før næste agent?
- Skal review sende arbejdet tilbage til kode- eller testagenten?
