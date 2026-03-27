using SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Application.Ispit.Interfaces;

public interface INastavnikService
{
    Task<IEnumerable<Nastavnik>> GetAllAsync();
    Task<Nastavnik?> GetByIdAsync(int id);
    Task CreateAsync(Nastavnik nastavnik);
    Task UpdateAsync(Nastavnik nastavnik);
    Task DeleteAsync(int id);
}
