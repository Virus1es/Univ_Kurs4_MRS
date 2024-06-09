using Newtonsoft.Json;

namespace Kursavaya_ASP.Models.Tables.Main;

// класс описывающий Участие сотрудника в устранении черезвычайной ситуации

public class IncidentIner
{
    // ПК сущности
    public int Id { get; set; }

    // дней участия
    public int DaysAmount { get; set; }

    #region Настройка внешних ключей

    // проишествие
    [JsonIgnore]
    public int IdIncident { get; set; }
    public virtual Incident Incident { get; set; } = null!;

    // участник(сотрудник)
    [JsonIgnore]
    public int IdEmployee { get; set; }
    public virtual Employee Employee { get; set; } = null!;

    #endregion
}
