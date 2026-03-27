using Dapper;
using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Infrastructure.Common;

namespace SystemManager.Infrastructure.Repositories;

public class StudentRepositoryPostgreSql : IStudentRepository
{
    private readonly IspitDbConnectionFactory _dbFactory;

    public StudentRepositoryPostgreSql(IspitDbConnectionFactory dbFactory)
    {
        _dbFactory = dbFactory;
    }

    public async Task<IEnumerable<Student>> GetAllStudentAsync()
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryAsync<Student>("SELECT * FROM api.usp_student_getall()");
    }

    public async Task<Student?> GetStudentByIdAsync(string brojIndeksa)
    {
        using var db = _dbFactory.CreateConnection();
        return await db.QueryFirstOrDefaultAsync<Student>(
            "SELECT * FROM api.usp_student_getbyid(@BrojIndeksa)",
            new { BrojIndeksa = brojIndeksa });
    }

    public async Task InsertStudentAsync(Student s)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_student_create(@BrojIndeksa, @Ime, @DatumRodjenja, @Semestar)",
            new { s.BrojIndeksa, s.Ime, s.DatumRodjenja, s.Semestar });
    }

    public async Task UpdateStudentAsync(Student s)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_student_update(@BrojIndeksa, @Ime, @DatumRodjenja, @Semestar)",
            new { s.BrojIndeksa, s.Ime, s.DatumRodjenja, s.Semestar });
    }

    public async Task DeleteStudentAsync(string brojIndeksa)
    {
        using var db = _dbFactory.CreateConnection();
        await db.ExecuteAsync(
            "SELECT api.usp_student_delete(@BrojIndeksa)",
            new { BrojIndeksa = brojIndeksa });
    }
}
