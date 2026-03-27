namespace SystemManager.Application.Ispit;

public record StudentRequest(
    string BrojIndeksa,
    string Ime,
    string? Semestar,
    DateOnly DatumRodjenja);
