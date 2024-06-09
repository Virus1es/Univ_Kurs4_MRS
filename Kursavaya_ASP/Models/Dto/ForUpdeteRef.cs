namespace Kursavaya_ASP.Models.Dto;

// запись используемая для более простой реализации редактирования справочников
public class ForUpdeteRef
{
    public int Id { get; set; }
    public string Table { get; set; } = string.Empty;
    public string Column { get; set; } = string.Empty;
}
