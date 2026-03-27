namespace SystemManager.Domain.Ispit.Entities;

public class Student
{
    public string BrojIndeksa { get; set; } = string.Empty;
    public string Ime { get; set; } = string.Empty;
    public DateOnly DatumRodjenja { get; set; }
    public string? Semestar { get; set; }
    public int? Starost { get; set; }
    public decimal? ProsecnaOcena { get; set; }
}
