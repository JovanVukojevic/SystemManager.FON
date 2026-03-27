using SystemManager.Domain.Projekat.Entities;

namespace SystemManager.Domain.Projekat.Repositories;

public interface IRadnikRepository
{
    Task<IEnumerable<Radnik>> GetAllRadnikAsync();
    Task<Radnik?> GetRadnikByIdAsync(long id);
    Task InsertRadnikAsync(Radnik r);
    Task UpdateRadnikAsync(Radnik r);
    Task DeleteRadnikAsync(long id);
    Task<IEnumerable<Isplata>> GetIsplateByRadnikIdAsync(long radnikId);
    Task ReplaceUcestvujeByRadnikIdAsync(long radnikId, IEnumerable<Ucestvuje> assignments);
}
