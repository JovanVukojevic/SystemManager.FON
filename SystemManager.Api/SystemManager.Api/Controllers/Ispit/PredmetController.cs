using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using SystemManager.Application.Ispit;
using SystemManager.Application.Ispit.Interfaces;
using SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Api.Controllers.Ispit;

[ApiController]
[Route("api/ispit/[controller]")]
public class PredmetController : ControllerBase
{
    private readonly IPredmetService _service;
    private readonly IMapper _mapper;

    public PredmetController(IPredmetService service, IMapper mapper)
    {
        _service = service;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<PredmetResponse>>> GetAll()
    {
        var result = await _service.GetAllAsync();
        return Ok(_mapper.Map<IEnumerable<PredmetResponse>>(result));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<PredmetResponse>> GetById(int id)
    {
        var result = await _service.GetByIdAsync(id);
        if (result is null) return NotFound();
        return Ok(_mapper.Map<PredmetResponse>(result));
    }

    [HttpPost]
    public async Task<ActionResult<PredmetResponse>> Create([FromBody] PredmetRequest request)
    {
        var entity = _mapper.Map<Predmet>(request);
        await _service.CreateAsync(entity);
        return CreatedAtAction(nameof(GetById), new { id = entity.IdPredmet },
            _mapper.Map<PredmetResponse>(entity));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, [FromBody] PredmetRequest request)
    {
        var existing = await _service.GetByIdAsync(id);
        if (existing is null) return NotFound();
        var entity = _mapper.Map<Predmet>(request);
        entity.IdPredmet = id;
        await _service.UpdateAsync(entity);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var existing = await _service.GetByIdAsync(id);
        if (existing is null) return NotFound();
        await _service.DeleteAsync(id);
        return NoContent();
    }
}
