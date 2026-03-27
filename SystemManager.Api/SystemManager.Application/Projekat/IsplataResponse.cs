namespace SystemManager.Application.Projekat;

public record IsplataResponse(
    long IsplataId,
    long RadnikId,
    string Vrsta,
    DateOnly Datum,
    decimal Iznos);
