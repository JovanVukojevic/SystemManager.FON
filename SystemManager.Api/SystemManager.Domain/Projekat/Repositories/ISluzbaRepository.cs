using SystemManager.Domain.Projekat.Entities;

namespace SystemManager.Domain.Projekat.Repositories;

public interface ISluzbaRepository
{
    Task<IEnumerable<Sluzba>> GetAllSluzbaAsync();
    Task<Sluzba?> GetSluzbaByIdAsync(long id);
    Task InsertSluzbaAsync(Sluzba s);
    Task UpdateSluzbaAsync(Sluzba s);
    Task DeleteSluzbaAsync(long id);
}
