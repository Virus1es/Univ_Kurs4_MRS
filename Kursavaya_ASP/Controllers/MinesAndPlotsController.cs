using Kursavaya_ASP.Models;
using Kursavaya_ASP.Models.Tables.Main;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace Kursavaya_ASP.Controllers;

public class MinesAndPlotsController : Controller
{
    private static GssContext _db;

    // В конструкторе получаем доступ к контексту базы данных
    public MinesAndPlotsController(GssContext context) =>
        _db = context;

    public async Task<IActionResult> Index(int? id)
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        ViewBag.CurUser = user;

        var mines = await _db.Mines.ToListAsync();
        var plots = await _db.Plots.ToListAsync();

        // если выбрали шахту выбираем её участки
        if (id != null) ViewBag.SelPlots = plots.Where(p => p.IdMine == mines[id.Value - 1].Id);

        return View(mines);
    }

    #region Шахты

    // добавление шахты
    public IActionResult AddMine()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        // передаём список городов
        ViewBag.Cities = new SelectList(_db.Cities.ToList(), "Id", "CityName", _db.Cities.ToList()[0]);

        ViewBag.Title = "Добавление шахты";
        ViewBag.Header = "Добавление сведений о шахте";
        return View("UpdateMineById", new Mine());
    }


    // Вывод страницы с формой редактирования сведений о шахте
    public IActionResult UpdateMineById(int id)
    {
        Mine mine = _db.Mines.First(m => m.Id == id);

        // передаём список городов
        ViewBag.Cities = new SelectList(_db.Cities.ToList(), "Id", "CityName", _db.Cities.ToList()[0]);

        ViewBag.Title = "Редактирование шахты";
        ViewBag.Header = "Редактирование сведений о шахте";
        return View(mine);
    }


    // обработчик сведений, полученных из формы редактирования
    // данных Шахты
    [HttpPost]
    public IActionResult UpdateMine(Mine mineData)
    {
        try
        {
            // если пришёл новый элемент добавляем его в коллекцию
            if (mineData.Id == null)
                _db.Mines.Add(mineData);
            // иначе изменяем существующий
            else
                _db.Mines.Update(mineData);

            _db.SaveChanges();
        }
        catch (Exception ex)
        {
            ViewBag.ErrorMessage = ex.Message;
        }
        // вывести обновленную коллекцию
        return Redirect("~/MinesAndPlots/Index");
    }

    // удаление шахты по Id
    public async Task<IActionResult> DeleteMineById(int id)
    {
        // найти нужного сотрудника
        Mine mine = _db.Mines.First(m => m.Id == id);

        // если нашли удаляем
        if (mine != null) _db.Mines.Remove(mine);

        await _db.SaveChangesAsync();

        // вывести обновленную коллекцию
        return Redirect("~/MinesAndPlots/Index");
    }

    #endregion


    #region Участки

    // добавление участка
    public IActionResult AddPlot()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        // передаём список типов угля
        ViewBag.Coals = new SelectList(_db.CoalTypes.ToList(), "Id", "TypeName", _db.CoalTypes.ToList()[0]);

        // передаём список типов выработки
        ViewBag.Productions = new SelectList(_db.ProductionTypes.ToList(), "Id", "TypeName", _db.ProductionTypes.ToList()[0]);
        
        // передаём список шахт
        ViewBag.Mines = new SelectList(_db.Mines.ToList(), "Id", "NameAndCity", _db.Mines.ToList()[0]);

        ViewBag.Title = "Добавление участка";
        ViewBag.Header = "Добавление сведений о участке";
        return View("UpdatePlotById", new Plot());
    }


    // Вывод страницы с формой редактирования сведений о участке
    public IActionResult UpdatePlotById(int id)
    {
        Plot plot = _db.Plots.First(p => p.Id == id);

        // передаём список типов угля
        ViewBag.Coals = new SelectList(_db.CoalTypes.ToList(), "Id", "TypeName", _db.CoalTypes.ToList()[0]);

        // передаём список типов выработки
        ViewBag.Productions = new SelectList(_db.ProductionTypes.ToList(), "Id", "TypeName", _db.ProductionTypes.ToList()[0]);

        // передаём список шахт
        ViewBag.Mines = new SelectList(_db.Mines.ToList(), "Id", "NameAndCity", _db.Mines.ToList()[0]);

        ViewBag.Title = "Редактирование учаска";
        ViewBag.Header = "Редактирование сведений о участке";
        return View(plot);
    }


    // обработчик сведений, полученных из формы редактирования
    // данных участка
    [HttpPost]
    public IActionResult UpdatePlot(Plot plotData)
    {
        try
        {
            // если пришёл новый элемент добавляем его в коллекцию
            if (plotData.Id == null)
                _db.Plots.Add(plotData);
            else
                _db.Plots.Update(plotData);

            _db.SaveChanges();
        }
        catch (Exception ex)
        {
            ViewBag.ErrorMessage = ex.Message;
        }
        // вывести обновленную коллекцию
        return Redirect("~/MinesAndPlots/Index");
    }

    // удаление участка по Id
    public async Task<IActionResult> DeletePlotById(int id)
    {
        // найти нужного сотрудника
        Plot plot = _db.Plots.First(p => p.Id == id);

        // если нашли удаляем
        if (plot != null) _db.Plots.Remove(plot);

        await _db.SaveChangesAsync();

        // вывести обновленную коллекцию
        return Redirect("~/MinesAndPlots/Index");
    }

    #endregion
}
