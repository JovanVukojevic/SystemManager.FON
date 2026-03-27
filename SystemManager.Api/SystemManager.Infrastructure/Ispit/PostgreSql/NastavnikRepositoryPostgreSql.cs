using Dapper;
using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class NastavnikRepositoryPostgreSql : INastavnikRepository
{
    private readonly IspitDbConnectionFactory _dbFactory;

    public NastavnikRepositoryPostgreSql(IspitDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Nastavnik>> GetAllNastavnikAsync()
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Nastavnik, Zvanje, Nastavnik>(
            "SELECT * FROM api.usp_nastavnik_getall()",
            (nastavnik, zvanje) =>
            {
                nastavnik.Zvanje = zvanje;
                return nastavnik;
            },
            splitOn: "id_zvanje"
        );
    }

    public async Task<Nastavnik?> GetNastavnikByIdAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        var result = await db.QueryAsync<Nastavnik, Zvanje, Nastavnik>(
            "SELECT * FROM api.usp_nastavnik_getbyid(@IdNastavnik)",
            (nastavnik, zvanje) => { nastavnik.Zvanje = zvanje; return nastavnik; },
            new { IdNastavnik = id },
            splitOn: "id_zvanje");
        return result.FirstOrDefault();
    }

    public async Task InsertNastavnikAsync(Nastavnik n)
    {
        using var db = _dbFactory.CreateConnection();
        n.IdNastavnik = await db.ExecuteScalarAsync<int>(
            "SELECT api.usp_nastavnik_create(@Ime, @IdZvanje)",
            new { n.Ime, n.IdZvanje });
    }

    public async Task UpdateNastavnikAsync(Nastavnik n)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_nastavnik_update(@IdNastavnik, @Ime, @IdZvanje)",
            new { n.IdNastavnik, n.Ime, n.IdZvanje });
    }

    public async Task DeleteNastavnikAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_nastavnik_delete(@IdNastavnik)",
            new { IdNastavnik = id });
    }

}
