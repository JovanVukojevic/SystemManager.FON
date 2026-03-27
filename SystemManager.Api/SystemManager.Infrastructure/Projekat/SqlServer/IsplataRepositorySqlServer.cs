using Dapper;
using System.Data;
using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class IsplataRepositorySqlServer : IIsplataRepository
{
    private readonly ProjekatDbConnectionFactory _dbFactory;

    public IsplataRepositorySqlServer(ProjekatDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Isplata>> GetByRadnikIdAsync(long radnikId)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Isplata>(
            "api.usp_Isplata_GetByRadnikId",
            new { RadnikId = radnikId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<Isplata?> GetByIdAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        var result = await db.QueryAsync<Isplata, Radnik, Isplata>(
            "api.usp_Isplata_GetById",
            (isplata, radnik) =>
            {
                isplata.Radnik = radnik;
                return isplata;
            },
            new { IsplataId = id },
            splitOn: "RadnikId",
            commandType: CommandType.StoredProcedure);
        return result.FirstOrDefault();
    }

    public async Task CreateAsync(Isplata isplata)
    {
        using var db = _dbFactory.CreateConnection();
        isplata.IsplataId = await db.ExecuteScalarAsync<long>("api.usp_Isplata_Create",
            new { isplata.RadnikId, isplata.Datum, isplata.Iznos, isplata.Vrsta },
            commandType: CommandType.StoredProcedure);
    }

    public async Task UpdateAsync(Isplata isplata)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync("api.usp_Isplata_Update",
            new { isplata.IsplataId, isplata.RadnikId, isplata.Datum, isplata.Iznos, isplata.Vrsta },
            commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync("api.usp_Isplata_Delete",
            new { IsplataId = id },
            commandType: CommandType.StoredProcedure);
    }
}
