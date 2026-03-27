using SystemManager.Domain.Projekat.Entities;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Application.Projekat.Interfaces;
using DomainProjekt = SystemManager.Domain.Projekat.Entities.Projekat;

namespace SystemManager.Application.Projekat.Services;

public class ProjekatService : IProjekatService
{
    private readonly IProjekatRepository _projekatRepo;

    public ProjekatService(IProjekatRepository projekatRepo)
    {
        _projekatRepo = projekatRepo;
    }

    public async Task<IEnumerable<DomainProjekt>> GetAllAsync()
    {
        return await _projekatRepo.GetAllProjekatAsync();
    }

    public async Task<DomainProjekt?> GetByIdAsync(long id)
    {
        return await _projekatRepo.GetProjekatByIdAsync(id);
    }

    public Task CreateAsync(DomainProjekt projekat) =>
        _projekatRepo.InsertProjekatAsync(projekat);

    public async Task UpdateAsync(DomainProjekt projekat)
    {
        await _projekatRepo.UpdateProjekatAsync(projekat);
        await _projekatRepo.ReplaceUcestvujeByProjekatIdAsync(projekat.ProjekatId, projekat.Radnici ?? []);
        await _projekatRepo.SetRukovodiAsync(projekat.ProjekatId, projekat.RukovodiRadnikId);
    }

    public Task DeleteAsync(long id) =>
        _projekatRepo.DeleteProjekatAsync(id);
}
