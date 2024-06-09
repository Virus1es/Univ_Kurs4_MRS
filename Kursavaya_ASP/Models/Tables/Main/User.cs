using Newtonsoft.Json;

namespace Kursavaya_ASP.Models.Tables.Main;

// класс пользователя сайта
public class User
{
    // ПК сущности
    public int Id {  get; set; } 

    // Логин
    public string Login { get; set; } = string.Empty;

    #region Настройка внешних ключей

    // Отделение пользователя
    [JsonIgnore]
    public int IdDepartment { get; set; }
    public virtual Department Department { get; set; } = null!;

    #endregion

}
