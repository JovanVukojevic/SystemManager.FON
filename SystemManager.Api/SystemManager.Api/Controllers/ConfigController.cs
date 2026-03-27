using Microsoft.AspNetCore.Mvc;

namespace SystemManager.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ConfigController : ControllerBase
{
    private readonly IConfiguration _configuration;

    public ConfigController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    [HttpGet]
    public IActionResult Get()
    {
        var provider = _configuration["DatabaseSettings:Provider"] ?? "SqlServer";
        return Ok(new { provider });
    }
}
