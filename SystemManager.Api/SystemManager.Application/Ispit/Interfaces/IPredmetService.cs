using SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Application.Ispit.Interfaces;

public interface IPredmetService
{
    Task<IEnumerable<Predmet>> GetAllAsync();
    Task<Predmet?> GetByIdAsync(int id);
    Task CreateAsync(Predmet predmet);
    Task UpdateAsync(Predmet predmet);
    Task DeleteAsync(int id);
}
