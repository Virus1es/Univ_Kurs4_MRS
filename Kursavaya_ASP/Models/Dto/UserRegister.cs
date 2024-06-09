namespace Kursavaya_ASP.Models.Dto;

// модель описывающая регистрируещегося пользователя
public class UserRegister
{
    // ПК сущности
    public int Id { get; set; }

    // Логин
    public string Login { get; set; } = string.Empty;

    // Пароль
    public string Password { get; set; } = string.Empty;

    // Роль на сервере
    public string RoleName { get; set; } = string.Empty;

    // Отделение пользователя
    public int IdDepartment { get; set; }
}
