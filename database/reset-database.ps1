$ErrorActionPreference = "Stop"

docker compose up -d

$password = "Tilskud_2026!"
$sqlcmd = (docker exec tilskud-sql bash -lc "if [ -x /opt/mssql-tools18/bin/sqlcmd ]; then echo /opt/mssql-tools18/bin/sqlcmd; elif [ -x /opt/mssql-tools/bin/sqlcmd ]; then echo /opt/mssql-tools/bin/sqlcmd; else echo sqlcmd; fi").Trim()

Get-Content -Raw -Encoding UTF8 reset-database.sql | docker exec -i tilskud-sql $sqlcmd -C -S localhost -U sa -P $password -i /dev/stdin
Get-Content -Raw -Encoding UTF8 create-database.sql | docker exec -i tilskud-sql $sqlcmd -C -S localhost -U sa -P $password -i /dev/stdin
Get-Content -Raw -Encoding UTF8 schema.sql | docker exec -i tilskud-sql $sqlcmd -C -S localhost -U sa -P $password -d LegacyTilskudWorkshop -i /dev/stdin
Get-Content -Raw -Encoding UTF8 seed.sql | docker exec -i tilskud-sql $sqlcmd -C -S localhost -U sa -P $password -d LegacyTilskudWorkshop -i /dev/stdin

Write-Host "Database has been reset."
