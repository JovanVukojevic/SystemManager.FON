namespace SystemManager.Application.Projekat;

public record ProjekatRequest(
    string Naziv,
    decimal Budzet,
    long? RukovodiRadnikId,
    List<ProjekatRadnikRequest> Radnici);

public record ProjekatRadnikRequest(
    long RadnikId,
    DateOnly DatumOd,
    DateOnly? DatumDo);
