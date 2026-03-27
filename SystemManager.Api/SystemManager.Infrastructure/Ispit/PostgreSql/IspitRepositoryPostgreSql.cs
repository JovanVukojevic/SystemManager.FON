using Dapper;
using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Infrastructure.Common;
using Ispit = SystemManager.Domain.Ispit.Entities.Ispit;

namespace SystemManager.Infrastructure.Repositories;

public class IspitRepositoryPostgreSql : IIspitRepository
{
    private readonly IspitDbConnectionFactory _dbFactory;

    public IspitRepositoryPostgreSql(IspitDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    private const string IspitSelectColumns = """
        id_ispit, ocena, datum_polaganja, broj_indeksa, i_id_predmet, id_nastavnik,
        s_broj_indeksa, s_ime AS ime, datum_rodjenja, semestar, starost, prosecna_ocena,
        n_id_nastavnik, ime, id_zvanje,
        z_id_zvanje, naziv,
        id_predmet, p_naziv AS naziv, espb
        """;

    private const string IspitSplitOn = "s_broj_indeksa,n_id_nastavnik,z_id_zvanje,id_predmet";

    private static Ispit MapIspit(Ispit ispit, Student student, Nastavnik nastavnik, Zvanje zvanje, Predmet predmet)
    {
        student.BrojIndeksa = ispit.BrojIndeksa;
        nastavnik.IdNastavnik = ispit.IdNastavnik;
        zvanje.IdZvanje = nastavnik.IdZvanje;

        ispit.Student = student;
        ispit.Predmet = predmet;
        nastavnik.Zvanje = zvanje;
        ispit.Nastavnik = nastavnik;
        return ispit;
    }

    public async Task<IEnumerable<Ispit>> GetAllIspitAsync(string? brojIndeksa)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Ispit, Student, Nastavnik, Zvanje, Predmet, Ispit>(
            $"SELECT {IspitSelectColumns} FROM api.usp_ispit_getall(@BrojIndeksa)",
            MapIspit,
            new { BrojIndeksa = brojIndeksa },
            splitOn: IspitSplitOn
        );
    }

    public async Task<Ispit?> GetIspitByIdAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        var result = await db.QueryAsync<Ispit, Student, Nastavnik, Zvanje, Predmet, Ispit>(
            $"SELECT {IspitSelectColumns} FROM api.usp_ispit_getbyid(@IdIspit)",
            MapIspit,
            new { IdIspit = id },
            splitOn: IspitSplitOn);
        return result.FirstOrDefault();
    }

    public async Task InsertIspitAsync(Ispit i)
    {
        using var db = _dbFactory.CreateConnection();
        i.IdIspit = await db.QuerySingleAsync<int>(
            "SELECT api.usp_ispit_create(@Ocena, @DatumPolaganja, @BrojIndeksa, @IdPredmet, @IdNastavnik)",
            new
            {
                i.Ocena,
                i.DatumPolaganja,
                i.BrojIndeksa,
                i.IdPredmet,
                i.IdNastavnik
            });
    }

    public async Task UpdateIspitAsync(Ispit i)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_ispit_update(@IdIspit, @Ocena, @DatumPolaganja, @BrojIndeksa, @IdPredmet, @IdNastavnik)",
            new
            {
                i.IdIspit,
                i.Ocena,
                i.DatumPolaganja,
                i.BrojIndeksa,
                i.IdPredmet,
                i.IdNastavnik
            });
    }

    public async Task DeleteIspitAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_ispit_delete(@IdIspit)",
            new { IdIspit = id });
    }
}
