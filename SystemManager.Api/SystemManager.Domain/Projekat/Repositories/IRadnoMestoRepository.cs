using SystemManager.Domain.Projekat.Entities;

namespace SystemManager.Domain.Projekat.Repositories;

public interface IRadnoMestoRepository
{
    Task<IEnumerable<RadnoMesto>> GetAllRadnoMestoAsync();
    Task<RadnoMesto?> GetRadnoMestoByIdAsync(long id);
    Task InsertRadnoMestoAsync(RadnoMesto rm);
    Task UpdateRadnoMestoAsync(RadnoMesto rm);
    Task DeleteRadnoMestoAsync(long id);
}
