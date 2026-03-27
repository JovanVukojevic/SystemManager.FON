namespace SystemManager.Domain.Projekat.Entities;

public class Ucestvuje
{
    public long UcestvujeId { get; set; }
    public DateOnly DatumOd { get; set; }
    public DateOnly? DatumDo { get; set; }
    public long RadnikId { get; set; }
    public long ProjekatId { get; set; }

    public Radnik? Radnik { get; set; }
    public Projekat? Projekat { get; set; }
}
