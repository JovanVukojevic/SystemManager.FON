using SystemManager.Domain.Projekat.Entities;

namespace SystemManager.Domain.Projekat.Repositories;

public interface IIsplataRepository
{
    Task<IEnumerable<Isplata>> GetByRadnikIdAsync(long radnikId);
    Task<Isplata?> GetByIdAsync(long id);
    Task CreateAsync(Isplata isplata);
    Task UpdateAsync(Isplata isplata);
    Task DeleteAsync(long id);
}
