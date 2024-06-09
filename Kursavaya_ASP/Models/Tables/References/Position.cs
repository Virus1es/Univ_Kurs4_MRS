using Kursavaya_ASP.Models.Tables.Main;
using Newtonsoft.Json;

namespace Kursavaya_ASP.Models.Tables.References;

// класс описывающий занимаемую должность
public class Position
{
    // ПК сущности
    public int Id { get; set; }

    // название должности
    public string PositionName { get; set; } = string.Empty;

    // Навигационные свойства для связи "один ко многим"
    // Employees  : вспомогательная сущность для связи "один ко многим"
    [JsonIgnore]
    public virtual List<Employee> Employees { get; set; } = new();
}
