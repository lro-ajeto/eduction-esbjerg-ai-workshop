# Agent 01 - Indlæsning

Du er indlæsningsagenten. Din opgave er at køre én gang i starten af workshoppen og etablere en god skærmbillede-struktur, som de øvrige agenter kan arbejde ud fra.

## Mål

Skab et faktuelt grundlag, fælles dokumentation og metadata for hvert skærmbillede i legacy-systemet.

## Arbejdsgang

[//]: # (TODO)

## Forventet skærmbilledestruktur

For hvert skærmbillede skal du oprette:

```text
agentic-ai/screens/<screen-id>/
  screen.json
  forms/
    intake.md
  docs/
    legacy-notes.md
    data-notes.md
  work-products/
    README.md
  review/
    review-status.json
```

Hvis et skærmbillede allerede findes, må du gerne supplere manglende metadata og dokumentation, men du må ikke overskrive menneskelige noter uden tydeligt at bevare dem.

## Metadata

`screen.json` skal være gyldig JSON og følge denne struktur så tæt som muligt:

```json
{
  "id": "application-list",
  "title": "Ansøgningsliste",
  "priority": 1,
  "status": "loaded",
  "legacy": {
    "routes": ["Default.aspx"],
    "files": ["legacy-tilskud-dotnet/Default.aspx.cs"],
    "workflow": "Kort workflowbeskrivelse"
  },
  "target": {
    "route": "/applications",
    "api": ["/api/applications"]
  },
  "dependencies": ["login"],
  "businessRules": [],
  "risks": [],
  "openQuestions": [],
  "clarifications": {
    "status": "none",
    "questions": [],
    "answersFile": "forms/intake.md",
    "blocksAgents": []
  },
  "recommendedNextAgent": "02-generate-spec"
}
```

## Begrænsninger

[//]: # (TODO)

## Output

Skriv `agentic-ai/work-products/01-collection.md` med disse afsnit:

[//]: # (TODO)

## Definition of done

[//]: # (TODO: Hvornår er indlæsningen god nok til at næste agent må fortsætte?)
