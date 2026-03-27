using Entities = SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Application.Ispit.Interfaces;

public interface IIspitService
{
    Task<IEnumerable<Entities.Ispit>> GetAllAsync();
    Task<Entities.Ispit?> GetByIdAsync(int id);
    Task CreateAsync(Entities.Ispit ispit);
    Task UpdateAsync(Entities.Ispit ispit);
    Task DeleteAsync(int id);
}
