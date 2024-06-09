using Kursavaya_ASP.Models.Tables.References;
using Newtonsoft.Json;

namespace Kursavaya_ASP.Models.Tables.Main;

// класс описывающий Участок шахты
public class Plot
{
    // ПК сущности
    public int Id { get; set; }

    // Числено-буквенный номер участка
    public string Number { get; set; } = string.Empty;

    // длина участка
    public int LengthPlot { get; set; }

    // год ввода в действие
    public int YearStart { get; set; }

    #region Настройка внешних ключей

    // тип выработки
    [JsonIgnore]
    public int IdProductionType { get; set; }
    public virtual ProductionType ProductionType { get; set; } = null!;

    // тип угля
    [JsonIgnore]
    public int IdCoalType { get; set; }
    public virtual CoalType CoalType { get; set; } = null!;

    // шахта в которой находиться участок
    [JsonIgnore]
    public int IdMine { get; set; }
    public virtual Mine Mine { get; set; } = null!;

    // Навигационные свойства для связи "один ко многим"
    // Incidents  : вспомогательная сущность для связи "один ко многим"
    [JsonIgnore]
    public virtual List<Incident> Incidents { get; set; } = new();

    #endregion

    // для более удобного выбра участка
    public string MineAndNumber => $"{Mine?.MineName}, {Number}";
}
