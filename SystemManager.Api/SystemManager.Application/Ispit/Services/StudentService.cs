using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Application.Ispit.Interfaces;

namespace SystemManager.Application.Ispit.Services;

public class StudentService : IStudentService
{
    private readonly IStudentRepository _repository;

    public StudentService(IStudentRepository repository)
    {
        _repository = repository;
    }

    public Task<IEnumerable<Student>> GetAllAsync() =>
        _repository.GetAllStudentAsync();

    public Task<Student?> GetByIdAsync(string brojIndeksa) =>
        _repository.GetStudentByIdAsync(brojIndeksa);

    public Task CreateAsync(Student student) =>
        _repository.InsertStudentAsync(student);

    public Task UpdateAsync(Student student) =>
        _repository.UpdateStudentAsync(student);

    public Task DeleteAsync(string brojIndeksa) =>
        _repository.DeleteStudentAsync(brojIndeksa);
}
