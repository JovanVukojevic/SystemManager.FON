namespace SystemManager.Infrastructure.Common;

public class ProjekatDbConnectionFactory : DbConnectionFactory
{
    public ProjekatDbConnectionFactory(string connectionString, DbProvider provider)
        : base(connectionString, provider) { }
}
