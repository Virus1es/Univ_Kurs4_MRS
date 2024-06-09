using Kursavaya_ASP.Models.Tables.References;
using Newtonsoft.Json;

namespace Kursavaya_ASP.Models.Tables.Main;

// класс описывающий Сотрудника
public class Employee
{
    // ПК сущности
    public int Id { get; set; }

    // фамилия 
    public string Surname { get; set; } = string.Empty;

    // имя 
    public string FirstName { get; set; } = string.Empty;

    // отчество
    public string Patronymic { get; set; } = string.Empty;

    // оклад
    public int Salary { get; set; }

    // год начала работы в отделении
    public int YearStart { get; set; }

    // дата рождения
    public DateTime Birthday { get; set; }

    #region Настройка внешних ключей

    // занимаемая должность
    [JsonIgnore]
    public int IdPosition { get; set; }
    public virtual Position Position { get; set; } = null!;

    // отделение в котором работает сотрудник
    [JsonIgnore]
    public int IdDepartment { get; set; }
    public virtual Department Department { get; set; } = null!;

    // Навигационные свойства для связи "один ко многим"
    // IncidentIners  : вспомогательная сущность для связи "один ко многим"
    [JsonIgnore]
    public virtual List<IncidentIner> IncidentIners { get; set; } = new();

    #endregion

    // для более удобного выбра рабочего
    public string FullNameAndDepartment => $"{Surname} {FirstName[0]}.{Patronymic[0]}., {Department?.DepName}";
}
