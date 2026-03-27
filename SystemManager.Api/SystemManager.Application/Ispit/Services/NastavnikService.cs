using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Application.Ispit.Interfaces;

namespace SystemManager.Application.Ispit.Services;

public class NastavnikService : INastavnikService
{
    private readonly INastavnikRepository _repository;

    public NastavnikService(INastavnikRepository repository)
    {
        _repository = repository;
    }

    public Task<IEnumerable<Nastavnik>> GetAllAsync() =>
        _repository.GetAllNastavnikAsync();

    public Task<Nastavnik?> GetByIdAsync(int id) =>
        _repository.GetNastavnikByIdAsync(id);

    public Task CreateAsync(Nastavnik nastavnik) =>
        _repository.InsertNastavnikAsync(nastavnik);

    public Task UpdateAsync(Nastavnik nastavnik) =>
        _repository.UpdateNastavnikAsync(nastavnik);

    public Task DeleteAsync(int id) =>
        _repository.DeleteNastavnikAsync(id);
}
