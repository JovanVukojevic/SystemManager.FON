using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Application.Projekat.Interfaces;

namespace SystemManager.Application.Projekat.Services;

public class SluzbaService : ISluzbaService
{
    private readonly ISluzbaRepository _repository;

    public SluzbaService(ISluzbaRepository repository)
    {
        _repository = repository;
    }

    public Task<IEnumerable<Sluzba>> GetAllAsync() =>
        _repository.GetAllSluzbaAsync();

    public Task<Sluzba?> GetByIdAsync(long id) =>
        _repository.GetSluzbaByIdAsync(id);

    public Task CreateAsync(Sluzba sluzba) =>
        _repository.InsertSluzbaAsync(sluzba);

    public Task UpdateAsync(Sluzba sluzba) =>
        _repository.UpdateSluzbaAsync(sluzba);

    public Task DeleteAsync(long id) =>
        _repository.DeleteSluzbaAsync(id);
}
