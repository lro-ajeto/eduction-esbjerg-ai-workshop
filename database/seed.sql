IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE Username = N'admin')
    INSERT INTO dbo.Users (Username, PasswordText, DisplayName, RoleName)
    VALUES (N'admin', N'admin123', N'Admin Bruger', N'admin');
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE Username = N'sagsbehandler')
    INSERT INTO dbo.Users (Username, PasswordText, DisplayName, RoleName)
    VALUES (N'sagsbehandler', N'sag123', N'Sagsbehandler Jensen', N'sagsbehandler');
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE Username = N'laeser')
    INSERT INTO dbo.Users (Username, PasswordText, DisplayName, RoleName)
    VALUES (N'laeser', N'laes123', N'Laeser Hansen', N'laeser');
GO

IF NOT EXISTS (SELECT 1 FROM dbo.GrantApplications)
BEGIN
    INSERT INTO dbo.GrantApplications
        (Title, ApplicantName, ApplicantEmail, MunicipalityArea, Amount, Status, Description, DecisionNote, CaseWorkerUserName, CreatedAt, UpdatedAt, SubmittedAt)
    VALUES
        (N'Sommerkoncerter paa Torvet', N'Esbjerg Musikforening', N'kontakt@esbjergmusik.example', N'Esbjerg By', 85000, N'INDSENDT',
         N'Foreningen soeger om stoette til fire gratis aftenkoncerter for lokale borgere i juli.',
         N'', N'sagsbehandler', DATEADD(day, -34, GETDATE()), DATEADD(day, -30, GETDATE()), DATEADD(day, -30, GETDATE())),
        (N'Nye redskaber til gymnastikhold', N'Ribe Idraetsforening', N'bestyrelse@ribeidraet.example', N'Ribe', 42000, N'UNDER_BEHANDLING',
         N'Udskiftning af slidte redskaber til boerne- og ungehold. Tilbud er vedlagt i papirarkiv.',
         N'Mangler dokumentation for medfinansiering.', N'sagsbehandler', DATEADD(day, -26, GETDATE()), DATEADD(day, -7, GETDATE()), DATEADD(day, -24, GETDATE())),
        (N'Kulturdag for nye borgere', N'Netvaerk Vestkysten', N'info@netvaerkvest.example', N'Esbjerg Nord', 120000, N'GODKENDT',
         N'Et heldagsarrangement med frivillige vaerter, madboder og introduktion til lokale tilbud.',
         N'Godkendt med fuldt beloeb. Stor lokal forankring.', N'admin', DATEADD(day, -72, GETDATE()), DATEADD(day, -40, GETDATE()), DATEADD(day, -65, GETDATE())),
        (N'Mobil scene til ungdomsteater', N'Ung Scene Esbjerg', N'projekt@ungscene.example', N'Esbjerg Oest', 275000, N'AFVIST',
         N'Anskaffelse af mobil scene til forestillinger paa skoler og biblioteker.',
         N'Afvist. Investeringen vurderes for stor i forhold til maalgruppen.', N'admin', DATEADD(day, -80, GETDATE()), DATEADD(day, -52, GETDATE()), DATEADD(day, -78, GETDATE())),
        (N'Lektiecafe i Skoedstrup', N'Frivilliggruppen Syd', N'kontakt@frivilligsyd.example', N'Skoedstrup', 18500, N'KLADDE',
         N'Ugentlig lektiehjaelp i beboerhuset med frivillige mentorer.',
         N'', N'laeser', DATEADD(day, -4, GETDATE()), DATEADD(day, -4, GETDATE()), NULL),
        (N'Naturformidling ved Marbaek', N'Naturvennerne', N'formand@naturvenner.example', N'Marbaek', 66500, N'INDSENDT',
         N'Guidede ture og undervisningsmateriale til skoleklasser om kystnatur og biodiversitet.',
         N'', N'sagsbehandler', DATEADD(day, -19, GETDATE()), DATEADD(day, -18, GETDATE()), DATEADD(day, -18, GETDATE())),
        (N'Fodbold for piger 10-14 aar', N'Boldklubben Strandby', N'ungdom@strandbybk.example', N'Esbjerg V', 31000, N'UNDER_BEHANDLING',
         N'Rekrutteringsforloeb, traenerkurser og udstyr til nye pigehold.',
         N'Afventer budgetopdeling mellem udstyr og arrangementer.', N'sagsbehandler', DATEADD(day, -42, GETDATE()), DATEADD(day, -9, GETDATE()), DATEADD(day, -41, GETDATE())),
        (N'Kreativt vaerksted for seniorer', N'Seniorhuset Midtbyen', N'leder@seniorhuset.example', N'Esbjerg Midtby', 22500, N'GODKENDT',
         N'Materialer og instruktoertimer til et aabent vaerksted hver onsdag.',
         N'Godkendt. Indsatsen supplerer eksisterende aktivitetstilbud.', N'sagsbehandler', DATEADD(day, -90, GETDATE()), DATEADD(day, -60, GETDATE()), DATEADD(day, -85, GETDATE())),
        (N'Lokalhistorisk digitalisering', N'Byarkivets Venner', N'arkiv@byarkivvenner.example', N'Ribe', 154000, N'INDSENDT',
         N'Digitalisering af billeder og interviews samt frivillig oplaering i registrering.',
         N'', N'admin', DATEADD(day, -11, GETDATE()), DATEADD(day, -10, GETDATE()), DATEADD(day, -10, GETDATE())),
        (N'Skateworkshops i ferien', N'Urban Ung', N'hello@urbanung.example', N'Esbjerg Havn', 47000, N'UNDER_BEHANDLING',
         N'Ferieaktiviteter for unge med instruktoerer, sikkerhedsudstyr og laan af boards.',
         N'Budgettet indeholder poster uden bilag.', N'sagsbehandler', DATEADD(day, -37, GETDATE()), DATEADD(day, -6, GETDATE()), DATEADD(day, -35, GETDATE())),
        (N'Faellesspisning i landsbyen', N'Beboerforeningen Grimstrup', N'grimstrup@forening.example', N'Grimstrup', 12500, N'KLADDE',
         N'Seks faellesspisninger med fokus paa nye naboer og aeldre borgere.',
         N'', N'laeser', DATEADD(day, -2, GETDATE()), DATEADD(day, -2, GETDATE()), NULL),
        (N'Robotklub for mellemtrinnet', N'Skolevenner Esbjerg', N'robot@skolevenner.example', N'Esbjerg Nord', 99000, N'GODKENDT',
         N'Indkoeb af robotkits og afholdelse af frivillige klubeftermiddage paa tre skoler.',
         N'Godkendt med krav om afsluttende aktivitetsrapport.', N'admin', DATEADD(day, -110, GETDATE()), DATEADD(day, -70, GETDATE()), DATEADD(day, -104, GETDATE()));
END
GO
