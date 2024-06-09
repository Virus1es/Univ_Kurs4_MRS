using Kursavaya_ASP.Models.Tables.Main;
using Newtonsoft.Json;

namespace Kursavaya_ASP.Models.Tables.References;

// класс описывающий город
public class City
{
    // ПК сущности
    public int Id { get; set; }

    // Название города
    public string CityName { get; set; } = string.Empty;

    // Навигационные свойства для связи "один ко многим"
    // Mines      : вспомогательная сущность для связи "один ко многим"
    [JsonIgnore]
    public virtual List<Mine> Mines { get; set; } = new();

    // Навигационные свойства для связи "один ко многим"
    // Departments: вспомогательная сущность для связи "один ко многим"
    [JsonIgnore]
    public virtual List<Department> Departments { get; set; } = new();

}
