using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using LegacyTilskud.Models;

namespace LegacyTilskud.Data
{
    public class GrantApplicationRepository
    {
        public IList<GrantApplication> Search(string query, string status)
        {
            var results = new List<GrantApplication>();
            using (var connection = tilskudDb.OpenConnection())
            using (var command = connection.CreateCommand())
            {
                command.CommandText = @"
SELECT Id, Title, ApplicantName, ApplicantEmail, MunicipalityArea, Amount, Status,
       Description, DecisionNote, CaseWorkerUserName, CreatedAt, UpdatedAt, SubmittedAt
FROM dbo.GrantApplications
WHERE (@query = '' OR Title LIKE @likeQuery OR ApplicantName LIKE @likeQuery OR MunicipalityArea LIKE @likeQuery)
  AND (@status = '' OR Status = @status)
ORDER BY UpdatedAt DESC, Id DESC";
                command.Parameters.AddWithValue("@query", query ?? string.Empty);
                command.Parameters.AddWithValue("@likeQuery", "%" + (query ?? string.Empty) + "%");
                command.Parameters.AddWithValue("@status", status ?? string.Empty);

                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        results.Add(Map(reader));
                    }
                }
            }

            return results;
        }

        public GrantApplication GetById(int id)
        {
            using (var connection = tilskudDb.OpenConnection())
            using (var command = connection.CreateCommand())
            {
                command.CommandText = @"
SELECT Id, Title, ApplicantName, ApplicantEmail, MunicipalityArea, Amount, Status,
       Description, DecisionNote, CaseWorkerUserName, CreatedAt, UpdatedAt, SubmittedAt
FROM dbo.GrantApplications
WHERE Id = @id";
                command.Parameters.AddWithValue("@id", id);

                using (var reader = command.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        return null;
                    }

                    return Map(reader);
                }
            }
        }

        public int Insert(GrantApplication application, string currentUser)
        {
            using (var connection = tilskudDb.OpenConnection())
            using (var command = connection.CreateCommand())
            {
                command.CommandText = @"
INSERT INTO dbo.GrantApplications
    (Title, ApplicantName, ApplicantEmail, MunicipalityArea, Amount, Status, Description,
     DecisionNote, CaseWorkerUserName, CreatedAt, UpdatedAt, SubmittedAt)
OUTPUT INSERTED.Id
VALUES
    (@title, @applicantName, @applicantEmail, @municipalityArea, @amount, 'KLADDE', @description,
     @decisionNote, @caseWorker, GETDATE(), GETDATE(), NULL)";
                AddApplicationParameters(command, application, currentUser);
                return Convert.ToInt32(command.ExecuteScalar());
            }
        }

        public bool Update(GrantApplication application, string currentUser)
        {
            using (var connection = tilskudDb.OpenConnection())
            using (var command = connection.CreateCommand())
            {
                command.CommandText = @"
UPDATE dbo.GrantApplications
SET Title = @title,
    ApplicantName = @applicantName,
    ApplicantEmail = @applicantEmail,
    MunicipalityArea = @municipalityArea,
    Amount = @amount,
    Description = @description,
    DecisionNote = @decisionNote,
    CaseWorkerUserName = @caseWorker,
    UpdatedAt = GETDATE()
WHERE Id = @id
  AND Status NOT IN ('GODKENDT', 'AFVIST')";
                command.Parameters.AddWithValue("@id", application.Id);
                AddApplicationParameters(command, application, currentUser);
                return command.ExecuteNonQuery() > 0;
            }
        }

        public bool ChangeStatus(int id, string newStatus, string changedBy, string decisionNote)
        {
            using (var connection = tilskudDb.OpenConnection())
            using (var transaction = connection.BeginTransaction())
            using (var command = connection.CreateCommand())
            {
                command.Transaction = transaction;
                command.CommandText = @"
DECLARE @oldStatus nvarchar(30);
SELECT @oldStatus = Status FROM dbo.GrantApplications WHERE Id = @id;

UPDATE dbo.GrantApplications
SET Status = @newStatus,
    DecisionNote = CASE WHEN @decisionNote = '' THEN DecisionNote ELSE @decisionNote END,
    CaseWorkerUserName = @changedBy,
    SubmittedAt = CASE WHEN @newStatus = 'INDSENDT' AND SubmittedAt IS NULL THEN GETDATE() ELSE SubmittedAt END,
    UpdatedAt = GETDATE()
WHERE Id = @id
  AND Status NOT IN ('GODKENDT', 'AFVIST');

IF @@ROWCOUNT > 0
BEGIN
    INSERT INTO dbo.GrantApplicationHistory
        (GrantApplicationId, OldStatus, NewStatus, ChangedBy, ChangedAt, Comment)
    VALUES
        (@id, @oldStatus, @newStatus, @changedBy, GETDATE(), @decisionNote);
END";
                command.Parameters.AddWithValue("@id", id);
                command.Parameters.AddWithValue("@newStatus", newStatus);
                command.Parameters.AddWithValue("@changedBy", changedBy ?? string.Empty);
                command.Parameters.AddWithValue("@decisionNote", decisionNote ?? string.Empty);

                var affected = command.ExecuteNonQuery();
                transaction.Commit();
                return affected > 0;
            }
        }

        public IList<StatusSummary> GetStatusSummaries()
        {
            var rows = new List<StatusSummary>();
            using (var connection = tilskudDb.OpenConnection())
            using (var command = connection.CreateCommand())
            {
                command.CommandText = @"
SELECT Status, COUNT(1) AS Antal, SUM(Amount) AS SamletBeloeb
FROM dbo.GrantApplications
GROUP BY Status
ORDER BY CASE Status
    WHEN 'KLADDE' THEN 1
    WHEN 'INDSENDT' THEN 2
    WHEN 'UNDER_BEHANDLING' THEN 3
    WHEN 'GODKENDT' THEN 4
    WHEN 'AFVIST' THEN 5
    ELSE 99
END";

                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        rows.Add(new StatusSummary
                        {
                            Status = reader["Status"].ToString(),
                            Count = Convert.ToInt32(reader["Antal"]),
                            TotalAmount = Convert.ToDecimal(reader["SamletBeloeb"])
                        });
                    }
                }
            }

            var max = 1;
            foreach (var row in rows)
            {
                if (row.Count > max)
                {
                    max = row.Count;
                }
            }

            foreach (var row in rows)
            {
                row.BarWidth = Math.Max(8, (int)Math.Round((row.Count * 100.0) / max));
            }

            return rows;
        }

        private static void AddApplicationParameters(SqlCommand command, GrantApplication application, string currentUser)
        {
            command.Parameters.AddWithValue("@title", application.Title ?? string.Empty);
            command.Parameters.AddWithValue("@applicantName", application.ApplicantName ?? string.Empty);
            command.Parameters.AddWithValue("@applicantEmail", application.ApplicantEmail ?? string.Empty);
            command.Parameters.AddWithValue("@municipalityArea", application.MunicipalityArea ?? string.Empty);
            command.Parameters.AddWithValue("@amount", application.Amount);
            command.Parameters.AddWithValue("@description", application.Description ?? string.Empty);
            command.Parameters.AddWithValue("@decisionNote", application.DecisionNote ?? string.Empty);
            command.Parameters.AddWithValue("@caseWorker", currentUser ?? string.Empty);
        }

        private static GrantApplication Map(SqlDataReader reader)
        {
            return new GrantApplication
            {
                Id = Convert.ToInt32(reader["Id"]),
                Title = reader["Title"].ToString(),
                ApplicantName = reader["ApplicantName"].ToString(),
                ApplicantEmail = reader["ApplicantEmail"].ToString(),
                MunicipalityArea = reader["MunicipalityArea"].ToString(),
                Amount = Convert.ToDecimal(reader["Amount"]),
                Status = reader["Status"].ToString(),
                Description = reader["Description"].ToString(),
                DecisionNote = reader["DecisionNote"].ToString(),
                CaseWorkerUserName = reader["CaseWorkerUserName"].ToString(),
                CreatedAt = Convert.ToDateTime(reader["CreatedAt"]),
                UpdatedAt = Convert.ToDateTime(reader["UpdatedAt"]),
                SubmittedAt = reader["SubmittedAt"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["SubmittedAt"])
            };
        }
    }
}
