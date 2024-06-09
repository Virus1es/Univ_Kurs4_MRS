using Kursavaya_ASP.Models.Tables.Main;
using Newtonsoft.Json;

namespace Kursavaya_ASP.Models.Tables.References;

// тип угля
public class CoalType
{
    // ПК сущности
    public int Id { get; set; }

    // название типа
    public string TypeName { get; set; } = string.Empty;

    // Навигационные свойства для связи "один ко многим"
    // Plots  : вспомогательная сущность для связи "один ко многим"
    [JsonIgnore]
    public virtual List<Plot> Plots { get; set; } = new();
}
