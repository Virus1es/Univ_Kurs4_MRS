using Kursavaya_ASP.Models.Tables.Main;
using Newtonsoft.Json;

namespace Kursavaya_ASP.Models.Tables.References;

// причина черезвычайного проишествия
public class EmergencyCause
{
    // ПК сущности
    public int Id { get; set; }

    // название причины
    public string CauseName { get; set; } = string.Empty;

    // Навигационные свойства для связи "один ко многим"
    // Incidents  : вспомогательная сущность для связи "один ко многим"
    [JsonIgnore]
    public virtual List<Incident> Incidents { get; set; } = new();
}
