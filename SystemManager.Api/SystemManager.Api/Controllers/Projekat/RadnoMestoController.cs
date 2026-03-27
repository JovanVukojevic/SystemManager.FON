using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using SystemManager.Application.Projekat;
using SystemManager.Application.Projekat.Interfaces;
using SystemManager.Domain.Projekat.Entities;

namespace SystemManager.Api.Controllers.Projekat;

[ApiController]
[Route("api/projekat/[controller]")]
public class RadnoMestoController : ControllerBase
{
    private readonly IRadnoMestoService _service;
    private readonly IMapper _mapper;

    public RadnoMestoController(IRadnoMestoService service, IMapper mapper)
    {
        _service = service;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<RadnoMestoResponse>>> GetAll()
    {
        var result = await _service.GetAllAsync();
        return Ok(_mapper.Map<IEnumerable<RadnoMestoResponse>>(result));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<RadnoMestoResponse>> GetById(long id)
    {
        var result = await _service.GetByIdAsync(id);
        if (result is null) return NotFound();
        return Ok(_mapper.Map<RadnoMestoResponse>(result));
    }

    [HttpPost]
    public async Task<ActionResult<RadnoMestoResponse>> Create([FromBody] RadnoMestoRequest request)
    {
        var entity = _mapper.Map<RadnoMesto>(request);
        await _service.CreateAsync(entity);
        return CreatedAtAction(nameof(GetById), new { id = entity.RadnoMestoId },
            _mapper.Map<RadnoMestoResponse>(entity));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, [FromBody] RadnoMestoRequest request)
    {
        var existing = await _service.GetByIdAsync(id);
        if (existing is null) return NotFound();
        var entity = _mapper.Map<RadnoMesto>(request);
        entity.RadnoMestoId = id;
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
