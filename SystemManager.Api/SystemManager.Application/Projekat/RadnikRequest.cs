namespace SystemManager.Application.Projekat;

public record RadnikRequest(
    string Ime,
    long RadnoMestoId,
    long SluzbaId,
    List<RadnikProjekatRequest> Projekti);

public record RadnikProjekatRequest(
    long ProjekatId,
    DateOnly DatumOd,
    DateOnly? DatumDo);
