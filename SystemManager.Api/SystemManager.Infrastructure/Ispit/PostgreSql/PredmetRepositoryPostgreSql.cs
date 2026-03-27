using Dapper;
using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class PredmetRepositoryPostgreSql : IPredmetRepository
{
    private readonly IspitDbConnectionFactory _dbFactory;

    public PredmetRepositoryPostgreSql(IspitDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Predmet>> GetAllPredmetAsync()
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Predmet>("SELECT * FROM api.usp_predmet_getall()");
    }

    public async Task<Predmet?> GetPredmetByIdAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryFirstOrDefaultAsync<Predmet>(
            "SELECT * FROM api.usp_predmet_getbyid(@IdPredmet)",
            new { IdPredmet = id });
    }

    public async Task InsertPredmetAsync(Predmet p)
    {
        using var db = _dbFactory.CreateConnection();
        p.IdPredmet = await db.ExecuteScalarAsync<int>(
            "SELECT api.usp_predmet_create(@Naziv, @ESPB)",
            new { p.Naziv, p.ESPB });
    }

    public async Task UpdatePredmetAsync(Predmet p)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_predmet_update(@IdPredmet, @Naziv, @ESPB)",
            new { p.IdPredmet, p.Naziv, p.ESPB });
    }

    public async Task DeletePredmetAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_predmet_delete(@IdPredmet)",
            new { IdPredmet = id });
    }
}
