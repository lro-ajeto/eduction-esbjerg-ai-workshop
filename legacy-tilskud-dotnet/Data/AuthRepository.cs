using System.Data.SqlClient;
using LegacyTilskud.Models;

namespace LegacyTilskud.Data
{
    public class AuthRepository
    {
        public AppUser FindUser(string username, string password)
        {
            using (var connection = tilskudDb.OpenConnection())
            using (var command = connection.CreateCommand())
            {
                command.CommandText = @"
SELECT Username, DisplayName, RoleName
FROM dbo.Users
WHERE Username = @username
  AND PasswordText = @password
  AND IsActive = 1";
                command.Parameters.AddWithValue("@username", username);
                command.Parameters.AddWithValue("@password", password);

                using (var reader = command.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        return null;
                    }

                    return new AppUser
                    {
                        Username = reader["Username"].ToString(),
                        DisplayName = reader["DisplayName"].ToString(),
                        RoleName = reader["RoleName"].ToString()
                    };
                }
            }
        }
    }
}
