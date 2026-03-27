using SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Domain.Ispit.Repositories;

public interface IPredmetRepository
{
    Task<IEnumerable<Predmet>> GetAllPredmetAsync();
    Task<Predmet?> GetPredmetByIdAsync(int id);
    Task InsertPredmetAsync(Predmet p);
    Task UpdatePredmetAsync(Predmet p);
    Task DeletePredmetAsync(int id);
}
