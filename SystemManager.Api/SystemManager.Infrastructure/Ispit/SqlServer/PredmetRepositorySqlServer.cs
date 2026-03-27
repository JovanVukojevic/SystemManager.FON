using Dapper;
using System.Data;
using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class PredmetRepositorySqlServer : IPredmetRepository
{
    private readonly IspitDbConnectionFactory _dbFactory;

    public PredmetRepositorySqlServer(IspitDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Predmet>> GetAllPredmetAsync()
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Predmet>("api.usp_Predmet_GetAll",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<Predmet?> GetPredmetByIdAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryFirstOrDefaultAsync<Predmet>(
            "api.usp_Predmet_GetById",
            new { IdPredmet = id },
            commandType: CommandType.StoredProcedure);
    }

    public async Task InsertPredmetAsync(Predmet p)
    {
        using var db = _dbFactory.CreateConnection();
        p.IdPredmet = await db.ExecuteScalarAsync<int>("api.usp_Predmet_Create",
            new { p.Naziv, p.ESPB },
            commandType: CommandType.StoredProcedure);
    }

    public async Task UpdatePredmetAsync(Predmet p)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_Predmet_Update";

        await db.ExecuteAsync(sp, new { p.IdPredmet, p.Naziv, p.ESPB }, commandType: CommandType.StoredProcedure);
    }

    public async Task DeletePredmetAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_Predmet_Delete";

        await db.ExecuteAsync(sp, new { IdPredmet = id }, commandType: CommandType.StoredProcedure);
    }
}
