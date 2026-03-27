namespace SystemManager.Application.Projekat;

public record RadnikResponse(
    long RadnikId,
    string Ime,
    RadnoMestoResponse RadnoMesto,
    SluzbaResponse Sluzba,
    List<RadnikProjekatDto> Projekti,
    List<IsplataResponse> Isplate);

public record RadnikProjekatDto(
    long ProjekatId,
    string ProjekatNaziv,
    DateOnly DatumOd,
    DateOnly? DatumDo);
