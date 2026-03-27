namespace SystemManager.Domain.Ispit.Entities;

public class Predmet
{
    public int IdPredmet { get; set; }
    public string Naziv { get; set; } = string.Empty;
    public byte? ESPB { get; set; }
}
