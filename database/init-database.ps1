$ErrorActionPreference = "Stop"

docker compose up -d

$password = "Tilskud_2026!"
$sqlcmd = (docker exec tilskud-sql bash -lc "if [ -x /opt/mssql-tools18/bin/sqlcmd ]; then echo /opt/mssql-tools18/bin/sqlcmd; elif [ -x /opt/mssql-tools/bin/sqlcmd ]; then echo /opt/mssql-tools/bin/sqlcmd; else echo sqlcmd; fi").Trim()

for ($i = 0; $i -lt 60; $i++) {
    docker exec tilskud-sql $sqlcmd -C -S localhost -U sa -P $password -Q "SELECT 1" *> $null
    if ($LASTEXITCODE -eq 0) {
        break
    }
    Start-Sleep -Seconds 2
}

if ($LASTEXITCODE -ne 0) {
    throw "SQL Server container did not become ready."
}

Get-Content -Raw -Encoding UTF8 create-database.sql | docker exec -i tilskud-sql $sqlcmd -C -S localhost -U sa -P $password -i /dev/stdin
Get-Content -Raw -Encoding UTF8 schema.sql | docker exec -i tilskud-sql $sqlcmd -C -S localhost -U sa -P $password -d LegacyTilskudWorkshop -i /dev/stdin
Get-Content -Raw -Encoding UTF8 seed.sql | docker exec -i tilskud-sql $sqlcmd -C -S localhost -U sa -P $password -d LegacyTilskudWorkshop -i /dev/stdin

Write-Host "Database is ready on localhost,14333 / LegacyTilskudWorkshop"
