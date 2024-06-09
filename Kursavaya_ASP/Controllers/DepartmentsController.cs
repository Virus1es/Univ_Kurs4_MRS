using Kursavaya_ASP.Models;
using Kursavaya_ASP.Models.Tables.Main;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace Kursavaya_ASP.Controllers;

public class DepartmentsController : Controller
{
    private static GssContext _db;

    // В конструкторе получаем доступ к контексту базы данных
    public DepartmentsController(GssContext context) =>
        _db = context;

    public async Task<IActionResult> Index()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        ViewBag.CurUser = user;

        return View(await _db.Departments.ToListAsync());
    }


    // добавление рабочего
    public IActionResult AddDepartment()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        // передаём список городов
        ViewBag.Cities = new SelectList(_db.Cities.ToList(), "Id", "CityName", _db.Cities.ToList()[0]);

        ViewBag.Title = "Добавление отделения";
        ViewBag.Header = "Добавление сведений о отделении";

        return View("UpdateById", new Department());
    }


    // Вывод страницы с формой редактирования сведений о отделении
    public IActionResult UpdateById(int id)
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        Department dep = _db.Departments.First(d => d.Id == id);

        // передаём список городов
        ViewBag.Cities = new SelectList(_db.Cities.ToList(), "Id", "CityName", _db.Cities.ToList()[0]);

        ViewBag.Title = "Редактирование отделения";
        ViewBag.Header = "Редактирование сведений о отделении";
        return View(dep);
    }


    // обработчик сведений, полученных из формы редактирования
    // данных отделения
    [HttpPost]
    public IActionResult Update(Department depData)
    {
        try
        {
            // если пришёл новый элемент добавляем его в коллекцию
            if (depData.Id == null)
                _db.Departments.Add(depData);
            // иначе изменяем существующий
            else
                _db.Departments.Update(depData);

            _db.SaveChanges();
        }
        catch (Exception ex)
        {
            ViewBag.ErrorMessage = ex.Message;
        }
        // вывести обновленную коллекцию
        return Redirect("~/Departments/Index");
    }

    // удаление отделения по Id
    public async Task<IActionResult> DeleteById(int id)
    {
        // найти нужное отделение
        Department dep = _db.Departments.First(d => d.Id == id);

        // если нашли удаляем
        if (dep != null) _db.Departments.Remove(dep);

        await _db.SaveChangesAsync();

        // вывести обновленную коллекцию
        return Redirect("~/Departments/Index");
    }
}
