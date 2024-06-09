using Kursavaya_ASP.Models.Tables.References;
using Newtonsoft.Json;

namespace Kursavaya_ASP.Models.Tables.Main;

// класс описывающий Шахту
public class Mine
{
    // ПК сущности
    public int Id { get; set; }

    // название шахты
    public string MineName { get; set; } = string.Empty;

    // максимальная глубина
    public int MaxDepth { get; set; }

    // площадь выработок
    public int Area { get; set; }

    #region Настройка внешних ключей

    // город
    [JsonIgnore]
    public int IdCity { get; set; }
    public virtual City City { get; set; } = null!;

    // Навигационные свойства для связи "один ко многим"
    // Plots  : вспомогательная сущность для связи "один ко многим"
    [JsonIgnore]
    public virtual List<Plot> Plots { get; set; } = new();

    #endregion

    // для более удобного выбра Шахты
    public string NameAndCity => $"{MineName}, {City?.CityName}";
}
