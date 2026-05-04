IF OBJECT_ID(N'dbo.Users', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Users
    (
        Username nvarchar(50) NOT NULL CONSTRAINT PK_Users PRIMARY KEY,
        PasswordText nvarchar(100) NOT NULL,
        DisplayName nvarchar(120) NOT NULL,
        RoleName nvarchar(30) NOT NULL,
        IsActive bit NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT (1),
        CreatedAt datetime NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT (GETDATE()),
        CONSTRAINT CK_Users_RoleName CHECK (RoleName IN ('admin', 'sagsbehandler', 'laeser'))
    );
END
GO

IF OBJECT_ID(N'dbo.GrantApplications', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.GrantApplications
    (
        Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_GrantApplications PRIMARY KEY,
        Title nvarchar(120) NOT NULL,
        ApplicantName nvarchar(120) NOT NULL,
        ApplicantEmail nvarchar(160) NULL,
        MunicipalityArea nvarchar(80) NULL,
        Amount decimal(18,2) NOT NULL,
        Status nvarchar(30) NOT NULL,
        Description nvarchar(max) NULL,
        DecisionNote nvarchar(max) NULL,
        CaseWorkerUserName nvarchar(50) NULL,
        CreatedAt datetime NOT NULL CONSTRAINT DF_GrantApplications_CreatedAt DEFAULT (GETDATE()),
        UpdatedAt datetime NOT NULL CONSTRAINT DF_GrantApplications_UpdatedAt DEFAULT (GETDATE()),
        SubmittedAt datetime NULL,
        CONSTRAINT CK_GrantApplications_Title CHECK (LEN(LTRIM(RTRIM(Title))) > 0),
        CONSTRAINT CK_GrantApplications_ApplicantName CHECK (LEN(LTRIM(RTRIM(ApplicantName))) > 0),
        CONSTRAINT CK_GrantApplications_Amount CHECK (Amount BETWEEN 1000 AND 500000),
        CONSTRAINT CK_GrantApplications_Status CHECK (Status IN ('KLADDE', 'INDSENDT', 'UNDER_BEHANDLING', 'GODKENDT', 'AFVIST'))
    );
END
GO

IF OBJECT_ID(N'dbo.GrantApplicationHistory', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.GrantApplicationHistory
    (
        Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_GrantApplicationHistory PRIMARY KEY,
        GrantApplicationId int NOT NULL,
        OldStatus nvarchar(30) NULL,
        NewStatus nvarchar(30) NOT NULL,
        ChangedBy nvarchar(50) NOT NULL,
        ChangedAt datetime NOT NULL CONSTRAINT DF_GrantApplicationHistory_ChangedAt DEFAULT (GETDATE()),
        Comment nvarchar(max) NULL,
        CONSTRAINT FK_GrantApplicationHistory_GrantApplications
            FOREIGN KEY (GrantApplicationId) REFERENCES dbo.GrantApplications(Id)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_GrantApplications_Status' AND object_id = OBJECT_ID(N'dbo.GrantApplications'))
BEGIN
    CREATE INDEX IX_GrantApplications_Status ON dbo.GrantApplications(Status);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_GrantApplications_ApplicantName' AND object_id = OBJECT_ID(N'dbo.GrantApplications'))
BEGIN
    CREATE INDEX IX_GrantApplications_ApplicantName ON dbo.GrantApplications(ApplicantName);
END
GO
