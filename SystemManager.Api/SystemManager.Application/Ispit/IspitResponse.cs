namespace SystemManager.Application.Ispit;

public record IspitResponse(
    int IdIspit,
    byte Ocena,
    DateOnly DatumPolaganja,
    StudentResponse Student,
    PredmetResponse Predmet,
    NastavnikResponse Nastavnik);
