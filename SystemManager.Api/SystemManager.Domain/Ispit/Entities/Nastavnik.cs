namespace SystemManager.Domain.Ispit.Entities;

public class Nastavnik
{
    public int IdNastavnik { get; set; }
    public string Ime { get; set; } = string.Empty;
    public int IdZvanje { get; set; }

    public Zvanje? Zvanje { get; set; }
}
