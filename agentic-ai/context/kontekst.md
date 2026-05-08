# Kontekst

[//]: # (TODO)

## Projekter

- `legacy-tilskud-dotnet`: legacy ASP.NET Web Forms-systemet og den primære kilde til eksisterende adfærd.
- `database`: SQL Server schema og seed-data, som bruges til at forstå datamodel, statusser og forretningsregler.
- `migrerings-projekt`: target-projektet, bygget med Spring Boot og React.
- `agentic-ai`: workshopstyring, agentprompter, kontekst, skærmbilledemapper og handoff-artefakter.

## Arbejdsmodel

Flowet er skærmbillededrevet:

1. Agent 01 kortlægger legacy-systemet og opretter skærmbilledemapper.
2. Agent 02 skriver en testbar specifikation for ét skærmbillede.
3. Agent 03 implementerer eller retter den vertikale slice.
4. Agent 04 tilføjer relevante tests.
5. Agent 05 reviewer kode, test og sporbarhed.
6. Agent 06 orkestrerer det samlede flow med Agents SDK.

Agent 02-05 arbejder på ét skærmbillede ad gangen og får kontekst fra `agentic-ai/screens/<screen-id>/`.

## Handoff

Handoff mellem mennesker og agenter sker via filer, ikke via chat-hukommelse.

Vigtige filer:

- `agentic-ai/work-products/01-collection.md`
- `agentic-ai/screens/<screen-id>/screen.json`
- `agentic-ai/screens/<screen-id>/forms/intake.md`
- `agentic-ai/screens/<screen-id>/docs/*.md`
- `agentic-ai/screens/<screen-id>/work-products/*.md`
- `agentic-ai/screens/<screen-id>/review/review-findings.md`
- `agentic-ai/screens/<screen-id>/review/review-status.json`

Hvis et menneske svarer på et spørgsmål eller ændrer scope, skal svaret skrives i den relevante markdown-fil og om nødvendigt afspejles i `screen.json`.

## Afklaringer

Blokerende afklaringer styres maskinlæsbart i `screen.json`:

```json
{
  "clarifications": {
    "status": "needed",
    "questions": ["Spørgsmål der skal besvares"],
    "answersFile": "forms/intake.md",
    "blocksAgents": ["03-generate-code"]
  }
}
```

Når spørgsmålet er besvaret i `answersFile`, sættes `clarifications.status` tilbage til `none`, og `questions` / `blocksAgents` tømmes.

`openQuestions` kan bruges til ikke-blokerende noter. Kun `clarifications.status: "needed"` stopper orkestratoren.
