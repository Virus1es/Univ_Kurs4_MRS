using Kursavaya_ASP.Infrastructure;
using Kursavaya_ASP.Models;
using Kursavaya_ASP.Models.Dto;
using Kursavaya_ASP.Models.Tables.Main;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace Kursavaya_ASP.Controllers;

public class UsersController : Controller
{
    private static GssContext _db;

    // В конструкторе получаем доступ к контексту базы данных
    public UsersController(GssContext context) =>
        _db = context;

    public async Task<IActionResult> Index()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        ViewBag.CurUser = user;

        var users = await _db.Users.ToListAsync();

        var usersWithRole = new List<UserShow>();

        foreach (var item in users)
            usersWithRole.Add(new UserShow(item.Id, item.Login, item.Department.DepName, Utils.ChooseRole(_db, item.Login)));

        usersWithRole = usersWithRole.OrderBy(u => u.Department).ThenBy(u => u.Role).ToList();

        return View(usersWithRole);
    }

    // регистрация пользователя
    public IActionResult Registration()
    {
        // назначаем новому пользователю Id
        UserRegister user = new();

        // передаём список отделений ГСС
        ViewBag.Departments = new SelectList(_db.Departments.ToList(), "Id", "DepName", _db.Departments.ToList()[0]);

        // передаём список ролей на сервере
        var roles = new List<string>() { "Рабочий", "Офицер", "Администратор" };
        ViewBag.Roles = new SelectList(roles);

        return View(user);
    }

    // регстрация нового пользователя
    public async Task<IActionResult> TryRegisterNewUser(UserRegister user)
    {
        try
        {
            // выбор роли будущего пользователя
            string role = (user.RoleName) switch
            {
                "Администратор" => "[admin]",
                "Офицер"        => "comandor",
                _               => "employee"
            };

            // если не всё заполнено кидаем ошибку
            if (string.IsNullOrEmpty(user.Login) || string.IsNullOrEmpty(user.Password))
                throw new Exception();

            // пытаемся добавить пользователя в базу
            await _db.Database.ExecuteSqlRawAsync($"CREATE LOGIN {user.Login} WITH PASSWORD = '{user.Password}'");
            await _db.Database.ExecuteSqlRawAsync($"CREATE USER {user.Login} FOR LOGIN {user.Login}");
            await _db.Database.ExecuteSqlRawAsync($"ALTER ROLE {role} ADD MEMBER {user.Login}");

            _db.Users.Add(new User() { Login = user.Login, IdDepartment = user.IdDepartment });
            
            await _db.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            // если не получилость создать пользователя выводим ошибку
            ViewBag.ErrMessage($"Такой логин уже занят \n{ex.Message}");

            return View("Users/Registration");
        }

        return Redirect("~/Users/Index");
    }
}
