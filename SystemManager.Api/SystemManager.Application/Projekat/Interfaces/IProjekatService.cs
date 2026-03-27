using DomainProjekt = SystemManager.Domain.Projekat.Entities.Projekat;

namespace SystemManager.Application.Projekat.Interfaces;

public interface IProjekatService
{
    Task<IEnumerable<DomainProjekt>> GetAllAsync();
    Task<DomainProjekt?> GetByIdAsync(long id);
    Task CreateAsync(DomainProjekt projekat);
    Task UpdateAsync(DomainProjekt projekat);
    Task DeleteAsync(long id);
}
