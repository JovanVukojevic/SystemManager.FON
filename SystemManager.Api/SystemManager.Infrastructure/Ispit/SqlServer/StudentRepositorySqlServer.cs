using Dapper;
using System.Data;
using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class StudentRepositorySqlServer : IStudentRepository
{
    private readonly IspitDbConnectionFactory _dbFactory;

    public StudentRepositorySqlServer(IspitDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Student>> GetAllStudentAsync()
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Student>("api.usp_Student_GetAll",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<Student?> GetStudentByIdAsync(string brojIndeksa)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryFirstOrDefaultAsync<Student>(
            "api.usp_Student_GetById",
            new { BrojIndeksa = brojIndeksa },
            commandType: CommandType.StoredProcedure);
    }

    public async Task InsertStudentAsync(Student s)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync("api.usp_Student_Create",
            new { s.BrojIndeksa, s.Ime, s.DatumRodjenja, s.Semestar },
            commandType: CommandType.StoredProcedure);
    }

    public async Task UpdateStudentAsync(Student s)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_Student_Update";

        await db.ExecuteAsync(sp, new { s.BrojIndeksa, s.Ime, s.DatumRodjenja, s.Semestar }, commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteStudentAsync(string brojIndeksa)
    {
        using var db = _dbFactory.CreateConnection();
        const string sp = "api.usp_Student_Delete";

        await db.ExecuteAsync(sp, new { BrojIndeksa = brojIndeksa }, commandType: CommandType.StoredProcedure);
    }
}
