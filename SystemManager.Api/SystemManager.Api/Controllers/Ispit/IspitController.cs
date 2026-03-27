using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using SystemManager.Application.Ispit;
using SystemManager.Application.Ispit.Interfaces;
using Entities = SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Api.Controllers.Ispit;

[ApiController]
[Route("api/ispit/[controller]")]
public class IspitController : ControllerBase
{
    private readonly IIspitService _service;
    private readonly IMapper _mapper;

    public IspitController(IIspitService service, IMapper mapper)
    {
        _service = service;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<IspitResponse>>> GetAll()
    {
        var result = await _service.GetAllAsync();
        return Ok(_mapper.Map<IEnumerable<IspitResponse>>(result));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<IspitResponse>> GetById(int id)
    {
        var result = await _service.GetByIdAsync(id);
        if (result is null) return NotFound();
        return Ok(_mapper.Map<IspitResponse>(result));
    }

    [HttpPost]
    public async Task<ActionResult<IspitResponse>> Create([FromBody] IspitRequest request)
    {
        var entity = _mapper.Map<Entities.Ispit>(request);
        await _service.CreateAsync(entity);
        return CreatedAtAction(nameof(GetById), new { id = entity.IdIspit },
            _mapper.Map<IspitResponse>(entity));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, [FromBody] IspitRequest request)
    {
        var existing = await _service.GetByIdAsync(id);
        if (existing is null) return NotFound();
        var entity = _mapper.Map<Entities.Ispit>(request);
        entity.IdIspit = id;
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
