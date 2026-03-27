using Dapper;
using System.Data;
using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class IspitRepositorySqlServer : IIspitRepository
{
    private readonly IspitDbConnectionFactory _dbFactory;

    public IspitRepositorySqlServer(IspitDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Ispit>> GetAllIspitAsync(string? brojIndeksa)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_Ispit_GetAll";

        return await db.QueryAsync<Ispit, Student, Nastavnik, Zvanje, Predmet, Ispit>(
            sp,
            (ispit, student, nastavnik, zvanje, predmet) =>
            {
                ispit.Student = student;
                ispit.Predmet = predmet;
                nastavnik.Zvanje = zvanje;
                ispit.Nastavnik = nastavnik;

                return ispit;
            },
            new { BrojIndeksa = brojIndeksa },
            splitOn: "BrojIndeksa,IdNastavnik,IdZvanje,IdPredmet",
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<Ispit?> GetIspitByIdAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        var result = await db.QueryAsync<Ispit, Student, Nastavnik, Zvanje, Predmet, Ispit>(
            "api.usp_Ispit_GetById",
            (ispit, student, nastavnik, zvanje, predmet) =>
            {
                ispit.Student = student;
                ispit.Predmet = predmet;
                nastavnik.Zvanje = zvanje;
                ispit.Nastavnik = nastavnik;
                return ispit;
            },
            new { IdIspit = id },
            splitOn: "BrojIndeksa,IdNastavnik,IdZvanje,IdPredmet",
            commandType: CommandType.StoredProcedure);
        return result.FirstOrDefault();
    }

    public async Task InsertIspitAsync(Ispit i)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_Ispit_Create";

        i.IdIspit = await db.QuerySingleAsync<int>(sp, new
        {
            i.Ocena,
            i.DatumPolaganja,
            i.BrojIndeksa,
            i.IdPredmet,
            i.IdNastavnik
        }, commandType: CommandType.StoredProcedure);
    }

    public async Task UpdateIspitAsync(Ispit i)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_Ispit_Update";

        await db.ExecuteAsync(sp, new
        {
            i.IdIspit,
            i.Ocena,
            i.DatumPolaganja,
            i.BrojIndeksa,
            i.IdPredmet,
            i.IdNastavnik
        }, commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteIspitAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_Ispit_Delete";

        await db.ExecuteAsync(sp, new { IdIspit = id }, commandType: CommandType.StoredProcedure);
    }
}
