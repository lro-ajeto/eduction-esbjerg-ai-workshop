using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace LegacyTilskud.Data
{
    // Old-style helper used directly by pages and repositories.
    public static class tilskudDb
    {
        public static string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["TilskudDb"].ConnectionString; }
        }

        public static SqlConnection OpenConnection()
        {
            var connection = new SqlConnection(ConnectionString);
            connection.Open();
            return connection;
        }

        public static SqlCommand CreateCommand(string sql, SqlConnection connection)
        {
            var command = connection.CreateCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = sql;
            return command;
        }
    }
}
