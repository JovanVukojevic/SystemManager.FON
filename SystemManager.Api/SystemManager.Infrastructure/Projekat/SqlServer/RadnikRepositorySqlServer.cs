using Dapper;
using System.Data;
using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class RadnikRepositorySqlServer : IRadnikRepository
{
    private readonly ProjekatDbConnectionFactory _dbFactory;

    public RadnikRepositorySqlServer(ProjekatDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Radnik>> GetAllRadnikAsync()
    {
        using var db = _dbFactory.CreateConnection();
        var radnikDict = new Dictionary<long, Radnik>();

        await db.QueryAsync<Radnik, RadnoMesto, Sluzba, Ucestvuje, Radnik>(
            "api.usp_Radnik_GetAll",
            (radnik, radnoMesto, sluzba, ucestvuje) =>
            {
                if (!radnikDict.TryGetValue(radnik.RadnikId, out var existing))
                {
                    radnik.RadnoMesto = radnoMesto;
                    radnik.Sluzba = sluzba;
                    radnik.Projekti = new List<Ucestvuje>();
                    radnik.Isplate = new List<Isplata>();
                    radnikDict[radnik.RadnikId] = radnik;
                    existing = radnik;
                }
                if (ucestvuje != null && ucestvuje.ProjekatId != 0)
                    existing.Projekti.Add(ucestvuje);
                return existing;
            },
            splitOn: "RadnoMestoId,SluzbaId,ProjekatId",
            commandType: CommandType.StoredProcedure);

        return radnikDict.Values;
    }

    public async Task<Radnik?> GetRadnikByIdAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        var radnikDict = new Dictionary<long, Radnik>();

        await db.QueryAsync<Radnik, RadnoMesto, Sluzba, Ucestvuje, Radnik>(
            "api.usp_Radnik_GetById",
            (radnik, radnoMesto, sluzba, ucestvuje) =>
            {
                if (!radnikDict.TryGetValue(radnik.RadnikId, out var existing))
                {
                    radnik.RadnoMesto = radnoMesto;
                    radnik.Sluzba = sluzba;
                    radnik.Projekti = new List<Ucestvuje>();
                    radnik.Isplate = new List<Isplata>();
                    radnikDict[radnik.RadnikId] = radnik;
                    existing = radnik;
                }
                if (ucestvuje != null && ucestvuje.ProjekatId != 0)
                    existing.Projekti.Add(ucestvuje);
                return existing;
            },
            new { RadnikId = id },
            splitOn: "RadnoMestoId,SluzbaId,ProjekatId",
            commandType: CommandType.StoredProcedure);

        return radnikDict.Values.FirstOrDefault();
    }

    public async Task<IEnumerable<Isplata>> GetIsplateByRadnikIdAsync(long radnikId)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Isplata>(
            "api.usp_Isplata_GetByRadnikId",
            new { RadnikId = radnikId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task InsertRadnikAsync(Radnik r)
    {
        using var db = _dbFactory.CreateConnection();
        r.RadnikId = await db.ExecuteScalarAsync<long>("api.usp_Radnik_Create",
            new { r.Ime, r.SluzbaId, r.RadnoMestoId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task UpdateRadnikAsync(Radnik r)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync("api.usp_Radnik_Update",
            new { r.RadnikId, r.Ime, r.SluzbaId, r.RadnoMestoId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteRadnikAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync("api.usp_Radnik_Delete",
            new { RadnikId = id },
            commandType: CommandType.StoredProcedure);
    }

    public async Task ReplaceUcestvujeByRadnikIdAsync(long radnikId, IEnumerable<Ucestvuje> assignments)
    {
        using var db = _dbFactory.CreateConnection();
        db.Open();
        using var tx = db.BeginTransaction();

        await db.ExecuteAsync("api.usp_Ucestvuje_DeleteByRadnikId",
            new { RadnikId = radnikId },
            tx,
            commandType: CommandType.StoredProcedure);

        foreach (var a in assignments)
        {
            await db.ExecuteAsync("api.usp_Ucestvuje_Insert",
                new { RadnikId = radnikId, a.ProjekatId, a.DatumOd, a.DatumDo },
                tx,
                commandType: CommandType.StoredProcedure);
        }

        tx.Commit();
    }
}
