using Kursavaya_ASP.Models;
using Kursavaya_ASP.Models.Tables.Main;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace Kursavaya_ASP.Controllers;

public class IncidentsController : Controller
{
    private static GssContext _db;

    // В конструкторе получаем доступ к контексту базы данных
    public IncidentsController(GssContext context) =>
        _db = context;

    public async Task<IActionResult> Index()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        ViewBag.CurUser = user;

        return View(await _db.Incidents.ToListAsync());
    }

    // добавление проишествия
    public IActionResult AddIncident()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        // передаём список участков
        ViewBag.Plots = new SelectList(_db.Plots.ToList(), "Id", "MineAndNumber", _db.Plots.ToList()[0]);

        // передаём список типов проишествий
        ViewBag.Types = new SelectList(_db.EmergencyTypes.ToList(), "Id", "TypeName", _db.EmergencyTypes.ToList()[0]);

        // передаём список причин проишествий
        ViewBag.Causes = new SelectList(_db.EmergencyCauses.ToList(), "Id", "CauseName", _db.EmergencyCauses.ToList()[0]);

        // передаём текущую дату в правильном формате
        ViewBag.MaxDate = $"{DateTime.Now:yyyy-MM-dd}";

        ViewBag.Title = "Добавление проишествия";
        ViewBag.Header = "Добавление сведений о проишествии";
        return View("UpdateById", new Incident());
    }


    // Вывод страницы с формой редактирования сведений о проишествии
    public IActionResult UpdateById(int id)
    {
        Incident incident = _db.Incidents.First(i => i.Id == id);

        // передаём список участков
        ViewBag.Plots = new SelectList(_db.Plots.ToList(), "Id", "MineAndNumber", _db.Plots.ToList()[0]);

        // передаём список типов проишествий
        ViewBag.Types = new SelectList(_db.EmergencyTypes.ToList(), "Id", "TypeName", _db.EmergencyTypes.ToList()[0]);

        // передаём список причин проишествий
        ViewBag.Causes = new SelectList(_db.EmergencyCauses.ToList(), "Id", "CauseName", _db.EmergencyCauses.ToList()[0]);

        ViewBag.Title = "Редактирование проишествия";
        ViewBag.Header = "Редактирование сведений о проишествии";
        return View(incident);
    }


    // обработчик сведений, полученных из формы редактирования
    // данных проишествия
    [HttpPost]
    public IActionResult UpdatePlot(Incident incidentData)
    {
        try
        {
            // если пришёл новый элемент добавляем его в коллекцию
            if (incidentData.Id == null)
                _db.Incidents.Add(incidentData);
            else
                _db.Incidents.Update(incidentData);

            _db.SaveChanges();
        }
        catch (Exception ex)
        {
            ViewBag.ErrorMessage = ex.Message;
        }
        // вывести обновленную коллекцию
        return Redirect("~/Incidents/Index");
    }

    // удаление проишествия по Id
    public async Task<IActionResult> DeletePlotById(int id)
    {
        // найти нужного сотрудника
        Incident incident = _db.Incidents.First(i => i.Id == id);

        // если нашли удаляем
        if (incident != null) _db.Incidents.Remove(incident);

        await _db.SaveChangesAsync();

        // вывести обновленную коллекцию
        return Redirect("~/Incidents/Index");
    }

}
