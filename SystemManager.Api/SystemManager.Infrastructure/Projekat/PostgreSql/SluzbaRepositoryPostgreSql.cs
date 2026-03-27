using Dapper;
using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class SluzbaRepositoryPostgreSql : ISluzbaRepository
{
    private readonly ProjekatDbConnectionFactory _dbFactory;

    public SluzbaRepositoryPostgreSql(ProjekatDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Sluzba>> GetAllSluzbaAsync()
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Sluzba>("SELECT * FROM api.usp_sluzba_getall()");
    }

    public async Task<Sluzba?> GetSluzbaByIdAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryFirstOrDefaultAsync<Sluzba>(
            "SELECT * FROM api.usp_sluzba_getbyid(@SluzbaId)",
            new { SluzbaId = id });
    }

    public async Task InsertSluzbaAsync(Sluzba s)
    {
        using var db = _dbFactory.CreateConnection();
        s.SluzbaId = await db.ExecuteScalarAsync<long>(
            "SELECT api.usp_sluzba_create(@Naziv)",
            new { s.Naziv });
    }

    public async Task UpdateSluzbaAsync(Sluzba s)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_sluzba_update(@SluzbaId, @Naziv)",
            new { s.SluzbaId, s.Naziv });
    }

    public async Task DeleteSluzbaAsync(long id)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_sluzba_delete(@SluzbaId)",
            new { SluzbaId = id });
    }
}
