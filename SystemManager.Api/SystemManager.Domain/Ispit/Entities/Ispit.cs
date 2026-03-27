namespace SystemManager.Domain.Ispit.Entities;

public class Ispit
{
    public int IdIspit { get; set; }
    public byte Ocena { get; set; }
    public DateOnly DatumPolaganja { get; set; }
    public string BrojIndeksa { get; set; } = string.Empty;
    public int IdPredmet { get; set; }
    public int IdNastavnik { get; set; }

    public Student? Student { get; set; }
    public Nastavnik? Nastavnik { get; set; }
    public Predmet? Predmet { get; set; }
}
