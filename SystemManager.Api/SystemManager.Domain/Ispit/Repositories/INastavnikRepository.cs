using SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Domain.Ispit.Repositories;

public interface INastavnikRepository
{
    Task<IEnumerable<Nastavnik>> GetAllNastavnikAsync();
    Task<Nastavnik?> GetNastavnikByIdAsync(int id);
    Task InsertNastavnikAsync(Nastavnik n);
    Task UpdateNastavnikAsync(Nastavnik n);
    Task DeleteNastavnikAsync(int id);
}
