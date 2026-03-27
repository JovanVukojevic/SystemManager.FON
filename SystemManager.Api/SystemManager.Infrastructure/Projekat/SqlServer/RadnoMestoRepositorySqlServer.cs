using Dapper;
using System.Data;
using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class RadnoMestoRepositorySqlServer : IRadnoMestoRepository
{
    private readonly ProjekatDbConnectionFactory _dbFactory;

    public RadnoMestoRepositorySqlServer(ProjekatDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<RadnoMesto>> GetAllRadnoMestoAsync()
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<RadnoMesto>("api.usp_RadnoMesto_GetAll",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<RadnoMesto?> GetRadnoMestoByIdAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryFirstOrDefaultAsync<RadnoMesto>(
            "api.usp_RadnoMesto_GetById",
            new { RadnoMestoId = id },
            commandType: CommandType.StoredProcedure);
    }

    public async Task InsertRadnoMestoAsync(RadnoMesto rm)
    {
        using var db = _dbFactory.CreateConnection();
        rm.RadnoMestoId = await db.ExecuteScalarAsync<long>("api.usp_RadnoMesto_Create",
            new { rm.Naziv },
            commandType: CommandType.StoredProcedure);
    }

    public async Task UpdateRadnoMestoAsync(RadnoMesto rm)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_RadnoMesto_Update";

        await db.ExecuteAsync(sp, new { rm.RadnoMestoId, rm.Naziv }, commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteRadnoMestoAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_RadnoMesto_Delete";

        await db.ExecuteAsync(sp, new { RadnoMestoId = id }, commandType: CommandType.StoredProcedure);
    }
}
