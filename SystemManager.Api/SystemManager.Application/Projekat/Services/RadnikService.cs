using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Application.Projekat.Interfaces;

namespace SystemManager.Application.Projekat.Services;

public class RadnikService : IRadnikService
{
    private readonly IRadnikRepository _radnikRepo;

    public RadnikService(IRadnikRepository radnikRepo)
    {
        _radnikRepo = radnikRepo;
    }

    public async Task<IEnumerable<Radnik>> GetAllAsync()
    {
        return await _radnikRepo.GetAllRadnikAsync();
    }

    public async Task<Radnik?> GetByIdAsync(long id)
    {
        return await _radnikRepo.GetRadnikByIdAsync(id);
    }

    public Task CreateAsync(Radnik radnik) =>
        _radnikRepo.InsertRadnikAsync(radnik);

    public async Task UpdateAsync(Radnik radnik)
    {
        await _radnikRepo.UpdateRadnikAsync(radnik);
        await _radnikRepo.ReplaceUcestvujeByRadnikIdAsync(radnik.RadnikId, radnik.Projekti ?? []);
    }

    public Task DeleteAsync(long id) =>
        _radnikRepo.DeleteRadnikAsync(id);
}
