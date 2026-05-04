USE master;
GO

IF DB_ID(N'LegacyTilskudWorkshop') IS NOT NULL
BEGIN
    ALTER DATABASE [LegacyTilskudWorkshop] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [LegacyTilskudWorkshop];
END
GO
