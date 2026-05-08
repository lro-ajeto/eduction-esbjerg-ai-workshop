# Quality contract

Alle agenter arbejder efter denne kvalitetskontrakt.

## Arbejdssprog

[//]: # (TODO)

## Scope

[//]: # (TODO)

## Sporbarhed

[//]: # (TODO)

## Test og evidens

Når en agent ændrer kode, skal agenten:

[//]: # (TODO)

## Sikkerhed og robusthed

Agenter skal eksplicit være opmærksomme på:

[//]: # (TODO)

## Reviewbarhed

Output skal være konkret:

[//]: # (TODO)

## Review-loop

Når agent 05 finder implementeringsfejl eller testfejl, skal den skrive `agentic-ai/screens/<screen-id>/review/review-status.json`.

Tilladte statusser:

- `satisfied`
- `needs-code-fix`
- `needs-test-fix`
- `blocked`

Hvis testfejl skyldes produktionskode, skal status være `needs-code-fix`, så agent 03 kan rette fejlen i næste iteration.
