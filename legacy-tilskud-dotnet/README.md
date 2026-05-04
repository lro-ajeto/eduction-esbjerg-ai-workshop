# Legacy Tilskud .NET Framework

Koer databasen fra `../database` foerst:

```powershell
cd ..\database
.\init-database.ps1
```

Start derefter `LegacyTilskud.sln` i Visual Studio 2022 med IIS Express.

Databasen initialiseres ikke af Web Forms-applikationen.

## Loginbrugere

| Brugernavn | Password | Rolle |
| --- | --- | --- |
| `admin` | `admin123` | `admin` |
| `sagsbehandler` | `sag123` | `sagsbehandler` |
| `laeser` | `laes123` | `laeser` |
