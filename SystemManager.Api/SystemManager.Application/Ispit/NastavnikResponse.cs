namespace SystemManager.Application.Ispit;

public record NastavnikResponse(
    int IdNastavnik,
    string Ime,
    ZvanjeResponse Zvanje);
