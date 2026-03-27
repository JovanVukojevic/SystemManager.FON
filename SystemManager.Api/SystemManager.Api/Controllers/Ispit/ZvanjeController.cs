using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using SystemManager.Application.Ispit;
using SystemManager.Application.Ispit.Interfaces;
using SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Api.Controllers.Ispit;

[ApiController]
[Route("api/ispit/[controller]")]
public class ZvanjeController : ControllerBase
{
    private readonly IZvanjeService _service;
    private readonly IMapper _mapper;

    public ZvanjeController(IZvanjeService service, IMapper mapper)
    {
        _service = service;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<ZvanjeResponse>>> GetAll()
    {
        var result = await _service.GetAllAsync();
        return Ok(_mapper.Map<IEnumerable<ZvanjeResponse>>(result));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ZvanjeResponse>> GetById(int id)
    {
        var result = await _service.GetByIdAsync(id);
        if (result is null) return NotFound();
        return Ok(_mapper.Map<ZvanjeResponse>(result));
    }

    [HttpPost]
    public async Task<ActionResult<ZvanjeResponse>> Create([FromBody] ZvanjeRequest request)
    {
        var entity = _mapper.Map<Zvanje>(request);
        await _service.CreateAsync(entity);
        return CreatedAtAction(nameof(GetById), new { id = entity.IdZvanje },
            _mapper.Map<ZvanjeResponse>(entity));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, [FromBody] ZvanjeRequest request)
    {
        var existing = await _service.GetByIdAsync(id);
        if (existing is null) return NotFound();
        var entity = _mapper.Map<Zvanje>(request);
        entity.IdZvanje = id;
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
