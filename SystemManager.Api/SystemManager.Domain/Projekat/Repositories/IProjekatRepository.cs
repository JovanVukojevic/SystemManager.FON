using SystemManager.Domain.Projekat.Entities;

namespace SystemManager.Domain.Projekat.Repositories;

public interface IProjekatRepository
{
    Task<IEnumerable<Entities.Projekat>> GetAllProjekatAsync();
    Task<Entities.Projekat?> GetProjekatByIdAsync(long id);
    Task InsertProjekatAsync(Entities.Projekat projekat);
    Task UpdateProjekatAsync(Entities.Projekat projekat);
    Task DeleteProjekatAsync(long id);
    Task ReplaceUcestvujeByProjekatIdAsync(long projekatId, IEnumerable<Ucestvuje> assignments);
    Task SetRukovodiAsync(long projekatId, long? radnikId);
}
