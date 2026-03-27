using SystemManager.Domain.Ispit.Entities;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Application.Ispit.Interfaces;

namespace SystemManager.Application.Ispit.Services;

public class PredmetService : IPredmetService
{
    private readonly IPredmetRepository _repository;

    public PredmetService(IPredmetRepository repository)
    {
        _repository = repository;
    }

    public Task<IEnumerable<Predmet>> GetAllAsync() =>
        _repository.GetAllPredmetAsync();

    public Task<Predmet?> GetByIdAsync(int id) =>
        _repository.GetPredmetByIdAsync(id);

    public Task CreateAsync(Predmet predmet) =>
        _repository.InsertPredmetAsync(predmet);

    public Task UpdateAsync(Predmet predmet) =>
        _repository.UpdatePredmetAsync(predmet);

    public Task DeleteAsync(int id) =>
        _repository.DeletePredmetAsync(id);
}
