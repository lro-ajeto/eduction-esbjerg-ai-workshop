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

Læs først oversigten herunder for at forstå, hvilken opgave hver agent har.

Bemærk: I materialet bruger vi ordet "skærmbillede" om en afgrænset del af legacy-systemet, som skal moderniseres. Det kan være en side, formular, tabel, view, brugerflow, beregning eller anden sammenhængende funktion. Det betyder ikke et screenshot.

| Agent | Fil | Hvad skal deltagerne tage stilling til? |
| --- | --- | --- |
| 01 Indlæsning | `agents/01-collection/prompt.md` | Hvordan legacy-skærmbilleder opdages, hvilken metadata der skal oprettes, og hvornår indlæsning er god nok. |
| 02 Spec | `agents/02-generate-spec/prompt.md` | Hvordan en god, testbar specifikation skal struktureres. |
| 03 Kode | `agents/03-generate-code/prompt.md` | Hvordan kodeagenten holder scope, dokumenterer ændringer og reagerer på reviewfund. |
| 04 Test | `agents/04-generate-tests/prompt.md` | Hvilken teststrategi der passer til projektet, og hvad nok test betyder. |
| 05 Review | `agents/05-review-fix/prompt.md` | Hvordan reviewfund prioriteres, og hvornår status skal være `satisfied`, `needs-code-fix`, `needs-test-fix` eller `blocked`. |
| 06 Orkestrator | `agents/06-orchestrator/orchestrator.py` | Byg orkestratoren, hvis der er tid. |

Udfyld derefter TODO'erne i alle agenters promptfiler i ``agents\{agent-folder}\prompt.md``.
Overvej, hvad der er vigtigt, hvis du selv skulle udføre opgaven. Medtag de instruktioner, krav og afgrænsninger, som agenten skal bruge for at løse opgaven korrekt.
Skriv så meget som nødvendigt, men ikke mere end det. Kortere prompts sparer tokens og gør agenten mere fokuseret. Prøv derfor at kondensere teksten, så den stadig indeholder den samme vigtige information, men uden gentagelser eller unødvendige forklaringer.
Brug gerne LLM'er til at skrive dem.

## 3. Tilpas skabelonen for skærmbilleder

I denne opgave skal I forbedre den skabelon, som Agent 01 bruger, når den opretter et nyt skærmbillede.

Et skærmbillede er en afgrænset del af legacy-systemet, som skal moderniseres. Det kan være en side, et brugerflow, en formular, en beregning eller en anden sammenhængende funktion.

Åbn skabelonfilerne:

- `screens/_template/screen.json`
- `screens/_template/forms/intake.md`
- `screens/_template/docs/legacy-notes.md`
- `screens/_template/docs/data-notes.md`
- `screens/_template/review/review-status.json`

`screen.json` starter med kun de mest basale felter:

```json
{
  "id": "screen-id",
  "title": "Skærmbilledetitel",
  "status": "loaded"
}
```

Det er nok til at registrere, at skærmbilledet findes, men ikke nok til at hjælpe de næste agenter.

Jeres opgave er derfor at beslutte, hvilken ekstra information der bør følge med hvert skærmbillede, så de næste agenter nemmere kan:
- skrive en præcis specifikation
- implementere løsningen korrekt
- skrive relevante tests
- reviewe løsningen
- identificere uklarheder og risici tidligt

Tænk på skabelonen som en kontrakt mellem Agent 01 og resten af agent-kæden. Jo bedre metadata Agent 01 gemmer, jo mindre skal de næste agenter gætte.

Relevante metadatafelter kan for eksempel være:

- priority: Hvor vigtig skærmen er
- legacy: Hvad vi ved om den gamle løsning
- target: Hvad den nye løsning skal ende med at gøre
- dependencies: Andre skærme, API'er, databaser eller systemer den afhænger af
- businessRules: Regler, beregninger eller valideringer, som skal bevares
- risks: Ting der kan give fejl, forsinkelser eller misforståelser
- openQuestions: Spørgsmål der skal afklares
- clarifications: Afklaringer der allerede er fundet
- artefacts: Links eller referencer til relevante filer, screenshots, noter eller tests
- recommendedNextAgent: Hvilken agent der bør arbejde videre med screenen

I skal ikke nødvendigvis bruge alle felterne. Vælg kun de felter, der giver reel værdi for de næste agenter.

Målet er at gøre skabelonen informativ nok til, at downstream-agenterne kan arbejde målrettet, men stadig kort nok til ikke at fylde unødigt i konteksten.
## 4. Tjek workflowet

Åbn:

- `workflow.json`

Her kan du se agenternes rækkefølge, hvilke filer de læser, og hvilke filer de forventes at skrive.

Normalt skal du ikke ændre runneren:

- `run-agent.cmd`
- `scripts/run_agent.py`
- `scripts/runners.py`

## 5. Runner-konfiguration

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


## 6. Kør agenterne
Kør for at generere template setuppet:
```powershell
.\run-agent.cmd --agent 01
```

Du finder det genererede `<screen-id>` under `screens\_template`.

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

### Review loop
Vi vil have at agent flowet starter forfra hvis agenterne der tjekker kvalitet, fortæller at arbejdet ikke lever op til de krav vi har stillet.
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

Hvis review-status ikke er `"satisfied"`, skal kode-, test- og reviewagenten køres igen, indtil reviewet er tilfreds:

```powershell
.\run-agent.cmd --agent 03 --screen <screen-id>
.\run-agent.cmd --agent 04 --screen <screen-id>
.\run-agent.cmd --agent 05 --screen <screen-id>
```


Vigtige handoff-filer:

- `screens/<screen-id>/screen.json`
- `screens/<screen-id>/forms/intake.md`
- `screens/<screen-id>/review/review-status.json`
- `screens/<screen-id>/work-products/`

## 7. Workshopens vigtigste spørgsmål

Når en agent har kørt, så spørg:

- Var agentens scope tydeligt?
- Var outputtet testbart?
- Kan vi se evidens i filer?
- Er der noget agenten gættede på?
- Skal et menneske godkende noget før næste agent?
- Skal review sende arbejdet tilbage til kode- eller testagenten?
