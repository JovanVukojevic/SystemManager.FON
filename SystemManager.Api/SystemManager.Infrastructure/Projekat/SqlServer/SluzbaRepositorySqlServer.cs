using Dapper;
using System.Data;
using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class SluzbaRepositorySqlServer : ISluzbaRepository
{
    private readonly ProjekatDbConnectionFactory _dbFactory;

    public SluzbaRepositorySqlServer(ProjekatDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Sluzba>> GetAllSluzbaAsync()
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Sluzba>("api.usp_Sluzba_GetAll",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<Sluzba?> GetSluzbaByIdAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryFirstOrDefaultAsync<Sluzba>(
            "api.usp_Sluzba_GetById",
            new { SluzbaId = id },
            commandType: CommandType.StoredProcedure);
    }

    public async Task InsertSluzbaAsync(Sluzba s)
    {
        using var db = _dbFactory.CreateConnection();
        s.SluzbaId = await db.ExecuteScalarAsync<long>("api.usp_Sluzba_Create",
            new { s.Naziv },
            commandType: CommandType.StoredProcedure);
    }

    public async Task UpdateSluzbaAsync(Sluzba s)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_Sluzba_Update";

        await db.ExecuteAsync(sp, new { s.SluzbaId, s.Naziv }, commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteSluzbaAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_Sluzba_Delete";

        await db.ExecuteAsync(sp, new { SluzbaId = id }, commandType: CommandType.StoredProcedure);
    }
}
