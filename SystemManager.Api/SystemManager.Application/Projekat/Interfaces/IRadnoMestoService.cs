using SystemManager.Domain.Projekat.Entities;

namespace SystemManager.Application.Projekat.Interfaces;

public interface IRadnoMestoService
{
    Task<IEnumerable<RadnoMesto>> GetAllAsync();
    Task<RadnoMesto?> GetByIdAsync(long id);
    Task CreateAsync(RadnoMesto radnoMesto);
    Task UpdateAsync(RadnoMesto radnoMesto);
    Task DeleteAsync(long id);
}
