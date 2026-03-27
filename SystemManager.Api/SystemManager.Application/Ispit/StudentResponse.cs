namespace SystemManager.Application.Ispit;

public record StudentResponse(
    string BrojIndeksa,
    string Ime,
    int? Starost,
    string? Semestar,
    DateOnly DatumRodjenja,
    decimal? ProsecnaOcena);
