using SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Application.Ispit.Interfaces;

public interface IZvanjeService
{
    Task<IEnumerable<Zvanje>> GetAllAsync();
    Task<Zvanje?> GetByIdAsync(int id);
    Task CreateAsync(Zvanje zvanje);
    Task UpdateAsync(Zvanje zvanje);
    Task DeleteAsync(int id);
}
