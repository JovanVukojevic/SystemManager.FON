using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using SystemManager.Application.Projekat;
using SystemManager.Application.Projekat.Interfaces;
using SystemManager.Domain.Projekat.Entities;
using DomainProjekt = SystemManager.Domain.Projekat.Entities.Projekat;

namespace SystemManager.Api.Controllers.Projekat;

[ApiController]
[Route("api/projekat/[controller]")]
public class ProjekatController : ControllerBase
{
    private readonly IProjekatService _service;
    private readonly IMapper _mapper;

    public ProjekatController(IProjekatService service, IMapper mapper)
    {
        _service = service;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<ProjekatResponse>>> GetAll()
    {
        var result = await _service.GetAllAsync();
        return Ok(_mapper.Map<IEnumerable<ProjekatResponse>>(result));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ProjekatResponse>> GetById(long id)
    {
        var result = await _service.GetByIdAsync(id);
        if (result is null) return NotFound();
        return Ok(_mapper.Map<ProjekatResponse>(result));
    }

    [HttpPost]
    public async Task<ActionResult<ProjekatResponse>> Create([FromBody] ProjekatRequest request)
    {
        var entity = _mapper.Map<DomainProjekt>(request);
        await _service.CreateAsync(entity);
        return CreatedAtAction(nameof(GetById), new { id = entity.ProjekatId },
            _mapper.Map<ProjekatResponse>(entity));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, [FromBody] ProjekatRequest request)
    {
        var existing = await _service.GetByIdAsync(id);
        if (existing is null) return NotFound();
        var entity = _mapper.Map<DomainProjekt>(request);
        entity.ProjekatId = id;
        entity.Radnici = _mapper.Map<List<Ucestvuje>>(request.Radnici);
        entity.RukovodiRadnikId = request.RukovodiRadnikId;
        await _service.UpdateAsync(entity);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(long id)
    {
        var existing = await _service.GetByIdAsync(id);
        if (existing is null) return NotFound();
        await _service.DeleteAsync(id);
        return NoContent();
    }
}
