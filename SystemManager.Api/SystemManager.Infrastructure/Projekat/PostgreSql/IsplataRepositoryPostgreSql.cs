using Dapper;
using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class IsplataRepositoryPostgreSql : IIsplataRepository
{
    private readonly ProjekatDbConnectionFactory _dbFactory;

    public IsplataRepositoryPostgreSql(ProjekatDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Isplata>> GetByRadnikIdAsync(long radnikId)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Isplata>(
            "SELECT * FROM api.usp_isplata_getbyradnikid(@RadnikId)",
            new { RadnikId = radnikId });
    }

    private const string IsplataJoinSelectColumns = """
        isplata_id, radnik_id, vrsta, datum, iznos,
        r_radnik_id, ime, r_radno_mesto_id AS radno_mesto_id, r_sluzba_id AS sluzba_id
        """;

    public async Task<Isplata?> GetByIdAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        var result = await db.QueryAsync<Isplata, Radnik, Isplata>(
            $"SELECT {IsplataJoinSelectColumns} FROM api.usp_isplata_getbyid(@IsplataId)",
            (isplata, radnik) =>
            {
                radnik.RadnikId = isplata.RadnikId;
                isplata.Radnik = radnik;
                return isplata;
            },
            new { IsplataId = id },
            splitOn: "r_radnik_id");
        return result.FirstOrDefault();
    }

    public async Task CreateAsync(Isplata isplata)
    {
        using var db = _dbFactory.CreateConnection();
        isplata.IsplataId = await db.ExecuteScalarAsync<long>(
            "SELECT api.usp_isplata_create(@RadnikId, @Datum, @Iznos, @Vrsta)",
            new { isplata.RadnikId, isplata.Datum, isplata.Iznos, isplata.Vrsta });
    }

    public async Task UpdateAsync(Isplata isplata)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_isplata_update(@IsplataId, @RadnikId, @Datum, @Iznos, @Vrsta)",
            new { isplata.IsplataId, isplata.RadnikId, isplata.Datum, isplata.Iznos, isplata.Vrsta });
    }

    public async Task DeleteAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_isplata_delete(@IsplataId)",
            new { IsplataId = id });
    }
}
