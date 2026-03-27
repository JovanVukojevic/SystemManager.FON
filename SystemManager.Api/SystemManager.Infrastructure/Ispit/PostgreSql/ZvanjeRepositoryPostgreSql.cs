using Dapper;
using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class ZvanjeRepositoryPostgreSql : IZvanjeRepository
{
    private readonly IspitDbConnectionFactory _dbFactory;

    public ZvanjeRepositoryPostgreSql(IspitDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Zvanje>> GetAllZvanjeAsync()
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Zvanje>("SELECT * FROM api.usp_zvanje_getall()");
    }

    public async Task<Zvanje?> GetZvanjeByIdAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryFirstOrDefaultAsync<Zvanje>(
            "SELECT * FROM api.usp_zvanje_getbyid(@IdZvanje)",
            new { IdZvanje = id });
    }

    public async Task InsertZvanjeAsync(Zvanje zvanje)
    {
        using var db = _dbFactory.CreateConnection();
        zvanje.IdZvanje = await db.ExecuteScalarAsync<int>(
            "SELECT api.usp_zvanje_create(@Naziv)",
            new { zvanje.Naziv });
    }

    public async Task UpdateZvanjeAsync(Zvanje zvanje)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_zvanje_update(@IdZvanje, @Naziv)",
            new { zvanje.IdZvanje, zvanje.Naziv });
    }

    public async Task DeleteZvanjeAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_zvanje_delete(@IdZvanje)",
            new { IdZvanje = id });
    }
}
