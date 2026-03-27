namespace SystemManager.Domain.Ispit.Repositories;

public interface IIspitRepository
{
    Task<IEnumerable<Entities.Ispit>> GetAllIspitAsync(string? brojIndeksa);
    Task<Entities.Ispit?> GetIspitByIdAsync(int id);
    Task InsertIspitAsync(Entities.Ispit i);
    Task UpdateIspitAsync(Entities.Ispit i);
    Task DeleteIspitAsync(int id);
}
