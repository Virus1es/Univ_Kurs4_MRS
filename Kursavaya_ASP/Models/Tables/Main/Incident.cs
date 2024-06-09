using Kursavaya_ASP.Models.Tables.References;
using Newtonsoft.Json;

namespace Kursavaya_ASP.Models.Tables.Main;

// класс описывающий Чрезвычайное происшествие на участке
public class Incident
{
    // ПК сущности 
    public int Id { get; set; }

    // дата проишествия
    public DateTime IncDate { get; set; }

    // материальный ущерб
    public int Damage { get; set; }

    #region Настройка внешних ключей

    // участок проишествия
    [JsonIgnore]
    public int IdPlot { get; set; }
    public virtual Plot Plot { get; set; } = null!;

    // тип проишествия
    [JsonIgnore]
    public int IdEmergencyType { get; set; }
    public virtual EmergencyType EmergencyType { get; set; } = null!;

    // причина проишествия
    [JsonIgnore]
    public int IdEmergencyCause { get; set; }
    public virtual EmergencyCause EmergencyCause { get; set; } = null!;

    // Навигационные свойства для связи "один ко многим"
    // IncidentIners  : вспомогательная сущность для связи "один ко многим"
    [JsonIgnore]
    public virtual List<IncidentIner> IncidentIners { get; set; } = new();

    #endregion

    // для более удобного выбра проишествия
    public string IncidentInfo => $"{IncDate:dd.MM.yyyy}, {Plot?.Number}, {EmergencyType?.TypeName}, {EmergencyCause?.CauseName[0]}";
}
