using Dapper;
using System.Data;
using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class NastavnikRepositorySqlServer : INastavnikRepository
{
    private readonly IspitDbConnectionFactory _dbFactory;

    public NastavnikRepositorySqlServer(IspitDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Nastavnik>> GetAllNastavnikAsync()
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_Nastavnik_GetAll";

        return await db.QueryAsync<Nastavnik, Zvanje, Nastavnik>(
            sp,
            (nastavnik, zvanje) =>
            {
                nastavnik.Zvanje = zvanje;
                return nastavnik;
            },
            splitOn: "IdZvanje",
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<Nastavnik?> GetNastavnikByIdAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        var result = await db.QueryAsync<Nastavnik, Zvanje, Nastavnik>(
            "api.usp_Nastavnik_GetById",
            (nastavnik, zvanje) => { nastavnik.Zvanje = zvanje; return nastavnik; },
            new { IdNastavnik = id },
            splitOn: "IdZvanje",
            commandType: CommandType.StoredProcedure);
        return result.FirstOrDefault();
    }

    public async Task InsertNastavnikAsync(Nastavnik n)
    {
        using var db = _dbFactory.CreateConnection();
        n.IdNastavnik = await db.ExecuteScalarAsync<int>("api.usp_Nastavnik_Create",
            new { n.Ime, n.IdZvanje },
            commandType: CommandType.StoredProcedure);
    }

    public async Task UpdateNastavnikAsync(Nastavnik n)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_Nastavnik_Update";

        await db.ExecuteAsync(sp, new { n.IdNastavnik, n.Ime, n.IdZvanje }, commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteNastavnikAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_Nastavnik_Delete";

        await db.ExecuteAsync(sp, new { IdNastavnik = id }, commandType: CommandType.StoredProcedure);
    }

}
