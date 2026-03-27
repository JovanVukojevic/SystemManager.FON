using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using SystemManager.Application.Projekat;
using SystemManager.Application.Projekat.Interfaces;
using SystemManager.Domain.Projekat.Entities;

namespace SystemManager.Api.Controllers.Projekat;

[ApiController]
[Route("api/projekat/[controller]")]
public class SluzbaController : ControllerBase
{
    private readonly ISluzbaService _service;
    private readonly IMapper _mapper;

    public SluzbaController(ISluzbaService service, IMapper mapper)
    {
        _service = service;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<SluzbaResponse>>> GetAll()
    {
        var result = await _service.GetAllAsync();
        return Ok(_mapper.Map<IEnumerable<SluzbaResponse>>(result));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<SluzbaResponse>> GetById(long id)
    {
        var result = await _service.GetByIdAsync(id);
        if (result is null) return NotFound();
        return Ok(_mapper.Map<SluzbaResponse>(result));
    }

    [HttpPost]
    public async Task<ActionResult<SluzbaResponse>> Create([FromBody] SluzbaRequest request)
    {
        var entity = _mapper.Map<Sluzba>(request);
        await _service.CreateAsync(entity);
        return CreatedAtAction(nameof(GetById), new { id = entity.SluzbaId },
            _mapper.Map<SluzbaResponse>(entity));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, [FromBody] SluzbaRequest request)
    {
        var existing = await _service.GetByIdAsync(id);
        if (existing is null) return NotFound();
        var entity = _mapper.Map<Sluzba>(request);
        entity.SluzbaId = id;
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
