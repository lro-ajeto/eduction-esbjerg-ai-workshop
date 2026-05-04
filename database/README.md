# Database

Shared SQL Server database for both legacy Web Forms and the Spring Boot migration project.

```powershell
cd database
.\init-database.ps1
```

Connection values:

- Server: `localhost,14333`
- Database: `LegacyTilskudWorkshop`
- User: `sa`
- Password: `Tilskud_2026!`

Reset:

```powershell
.\reset-database.ps1
```
