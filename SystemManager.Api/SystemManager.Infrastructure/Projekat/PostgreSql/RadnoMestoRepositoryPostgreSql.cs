using Dapper;
using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class RadnoMestoRepositoryPostgreSql : IRadnoMestoRepository
{
    private readonly ProjekatDbConnectionFactory _dbFactory;

    public RadnoMestoRepositoryPostgreSql(ProjekatDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<RadnoMesto>> GetAllRadnoMestoAsync()
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<RadnoMesto>("SELECT * FROM api.usp_radnomesto_getall()");
    }

    public async Task<RadnoMesto?> GetRadnoMestoByIdAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryFirstOrDefaultAsync<RadnoMesto>(
            "SELECT * FROM api.usp_radnomesto_getbyid(@RadnoMestoId)",
            new { RadnoMestoId = id });
    }

    public async Task InsertRadnoMestoAsync(RadnoMesto rm)
    {
        using var db = _dbFactory.CreateConnection();
        rm.RadnoMestoId = await db.ExecuteScalarAsync<long>(
            "SELECT api.usp_radnomesto_create(@Naziv)",
            new { rm.Naziv });
    }

    public async Task UpdateRadnoMestoAsync(RadnoMesto rm)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_radnomesto_update(@RadnoMestoId, @Naziv)",
            new { rm.RadnoMestoId, rm.Naziv });
    }

    public async Task DeleteRadnoMestoAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_radnomesto_delete(@RadnoMestoId)",
            new { RadnoMestoId = id });
    }
}
