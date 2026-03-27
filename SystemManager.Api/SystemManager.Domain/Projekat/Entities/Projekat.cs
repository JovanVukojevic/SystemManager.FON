namespace SystemManager.Domain.Projekat.Entities;

public class Projekat
{
    public long ProjekatId { get; set; }
    public string Naziv { get; set; } = string.Empty;
    public decimal Budzet { get; set; }
    public int Klasa { get; set; }
    public long? RukovodiRadnikId { get; set; }
    public List<Ucestvuje> Radnici { get; set; } = new();
}
