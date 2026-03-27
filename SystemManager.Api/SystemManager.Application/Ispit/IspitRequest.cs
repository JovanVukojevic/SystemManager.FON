namespace SystemManager.Application.Ispit;

public record IspitRequest(
    string BrojIndeksa,
    int IdPredmet,
    int IdNastavnik,
    byte Ocena,
    DateOnly DatumPolaganja);
