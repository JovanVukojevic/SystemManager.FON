using AutoMapper;
using SystemManager.Application.Ispit;
using SystemManager.Application.Ispit.Interfaces;
using SystemManager.Application.Ispit.Services;
using SystemManager.Application.Projekat;
using SystemManager.Application.Projekat.Interfaces;
using SystemManager.Application.Projekat.Services;
using SystemManager.Domain.Ispit.Repositories;
using SystemManager.Domain.Projekat.Repositories;
using SystemManager.Api.Middleware;
using SystemManager.Infrastructure.Common;
using SystemManager.Infrastructure.Repositories;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddPolicy("AngularPolicy", policy =>
    {
        policy.WithOrigins("http://localhost:4200")
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var providerName = builder.Configuration["DatabaseSettings:Provider"] ?? "SqlServer";
var provider = Enum.Parse<DbProvider>(providerName);

if (provider == DbProvider.PostgreSql)
{
    Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true;
}

Dapper.SqlMapper.AddTypeHandler(new DateOnlyTypeHandler());

var ispitConnStr = builder.Configuration
    [$"DatabaseSettings:ConnectionStrings:Ispit:{providerName}"]!;
var projekatConnStr = builder.Configuration
    [$"DatabaseSettings:ConnectionStrings:Projekat:{providerName}"]!;

builder.Services.AddSingleton(new IspitDbConnectionFactory(ispitConnStr, provider));
builder.Services.AddSingleton(new ProjekatDbConnectionFactory(projekatConnStr, provider));

if (provider == DbProvider.PostgreSql)
{
    // ISPIT
    builder.Services.AddScoped<IStudentRepository, StudentRepositoryPostgreSql>();
    builder.Services.AddScoped<IPredmetRepository, PredmetRepositoryPostgreSql>();
    builder.Services.AddScoped<IZvanjeRepository, ZvanjeRepositoryPostgreSql>();
    builder.Services.AddScoped<INastavnikRepository, NastavnikRepositoryPostgreSql>();
    builder.Services.AddScoped<IIspitRepository, IspitRepositoryPostgreSql>();
    
    // PROJEKAT
    builder.Services.AddScoped<IRadnoMestoRepository, RadnoMestoRepositoryPostgreSql>();
    builder.Services.AddScoped<ISluzbaRepository, SluzbaRepositoryPostgreSql>();
    builder.Services.AddScoped<IProjekatRepository, ProjekatRepositoryPostgreSql>();
    builder.Services.AddScoped<IRadnikRepository, RadnikRepositoryPostgreSql>();
    builder.Services.AddScoped<IIsplataRepository, IsplataRepositoryPostgreSql>();
}
else
{
    // ISPIT (default: SqlServer)
    builder.Services.AddScoped<IStudentRepository, StudentRepositorySqlServer>();
    builder.Services.AddScoped<IPredmetRepository, PredmetRepositorySqlServer>();
    builder.Services.AddScoped<IZvanjeRepository, ZvanjeRepositorySqlServer>();
    builder.Services.AddScoped<INastavnikRepository, NastavnikRepositorySqlServer>();
    builder.Services.AddScoped<IIspitRepository, IspitRepositorySqlServer>();
    
    // PROJEKAT
    builder.Services.AddScoped<IRadnoMestoRepository, RadnoMestoRepositorySqlServer>();
    builder.Services.AddScoped<ISluzbaRepository, SluzbaRepositorySqlServer>();
    builder.Services.AddScoped<IProjekatRepository, ProjekatRepositorySqlServer>();
    builder.Services.AddScoped<IRadnikRepository, RadnikRepositorySqlServer>();
    builder.Services.AddScoped<IIsplataRepository, IsplataRepositorySqlServer>();
}

// ISPIT
builder.Services.AddScoped<IStudentService, StudentService>();
builder.Services.AddScoped<IPredmetService, PredmetService>();
builder.Services.AddScoped<IZvanjeService, ZvanjeService>();
builder.Services.AddScoped<INastavnikService, NastavnikService>();
builder.Services.AddScoped<IIspitService, IspitService>();

// PROJEKAT
builder.Services.AddScoped<IRadnoMestoService, RadnoMestoService>();
builder.Services.AddScoped<ISluzbaService, SluzbaService>();
builder.Services.AddScoped<IProjekatService, ProjekatService>();
builder.Services.AddScoped<IRadnikService, RadnikService>();
builder.Services.AddScoped<IIsplataService, IsplataService>();

builder.Services.AddAutoMapper(cfg =>
{
    cfg.AddProfile<IspitMappingProfile>();
    cfg.AddProfile<ProjekatMappingProfile>();
});

builder.Services.AddControllers();
builder.Services.AddOpenApi();

var app = builder.Build();

app.UseMiddleware<ExceptionMiddleware>();

app.UseCors("AngularPolicy");

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

app.Run();
