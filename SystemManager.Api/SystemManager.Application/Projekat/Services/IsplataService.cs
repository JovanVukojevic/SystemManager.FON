using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Application.Projekat.Interfaces;

namespace SystemManager.Application.Projekat.Services;

public class IsplataService : IIsplataService
{
    private readonly IIsplataRepository _isplataRepo;

    public IsplataService(IIsplataRepository isplataRepo)
    {
        _isplataRepo = isplataRepo;
    }

    public Task<IEnumerable<Isplata>> GetByRadnikIdAsync(long radnikId) =>
        _isplataRepo.GetByRadnikIdAsync(radnikId);

    public Task<Isplata?> GetByIdAsync(long id) =>
        _isplataRepo.GetByIdAsync(id);

    public Task CreateAsync(Isplata isplata) =>
        _isplataRepo.CreateAsync(isplata);

    public Task UpdateAsync(Isplata isplata) =>
        _isplataRepo.UpdateAsync(isplata);

    public Task DeleteAsync(long id) =>
        _isplataRepo.DeleteAsync(id);
}
