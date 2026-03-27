using Dapper;
using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Infrastructure.Common;
using Projekat = SystemManager.Domain.Projekat.Entities.Projekat;

namespace SystemManager.Infrastructure.Repositories;

public class ProjekatRepositoryPostgreSql : IProjekatRepository
{
    private readonly ProjekatDbConnectionFactory _dbFactory;

    public ProjekatRepositoryPostgreSql(ProjekatDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    private const string ProjekatSelectColumns = """
        projekat_id, naziv, budzet, klasa, rukovodi_radnik_id,
        radnik_id, u_projekat_id AS projekat_id, datum_od, datum_do
        """;

    public async Task<IEnumerable<Projekat>> GetAllProjekatAsync()
    {
        using var db = _dbFactory.CreateConnection();
        var projekatDict = new Dictionary<long, Projekat>();

        await db.QueryAsync<Projekat, Ucestvuje, Projekat>(
            $"SELECT {ProjekatSelectColumns} FROM api.usp_projekat_getall()",
            (projekat, ucestvuje) =>
            {
                if (!projekatDict.TryGetValue(projekat.ProjekatId, out var existing))
                {
                    projekat.Radnici = new List<Ucestvuje>();
                    projekatDict[projekat.ProjekatId] = projekat;
                    existing = projekat;
                }
                if (ucestvuje != null && ucestvuje.RadnikId != 0)
                    existing.Radnici.Add(ucestvuje);
                return existing;
            },
            splitOn: "radnik_id");

        return projekatDict.Values;
    }

    public async Task<Projekat?> GetProjekatByIdAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        var projekatDict = new Dictionary<long, Projekat>();

        await db.QueryAsync<Projekat, Ucestvuje, Projekat>(
            $"SELECT {ProjekatSelectColumns} FROM api.usp_projekat_getbyid(@ProjekatId)",
            (projekat, ucestvuje) =>
            {
                if (!projekatDict.TryGetValue(projekat.ProjekatId, out var existing))
                {
                    projekat.Radnici = new List<Ucestvuje>();
                    projekatDict[projekat.ProjekatId] = projekat;
                    existing = projekat;
                }
                if (ucestvuje != null && ucestvuje.RadnikId != 0)
                    existing.Radnici.Add(ucestvuje);
                return existing;
            },
            new { ProjekatId = id },
            splitOn: "radnik_id");

        return projekatDict.Values.FirstOrDefault();
    }

    public async Task InsertProjekatAsync(Projekat projekat)
    {
        using var db = _dbFactory.CreateConnection();
        projekat.ProjekatId = await db.ExecuteScalarAsync<long>(
            "SELECT api.usp_projekat_create(@Naziv, @Budzet)",
            new { projekat.Naziv, projekat.Budzet });
    }

    public async Task UpdateProjekatAsync(Projekat projekat)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_projekat_update(@ProjekatId, @Naziv, @Budzet)",
            new { projekat.ProjekatId, projekat.Naziv, projekat.Budzet });
    }

    public async Task DeleteProjekatAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_projekat_delete(@ProjekatId)",
            new { ProjekatId = id });
    }

    public async Task ReplaceUcestvujeByProjekatIdAsync(long projekatId, IEnumerable<Ucestvuje> assignments)
    {
        using var db = _dbFactory.CreateConnection();
        db.Open();
        using var tx = db.BeginTransaction();

        await db.ExecuteAsync(
            "SELECT api.usp_ucestvuje_deletebyprojekatid(@ProjekatId)",
            new { ProjekatId = projekatId },
            tx);

        foreach (var a in assignments)
        {
            await db.ExecuteAsync(
                "SELECT api.usp_ucestvuje_insert(@RadnikId, @ProjekatId, @DatumOd, @DatumDo)",
                new { RadnikId = a.RadnikId, ProjekatId = projekatId, a.DatumOd, a.DatumDo },
                tx);
        }

        tx.Commit();
    }

    public async Task SetRukovodiAsync(long projekatId, long? radnikId)
    {
        using var db = _dbFactory.CreateConnection();
        if (radnikId == null)
        {
            await db.ExecuteAsync(
                "SELECT api.usp_rukovodi_deletebyprojekatid(@ProjekatId)",
                new { ProjekatId = projekatId });
        }
        else
        {
            await db.ExecuteAsync(
                "SELECT api.usp_rukovodi_set(@ProjekatId, @RadnikId)",
                new { ProjekatId = projekatId, RadnikId = radnikId });
        }
    }
}
