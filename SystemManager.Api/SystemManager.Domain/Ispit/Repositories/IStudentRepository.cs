using SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Domain.Ispit.Repositories;

public interface IStudentRepository
{
    Task<IEnumerable<Student>> GetAllStudentAsync();
    Task<Student?> GetStudentByIdAsync(string brojIndeksa);
    Task InsertStudentAsync(Student s);
    Task UpdateStudentAsync(Student s);
    Task DeleteStudentAsync(string brojIndeksa);
}
