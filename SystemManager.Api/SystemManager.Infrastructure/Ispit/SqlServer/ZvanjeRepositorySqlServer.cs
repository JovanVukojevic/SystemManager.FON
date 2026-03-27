using Dapper;
using System.Data;
using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class ZvanjeRepositorySqlServer : IZvanjeRepository
{
    private readonly IspitDbConnectionFactory _dbFactory;

    public ZvanjeRepositorySqlServer(IspitDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Zvanje>> GetAllZvanjeAsync()
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Zvanje>("api.usp_Zvanje_GetAll",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<Zvanje?> GetZvanjeByIdAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryFirstOrDefaultAsync<Zvanje>("api.usp_Zvanje_GetById",
            new { IdZvanje = id },
            commandType: CommandType.StoredProcedure);
    }

    public async Task InsertZvanjeAsync(Zvanje zvanje)
    {
        using var db = _dbFactory.CreateConnection();
        zvanje.IdZvanje = await db.ExecuteScalarAsync<int>("api.usp_Zvanje_Create",
            new { zvanje.Naziv },
            commandType: CommandType.StoredProcedure);
    }

    public async Task UpdateZvanjeAsync(Zvanje zvanje)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync("api.usp_Zvanje_Update",
            new { zvanje.IdZvanje, zvanje.Naziv },
            commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteZvanjeAsync(int id)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync("api.usp_Zvanje_Delete",
            new { IdZvanje = id },
            commandType: CommandType.StoredProcedure);
    }
}
