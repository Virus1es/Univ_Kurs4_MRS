using Kursavaya_ASP.Models;
using Kursavaya_ASP.Models.Tables.Main;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace Kursavaya_ASP.Controllers;

public class IncidentInersController : Controller
{
    private static GssContext _db;

    // В конструкторе получаем доступ к контексту базы данных
    public IncidentInersController(GssContext context) =>
        _db = context;

    public async Task<IActionResult> Index()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        ViewBag.CurUser = user;

        return View(await _db.IncidentIners.ToListAsync());
    }

    // добавление участника устранения проишествия
    public IActionResult AddIncidentIner()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        // передаём список рабочих
        ViewBag.Employees = new SelectList(_db.Employees.ToList(), "Id", "FullNameAndDepartment", _db.Employees.ToList()[0]);

        // передаём список проишествий
        ViewBag.Incidents = new SelectList(_db.Incidents.ToList(), "Id", "IncidentInfo", _db.Incidents.ToList()[0]);

        ViewBag.Title = "Добавление участника устранения проишествия";
        ViewBag.Header = "Добавление сведений о участнике устранения проишествия";
        return View("UpdateById", new IncidentIner());
    }


    // Вывод страницы с формой редактирования сведений о участнике устранения проишествия
    public IActionResult UpdateById(int id)
    {
        Incident incident = _db.Incidents.First(i => i.Id == id);

        // передаём список рабочих
        ViewBag.Employees = new SelectList(_db.Employees.ToList(), "Id", "FullNameAndDepartment", _db.Employees.ToList()[0]);

        // передаём список проишествий
        ViewBag.Incidents = new SelectList(_db.Incidents.ToList(), "Id", "IncidentInfo", _db.Incidents.ToList()[0]);

        ViewBag.Title = "Редактирование участника устранения проишествия";
        ViewBag.Header = "Редактирование сведений о участнике устранения проишествия";
        return View(incident);
    }


    // обработчик сведений, полученных из формы редактирования
    // данных участника устранения проишествия
    [HttpPost]
    public IActionResult UpdatePlot(IncidentIner inerData)
    {
        try
        {
            // если пришёл новый элемент добавляем его в коллекцию
            if (inerData.Id == null)
                _db.IncidentIners.Add(inerData);
            else
                _db.IncidentIners.Update(inerData);

            _db.SaveChanges();
        }
        catch (Exception ex)
        {
            ViewBag.ErrorMessage = ex.Message;
        }
        // вывести обновленную коллекцию
        return Redirect("~/IncidentIners/Index");
    }

    // удаление проишествия по Id
    public async Task<IActionResult> DeletePlotById(int id)
    {
        // найти нужного сотрудника
        IncidentIner iner = _db.IncidentIners.First(i => i.Id == id);

        // если нашли удаляем
        if (iner != null) _db.IncidentIners.Remove(iner);

        await _db.SaveChangesAsync();

        // вывести обновленную коллекцию
        return Redirect("~/IncidentIners/Index");
    }
}
