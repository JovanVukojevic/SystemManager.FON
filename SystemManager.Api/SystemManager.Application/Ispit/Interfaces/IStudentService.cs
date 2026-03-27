using SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Application.Ispit.Interfaces;

public interface IStudentService
{
    Task<IEnumerable<Student>> GetAllAsync();
    Task<Student?> GetByIdAsync(string brojIndeksa);
    Task CreateAsync(Student student);
    Task UpdateAsync(Student student);
    Task DeleteAsync(string brojIndeksa);
}
