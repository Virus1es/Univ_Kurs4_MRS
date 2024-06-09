using Kursavaya_ASP.Infrastructure;
using Kursavaya_ASP.Models;
using Kursavaya_ASP.Models.Dto;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Kursavaya_ASP.Controllers;

public class HomeController : Controller
{
    private static GssContext _db;

    // В конструкторе получаем доступ к контексту базы данных
    public HomeController(GssContext context) =>
        _db = context;

    public IActionResult Index()
    {
        // Utils.FillTables(_db);

        // пытаемся получить текущего пользователя
        Request.Cookies.TryGetValue("CurUser",out string user);

        ViewBag.CurUser = user;

        // если пользователя нет кидаем его на страницу входа
        // иначче открываем главную страницу
        if (string.IsNullOrEmpty(user))
            return View("Enter");
        else
        {
            Request.Cookies.TryGetValue("UserDepartment", out string dep);
            int.TryParse(dep, out int idDep);

            ViewBag.DepName = _db.Departments.Where(d => d.Id == idDep).First().DepName;
            return View();
        }
    }

    // вход в учётную запись пользователя
    public IActionResult Enter() {
        Request.Cookies.TryGetValue("CurUser", out string user);

        ViewBag.CurUser = user;

        return View(); 
    }

    // проверка введённых пользователем данных
    [HttpPost]
    public IActionResult CheckLoginAndPassword(UserInfoCheck formUser)
    {
        // получаем всех пользователей
        var users = _db.Users.ToList();

        // ищем среди пользователей введённый логин
        var user = users.Find(u => u.Login == formUser.Login);

        // если ввели всё правильно переходим на домашнюю страницу
        // иначе выводим сообщение об ошибке
        try
        {
            // если ничего не укзали выходим
            if (user == null)
                throw new Exception("Пользователь с таким логином не найден");

            // определяем правильность ввода пароля пользователя
            if (_db.Database.SqlQueryRaw<string>($"select name from sys.sql_logins where PWDCOMPARE('{formUser.Password}', password_hash) = 1;").ToList().First() != user.Login)
                throw new Exception("Не верно указан пароль");

            // определение роли
            string role = Utils.ChooseRole(_db, user.Login);

            // создание Cookies
            Response.Cookies.Append("CurUser", role);
            Response.Cookies.Append("UserDepartment", user.IdDepartment.ToString());

            return Redirect("~/Home/Index");
        }
        catch(Exception ex)
        {
            ViewBag.ErrMessage = ex.Message;

            return View("Enter");
        }
    }


}
