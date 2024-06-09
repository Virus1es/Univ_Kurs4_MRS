using Kursavaya_ASP.Models.Tables.References;
using Newtonsoft.Json;

namespace Kursavaya_ASP.Models.Tables.Main;

// класс описывающий Отделение ГСС
public class Department
{
    // ПК сущности
    public int Id { get; set; }

    // название отделения
    public string DepName { get; set; } = string.Empty;

    // телефон
    public string Phone { get; set; } = string.Empty;

    // год создания
    public int YearCreation { get; set; }

    #region Настройка внешних ключей

    // город
    [JsonIgnore]
    public int IdCity { get; set; }
    public virtual City City { get; set; } = null!;


    // Навигационные свойства для связи "один ко многим"
    // Users  : вспомогательная сущность для связи "один ко многим"
    [JsonIgnore]
    public virtual List<User> Users { get; set; } = new();

    // Навигационные свойства для связи "один ко многим"
    [JsonIgnore]
    // Employees  : вспомогательная сущность для связи "один ко многим"
    public virtual List<Employee> Employees { get; set; } = new();

    #endregion

    // для более удобного выбра отделения
    public string NameAndCity => $"{DepName}, {City?.CityName}";
}
