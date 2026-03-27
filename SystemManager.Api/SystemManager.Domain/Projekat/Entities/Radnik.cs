namespace SystemManager.Domain.Projekat.Entities;

public class Radnik
{
    public long RadnikId { get; set; }
    public string Ime { get; set; } = string.Empty;
    public long SluzbaId { get; set; }
    public long RadnoMestoId { get; set; }

    public Sluzba? Sluzba { get; set; }
    public RadnoMesto? RadnoMesto { get; set; }
    public List<Isplata> Isplate { get; set; } = new();
    public List<Ucestvuje> Projekti { get; set; } = new();
}
