using System.Data;
using Microsoft.Data.SqlClient;
using Npgsql;

namespace SystemManager.Infrastructure.Common;

public class DbConnectionFactory
{
    private readonly string _connectionString;
    private readonly DbProvider _provider;

    public DbConnectionFactory(string connectionString, DbProvider provider)
    {
        _connectionString = connectionString;
        _provider = provider;
    }

    public IDbConnection CreateConnection() => _provider switch
    {
        DbProvider.PostgreSql => new NpgsqlConnection(_connectionString),
        _ => new SqlConnection(_connectionString)
    };
}
