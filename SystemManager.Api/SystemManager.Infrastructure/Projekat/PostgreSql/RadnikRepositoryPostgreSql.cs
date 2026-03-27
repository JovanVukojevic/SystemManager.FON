using Dapper;
using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class RadnikRepositoryPostgreSql : IRadnikRepository
{
    private readonly ProjekatDbConnectionFactory _dbFactory;

    public RadnikRepositoryPostgreSql(ProjekatDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    private const string RadnikSelectColumns = """
        radnik_id, ime, radno_mesto_id, sluzba_id,
        rm_radno_mesto_id, rm_naziv AS naziv,
        s_sluzba_id, s_naziv AS naziv,
        projekat_id, u_radnik_id AS radnik_id, datum_od, datum_do
        """;

    private const string RadnikSplitOn = "rm_radno_mesto_id,s_sluzba_id,projekat_id";

    private Radnik MapRadnikRow(Radnik radnik, RadnoMesto radnoMesto, Sluzba sluzba,
        Ucestvuje ucestvuje, Dictionary<long, Radnik> dict)
    {
        if (!dict.TryGetValue(radnik.RadnikId, out var existing))
        {
            radnoMesto.RadnoMestoId = radnik.RadnoMestoId;
            sluzba.SluzbaId = radnik.SluzbaId;
            radnik.RadnoMesto = radnoMesto;
            radnik.Sluzba = sluzba;
            radnik.Projekti = new List<Ucestvuje>();
            radnik.Isplate = new List<Isplata>();
            dict[radnik.RadnikId] = radnik;
            existing = radnik;
        }
        if (ucestvuje != null && ucestvuje.ProjekatId != 0)
            existing.Projekti.Add(ucestvuje);
        return existing;
    }

    public async Task<IEnumerable<Radnik>> GetAllRadnikAsync()
    {
        using var db = _dbFactory.CreateConnection();
        var radnikDict = new Dictionary<long, Radnik>();

        await db.QueryAsync<Radnik, RadnoMesto, Sluzba, Ucestvuje, Radnik>(
            $"SELECT {RadnikSelectColumns} FROM api.usp_radnik_getall()",
            (radnik, radnoMesto, sluzba, ucestvuje) =>
                MapRadnikRow(radnik, radnoMesto, sluzba, ucestvuje, radnikDict),
            splitOn: RadnikSplitOn);

        return radnikDict.Values;
    }

    public async Task<Radnik?> GetRadnikByIdAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        var radnikDict = new Dictionary<long, Radnik>();

        await db.QueryAsync<Radnik, RadnoMesto, Sluzba, Ucestvuje, Radnik>(
            $"SELECT {RadnikSelectColumns} FROM api.usp_radnik_getbyid(@RadnikId)",
            (radnik, radnoMesto, sluzba, ucestvuje) =>
                MapRadnikRow(radnik, radnoMesto, sluzba, ucestvuje, radnikDict),
            new { RadnikId = id },
            splitOn: RadnikSplitOn);

        return radnikDict.Values.FirstOrDefault();
    }

    public async Task<IEnumerable<Isplata>> GetIsplateByRadnikIdAsync(long radnikId)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Isplata>(
            "SELECT * FROM api.usp_isplata_getbyradnikid(@RadnikId)",
            new { RadnikId = radnikId });
    }

    public async Task InsertRadnikAsync(Radnik r)
    {
        using var db = _dbFactory.CreateConnection();
        r.RadnikId = await db.ExecuteScalarAsync<long>(
            "SELECT api.usp_radnik_create(@Ime, @SluzbaId, @RadnoMestoId)",
            new { r.Ime, r.SluzbaId, r.RadnoMestoId });
    }

    public async Task UpdateRadnikAsync(Radnik r)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_radnik_update(@RadnikId, @Ime, @SluzbaId, @RadnoMestoId)",
            new { r.RadnikId, r.Ime, r.SluzbaId, r.RadnoMestoId });
    }

    public async Task DeleteRadnikAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_radnik_delete(@RadnikId)",
            new { RadnikId = id });
    }

    public async Task ReplaceUcestvujeByRadnikIdAsync(long radnikId, IEnumerable<Ucestvuje> assignments)
    {
        using var db = _dbFactory.CreateConnection();
        db.Open();
        using var tx = db.BeginTransaction();

        await db.ExecuteAsync(
            "SELECT api.usp_ucestvuje_deletebyradnikid(@RadnikId)",
            new { RadnikId = radnikId },
            tx);

        foreach (var a in assignments)
        {
            await db.ExecuteAsync(
                "SELECT api.usp_ucestvuje_insert(@RadnikId, @ProjekatId, @DatumOd, @DatumDo)",
                new { RadnikId = radnikId, a.ProjekatId, a.DatumOd, a.DatumDo },
                tx);
        }

        tx.Commit();
    }
}
