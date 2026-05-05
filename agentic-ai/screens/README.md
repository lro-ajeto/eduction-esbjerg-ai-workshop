# Screen workspace

Agent 01 opretter en mappe pr. legacy-skærmbillede her.

De øvrige agenter køres med `--screen <screen-id>` og arbejder kun på det valgte skærmbillede.

Eksempel:

```powershell
.\run-agent.cmd --agent 02 --screen application-list
.\run-agent.cmd --agent 03 --screen application-list
.\run-agent.cmd --agent 04 --screen application-list
.\run-agent.cmd --agent 05 --screen application-list
```

## Standardstruktur

```text
screens/<screen-id>/
  screen.json
  forms/
    intake.md
  docs/
    legacy-notes.md
    data-notes.md
  work-products/
    02-spec.md
    03-implementation.md
    04-test-plan.md
    05-review-fix.md
  review/
    review-findings.md
    review-status.json
```

Se `_template` for formatet.

## Minimum metadata

`screen.json` skal som minimum indeholde:

```json
{
  "id": "application-list",
  "title": "Ansøgningsliste",
  "status": "loaded"
}
```

Ekstra metadata er en workshopøvelse. Overvej selv hvilke felter der gør downstream-agenterne bedre, fx legacy-filer, target API, afhængigheder, forretningsregler, risici, afklaringer og næste agent.
