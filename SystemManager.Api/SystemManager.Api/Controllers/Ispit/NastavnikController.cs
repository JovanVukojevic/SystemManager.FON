using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using SystemManager.Application.Ispit;
using SystemManager.Application.Ispit.Interfaces;
using SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Api.Controllers.Ispit;

[ApiController]
[Route("api/ispit/[controller]")]
public class NastavnikController : ControllerBase
{
    private readonly INastavnikService _service;
    private readonly IMapper _mapper;

    public NastavnikController(INastavnikService service, IMapper mapper)
    {
        _service = service;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<NastavnikResponse>>> GetAll()
    {
        var result = await _service.GetAllAsync();
        return Ok(_mapper.Map<IEnumerable<NastavnikResponse>>(result));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<NastavnikResponse>> GetById(int id)
    {
        var result = await _service.GetByIdAsync(id);
        if (result is null) return NotFound();
        return Ok(_mapper.Map<NastavnikResponse>(result));
    }

    [HttpPost]
    public async Task<ActionResult<NastavnikResponse>> Create([FromBody] NastavnikRequest request)
    {
        var entity = _mapper.Map<Nastavnik>(request);
        await _service.CreateAsync(entity);
        return CreatedAtAction(nameof(GetById), new { id = entity.IdNastavnik },
            _mapper.Map<NastavnikResponse>(entity));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, [FromBody] NastavnikRequest request)
    {
        var existing = await _service.GetByIdAsync(id);
        if (existing is null) return NotFound();
        var entity = _mapper.Map<Nastavnik>(request);
        entity.IdNastavnik = id;
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
