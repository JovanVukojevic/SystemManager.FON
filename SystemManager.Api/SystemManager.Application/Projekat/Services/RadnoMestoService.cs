using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Application.Projekat.Interfaces;

namespace SystemManager.Application.Projekat.Services;

public class RadnoMestoService : IRadnoMestoService
{
    private readonly IRadnoMestoRepository _repository;

    public RadnoMestoService(IRadnoMestoRepository repository)
    {
        _repository = repository;
    }

    public Task<IEnumerable<RadnoMesto>> GetAllAsync() =>
        _repository.GetAllRadnoMestoAsync();

    public Task<RadnoMesto?> GetByIdAsync(long id) =>
        _repository.GetRadnoMestoByIdAsync(id);

    public Task CreateAsync(RadnoMesto radnoMesto) =>
        _repository.InsertRadnoMestoAsync(radnoMesto);

    public Task UpdateAsync(RadnoMesto radnoMesto) =>
        _repository.UpdateRadnoMestoAsync(radnoMesto);

    public Task DeleteAsync(long id) =>
        _repository.DeleteRadnoMestoAsync(id);
}
