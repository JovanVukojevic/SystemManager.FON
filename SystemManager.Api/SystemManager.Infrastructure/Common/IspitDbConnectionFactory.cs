namespace SystemManager.Infrastructure.Common;

public class IspitDbConnectionFactory : DbConnectionFactory
{
    public IspitDbConnectionFactory(string connectionString, DbProvider provider)
        : base(connectionString, provider) { }
}
