using SystemManager.Domain.Projekat.Entities;

namespace SystemManager.Application.Projekat.Interfaces;

public interface IRadnikService
{
    Task<IEnumerable<Radnik>> GetAllAsync();
    Task<Radnik?> GetByIdAsync(long id);
    Task CreateAsync(Radnik radnik);
    Task UpdateAsync(Radnik radnik);
    Task DeleteAsync(long id);
}
