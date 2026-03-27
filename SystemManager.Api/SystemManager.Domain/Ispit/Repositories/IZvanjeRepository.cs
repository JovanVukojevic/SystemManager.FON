using SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Domain.Ispit.Repositories;

public interface IZvanjeRepository
{
    Task<IEnumerable<Zvanje>> GetAllZvanjeAsync();
    Task<Zvanje?> GetZvanjeByIdAsync(int id);
    Task InsertZvanjeAsync(Zvanje zvanje);
    Task UpdateZvanjeAsync(Zvanje zvanje);
    Task DeleteZvanjeAsync(int id);
}
