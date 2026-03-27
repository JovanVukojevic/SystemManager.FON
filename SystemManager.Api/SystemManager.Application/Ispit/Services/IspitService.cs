using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Application.Ispit.Interfaces;
using Entities = SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Application.Ispit.Services;

public class IspitService : IIspitService
{
    private readonly IIspitRepository _repository;

    public IspitService(IIspitRepository repository)
    {
        _repository = repository;
    }

    public Task<IEnumerable<Entities.Ispit>> GetAllAsync() =>
        _repository.GetAllIspitAsync(null);

    public Task<Entities.Ispit?> GetByIdAsync(int id) =>
        _repository.GetIspitByIdAsync(id);

    public Task CreateAsync(Entities.Ispit ispit) =>
        _repository.InsertIspitAsync(ispit);

    public Task UpdateAsync(Entities.Ispit ispit) =>
        _repository.UpdateIspitAsync(ispit);

    public Task DeleteAsync(int id) =>
        _repository.DeleteIspitAsync(id);
}
