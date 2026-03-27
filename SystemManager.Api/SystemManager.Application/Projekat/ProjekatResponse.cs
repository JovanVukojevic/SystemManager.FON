namespace SystemManager.Application.Projekat;

public record ProjekatResponse(
    long ProjekatId,
    string Naziv,
    decimal Budzet,
    int Klasa,
    long? RukovodiRadnikId,
    List<ProjekatRadnikDto> Radnici);

public record ProjekatRadnikDto(
    long RadnikId,
    string RadnikIme,
    DateOnly DatumOd,
    DateOnly? DatumDo);
