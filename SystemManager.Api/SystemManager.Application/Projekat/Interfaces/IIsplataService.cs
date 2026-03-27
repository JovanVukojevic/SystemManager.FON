using SystemManager.Domain.Projekat.Entities;

namespace SystemManager.Application.Projekat.Interfaces;

public interface IIsplataService
{
    Task<IEnumerable<Isplata>> GetByRadnikIdAsync(long radnikId);
    Task<Isplata?> GetByIdAsync(long id);
    Task CreateAsync(Isplata isplata);
    Task UpdateAsync(Isplata isplata);
    Task DeleteAsync(long id);
}
