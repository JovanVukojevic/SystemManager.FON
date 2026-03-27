using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Application.Ispit.Interfaces;

namespace SystemManager.Application.Ispit.Services;

public class ZvanjeService : IZvanjeService
{
    private readonly IZvanjeRepository _repository;

    public ZvanjeService(IZvanjeRepository repository)
    {
        _repository = repository;
    }

    public Task<IEnumerable<Zvanje>> GetAllAsync() =>
        _repository.GetAllZvanjeAsync();

    public Task<Zvanje?> GetByIdAsync(int id) =>
        _repository.GetZvanjeByIdAsync(id);

    public Task CreateAsync(Zvanje zvanje) =>
        _repository.InsertZvanjeAsync(zvanje);

    public Task UpdateAsync(Zvanje zvanje) =>
        _repository.UpdateZvanjeAsync(zvanje);

    public Task DeleteAsync(int id) =>
        _repository.DeleteZvanjeAsync(id);
}
