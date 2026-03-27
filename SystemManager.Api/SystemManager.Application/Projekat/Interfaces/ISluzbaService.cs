using SystemManager.Domain.Projekat.Entities;

namespace SystemManager.Application.Projekat.Interfaces;

public interface ISluzbaService
{
    Task<IEnumerable<Sluzba>> GetAllAsync();
    Task<Sluzba?> GetByIdAsync(long id);
    Task CreateAsync(Sluzba sluzba);
    Task UpdateAsync(Sluzba sluzba);
    Task DeleteAsync(long id);
}
