using Dapper;
using System.Data;
using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Infrastructure.Common;
using Projekat = SystemManager.Domain.Projekat.Entities.Projekat;

namespace SystemManager.Infrastructure.Repositories;

public class ProjekatRepositorySqlServer : IProjekatRepository
{
    private readonly ProjekatDbConnectionFactory _dbFactory;

    public ProjekatRepositorySqlServer(ProjekatDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Projekat>> GetAllProjekatAsync()
    {
        using var db = _dbFactory.CreateConnection();
        var projekatDict = new Dictionary<long, Projekat>();

        await db.QueryAsync<Projekat, Ucestvuje, Projekat>(
            "api.usp_Projekat_GetAll",
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
            splitOn: "RadnikId",
            commandType: CommandType.StoredProcedure);

        return projekatDict.Values;
    }

    public async Task<Projekat?> GetProjekatByIdAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        var projekatDict = new Dictionary<long, Projekat>();

        await db.QueryAsync<Projekat, Ucestvuje, Projekat>(
            "api.usp_Projekat_GetById",
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
            splitOn: "RadnikId",
            commandType: CommandType.StoredProcedure);

        return projekatDict.Values.FirstOrDefault();
    }

    public async Task InsertProjekatAsync(Projekat projekat)
    {
        using var db = _dbFactory.CreateConnection();
        projekat.ProjekatId = await db.ExecuteScalarAsync<long>("api.usp_Projekat_Create",
            new { projekat.Naziv, projekat.Budzet },
            commandType: CommandType.StoredProcedure);
    }

    public async Task UpdateProjekatAsync(Projekat projekat)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync("api.usp_Projekat_Update",
            new { projekat.ProjekatId, projekat.Naziv, projekat.Budzet },
            commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteProjekatAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync("api.usp_Projekat_Delete",
            new { ProjekatId = id },
            commandType: CommandType.StoredProcedure);
    }

    public async Task ReplaceUcestvujeByProjekatIdAsync(long projekatId, IEnumerable<Ucestvuje> assignments)
    {
        using var db = _dbFactory.CreateConnection();
        db.Open();
        using var tx = db.BeginTransaction();

        await db.ExecuteAsync("api.usp_Ucestvuje_DeleteByProjekatId",
            new { ProjekatId = projekatId },
            tx,
            commandType: CommandType.StoredProcedure);

        foreach (var a in assignments)
        {
            await db.ExecuteAsync("api.usp_Ucestvuje_Insert",
                new { RadnikId = a.RadnikId, ProjekatId = projekatId, a.DatumOd, a.DatumDo },
                tx,
                commandType: CommandType.StoredProcedure);
        }

        tx.Commit();
    }

    public async Task SetRukovodiAsync(long projekatId, long? radnikId)
    {
        using var db = _dbFactory.CreateConnection();
        if (radnikId == null)
        {
            await db.ExecuteAsync("api.usp_Rukovodi_DeleteByProjekatId",
                new { ProjekatId = projekatId },
                commandType: CommandType.StoredProcedure);
        }
        else
        {
            await db.ExecuteAsync("api.usp_Rukovodi_Set",
                new { ProjekatId = projekatId, RadnikId = radnikId },
                commandType: CommandType.StoredProcedure);
        }
    }
}
