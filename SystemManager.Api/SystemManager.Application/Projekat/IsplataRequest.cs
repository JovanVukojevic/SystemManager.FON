namespace SystemManager.Application.Projekat;

public record IsplataRequest(
    string Vrsta,
    DateOnly Datum,
    decimal Iznos);
