using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using SystemManager.Application.Projekat;
using SystemManager.Application.Projekat.Interfaces;
using SystemManager.Domain.Projekat.Entities;

namespace SystemManager.Api.Controllers.Projekat;

[ApiController]
[Route("api/projekat/[controller]")]
public class RadnikController : ControllerBase
{
    private readonly IRadnikService _radnikService;
    private readonly IIsplataService _isplataService;
    private readonly IMapper _mapper;

    public RadnikController(IRadnikService radnikService, IIsplataService isplataService, IMapper mapper)
    {
        _radnikService = radnikService;
        _isplataService = isplataService;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<RadnikResponse>>> GetAll()
    {
        var result = await _radnikService.GetAllAsync();
        return Ok(_mapper.Map<IEnumerable<RadnikResponse>>(result));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<RadnikResponse>> GetById(long id)
    {
        var result = await _radnikService.GetByIdAsync(id);
        if (result is null) return NotFound();
        return Ok(_mapper.Map<RadnikResponse>(result));
    }

    [HttpPost]
    public async Task<ActionResult<RadnikResponse>> Create([FromBody] RadnikRequest request)
    {
        var entity = _mapper.Map<Radnik>(request);
        await _radnikService.CreateAsync(entity);
        return CreatedAtAction(nameof(GetById), new { id = entity.RadnikId },
            _mapper.Map<RadnikResponse>(entity));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, [FromBody] RadnikRequest request)
    {
        var existing = await _radnikService.GetByIdAsync(id);
        if (existing is null) return NotFound();
        var entity = _mapper.Map<Radnik>(request);
        entity.RadnikId = id;
        entity.Projekti = _mapper.Map<List<Ucestvuje>>(request.Projekti);
        await _radnikService.UpdateAsync(entity);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(long id)
    {
        var existing = await _radnikService.GetByIdAsync(id);
        if (existing is null) return NotFound();
        await _radnikService.DeleteAsync(id);
        return NoContent();
    }

    [HttpGet("{radnikId}/isplate")]
    public async Task<ActionResult<IEnumerable<IsplataResponse>>> GetIsplate(long radnikId)
    {
        var radnik = await _radnikService.GetByIdAsync(radnikId);
        if (radnik is null) return NotFound();
        var isplate = await _isplataService.GetByRadnikIdAsync(radnikId);
        return Ok(_mapper.Map<IEnumerable<IsplataResponse>>(isplate));
    }

    [HttpPost("{radnikId}/isplate")]
    public async Task<ActionResult<IsplataResponse>> CreateIsplata(long radnikId, [FromBody] IsplataRequest request)
    {
        var radnik = await _radnikService.GetByIdAsync(radnikId);
        if (radnik is null) return NotFound();
        var entity = _mapper.Map<Isplata>(request);
        entity.RadnikId = radnikId;
        await _isplataService.CreateAsync(entity);
        return CreatedAtAction(nameof(GetIsplate), new { radnikId },
            _mapper.Map<IsplataResponse>(entity));
    }

    [HttpPut("{radnikId}/isplate/{isplataId}")]
    public async Task<IActionResult> UpdateIsplata(long radnikId, long isplataId, [FromBody] IsplataRequest request)
    {
        var existing = await _isplataService.GetByIdAsync(isplataId);
        if (existing is null || existing.RadnikId != radnikId) return NotFound();
        var entity = _mapper.Map<Isplata>(request);
        entity.IsplataId = isplataId;
        entity.RadnikId = radnikId;
        await _isplataService.UpdateAsync(entity);
        return NoContent();
    }

    [HttpDelete("{radnikId}/isplate/{isplataId}")]
    public async Task<IActionResult> DeleteIsplata(long radnikId, long isplataId)
    {
        var existing = await _isplataService.GetByIdAsync(isplataId);
        if (existing is null || existing.RadnikId != radnikId) return NotFound();
        await _isplataService.DeleteAsync(isplataId);
        return NoContent();
    }
}
