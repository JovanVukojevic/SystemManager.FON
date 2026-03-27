using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using SystemManager.Application.Ispit;
using SystemManager.Application.Ispit.Interfaces;
using SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Api.Controllers.Ispit;

[ApiController]
[Route("api/ispit/[controller]")]
public class StudentController : ControllerBase
{
    private readonly IStudentService _service;
    private readonly IMapper _mapper;

    public StudentController(IStudentService service, IMapper mapper)
    {
        _service = service;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<StudentResponse>>> GetAll()
    {
        var result = await _service.GetAllAsync();
        return Ok(_mapper.Map<IEnumerable<StudentResponse>>(result));
    }

    [HttpGet("{*id}")]
    public async Task<ActionResult<StudentResponse>> GetById(string id)
    {
        id = Uri.UnescapeDataString(id);
        var result = await _service.GetByIdAsync(id);
        if (result is null) return NotFound();
        return Ok(_mapper.Map<StudentResponse>(result));
    }

    [HttpPost]
    public async Task<ActionResult<StudentResponse>> Create([FromBody] StudentRequest request)
    {
        var entity = _mapper.Map<Student>(request);
        await _service.CreateAsync(entity);
        return CreatedAtAction(nameof(GetById), new { id = entity.BrojIndeksa },
            _mapper.Map<StudentResponse>(entity));
    }

    [HttpPut("{*id}")]
    public async Task<IActionResult> Update(string id, [FromBody] StudentRequest request)
    {
        id = Uri.UnescapeDataString(id);
        var existing = await _service.GetByIdAsync(id);
        if (existing is null) return NotFound();
        var entity = _mapper.Map<Student>(request);
        entity.BrojIndeksa = id;
        await _service.UpdateAsync(entity);
        return NoContent();
    }

    [HttpDelete("{*id}")]
    public async Task<IActionResult> Delete(string id)
    {
        id = Uri.UnescapeDataString(id);
        var existing = await _service.GetByIdAsync(id);
        if (existing is null) return NotFound();
        await _service.DeleteAsync(id);
        return NoContent();
    }
}
