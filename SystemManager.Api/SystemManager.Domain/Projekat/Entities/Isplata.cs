namespace SystemManager.Domain.Projekat.Entities;

public class Isplata
{
    public long RadnikId { get; set; }
    public long IsplataId { get; set; }
    public DateOnly Datum { get; set; }
    public decimal Iznos { get; set; }
    public string Vrsta { get; set; } = "PLATA"; // PLATA, BONUS, REGRES
    public Radnik? Radnik { get; set; }
}
