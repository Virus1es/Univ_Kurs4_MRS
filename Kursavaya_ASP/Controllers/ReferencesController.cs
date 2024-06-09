using Kursavaya_ASP.Models;
using Kursavaya_ASP.Models.Dto;
using Kursavaya_ASP.Models.Tables.Main;
using Kursavaya_ASP.Models.Tables.References;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace Kursavaya_ASP.Controllers;

// контроллер обрабатывающий действия со справочниками
public class ReferencesController : Controller
{
    private static GssContext _db;

    // В конструкторе получаем доступ к контексту базы данных
    public ReferencesController(GssContext context) =>
        _db = context;

    #region Вспомогательные функции

    // получение текущего пользователя из Cookie
    private string GetCurUserFromCookie()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        return user ?? "";
    }

    #endregion

    #region Города

    // вызов страницы со списком Городов
    public async Task<IActionResult> Cities()
    {
        ViewBag.CurUser = GetCurUserFromCookie();

        return View(await _db.Cities.ToListAsync());
    }

    // добавление города
    public IActionResult AddCity() 
    {
        ViewBag.Header = ViewBag.Title = "Добавление города";
        ViewBag.ColName = "Название города";
        return View("UpdateById", new ForUpdeteRef() { Table = "Cities" });
    }

    // Вывод страницы с формой редактирования города
    public IActionResult UpdateCityById(int id)
    {
        City city = _db.Cities.First(c => c.Id == id);

        ViewBag.Header = ViewBag.Title = "Изменение города";
        ViewBag.ColName = "Название города";
        return View("UpdateById", new ForUpdeteRef() { Id = city.Id, Table = "Cities", Column = city.CityName });
    }

    // удаление города по Id
    public async Task<IActionResult> DeleteCityById(int id)
    {
        try
        {
            // найти нужного сотрудника
            City city = _db.Cities.First(c => c.Id == id);

            // если нашли удаляем
            if (city != null) _db.Cities.Remove(city);

            await _db.SaveChangesAsync();
        }
        catch (Exception ex)
        { }

        // вывести обновленную коллекцию
        return Redirect("~/References/Cities");
    }

    #endregion

    #region Типы угля

    // вызов страницы со списком Типов угля
    public async Task<IActionResult> CoalTypes()
    {
        ViewBag.CurUser = GetCurUserFromCookie();

        return View(await _db.CoalTypes.ToListAsync());
    }

    // добавление типа угля
    public IActionResult AddCoalType()
    {
        ViewBag.Header = ViewBag.Title = "Добавление типа угля";
        ViewBag.ColName = "Название типа угля";
        return View("UpdateById", new ForUpdeteRef() { Table = "CoalTypes" });
    }

    // Вывод страницы с формой редактирования типа угля
    public IActionResult UpdateCoalTypeById(int id)
    {
        CoalType type = _db.CoalTypes.First(c => c.Id == id);

        ViewBag.Header = ViewBag.Title = "Изменение типа угля";
        ViewBag.ColName = "Название типа угля";
        return View("UpdateById", new ForUpdeteRef() { Id = type.Id, Table = "CoalTypes", Column = type.TypeName });
    }

    // удаление типа угля по Id
    public async Task<IActionResult> DeleteCoalTypeById(int id)
    {
        try
        {
            // найти нужного сотрудника
            CoalType type = _db.CoalTypes.First(c => c.Id == id);

            // если нашли удаляем
            if (type != null) _db.CoalTypes.Remove(type);

            await _db.SaveChangesAsync();
        }
        catch (Exception ex)
        { }

        // вывести обновленную коллекцию
        return Redirect("~/References/CoalTypes");
    }

    #endregion

    #region Причины ЧС

    // вызов страницы со списком Причин ЧС
    public async Task<IActionResult> EmergencyCauses()
    {
        ViewBag.CurUser = GetCurUserFromCookie();

        return View(await _db.EmergencyCauses.ToListAsync());
    }

    // добавление причины ЧС
    public IActionResult AddEmergencyCause()
    {
        ViewBag.Header = ViewBag.Title = "Добавление причины ЧС";
        ViewBag.ColName = "Название причины ЧС";
        return View("UpdateById", new ForUpdeteRef() { Table = "EmergencyCauses" });
    }

    // Вывод страницы с формой редактирования причины ЧС
    public IActionResult UpdateEmergencyCauseById(int id)
    {
        EmergencyCause cause = _db.EmergencyCauses.First(c => c.Id == id);

        ViewBag.Header = ViewBag.Title = "Изменение причины ЧС";
        ViewBag.ColName = "Название причины ЧС";
        return View("UpdateById", new ForUpdeteRef() { Id = cause.Id, Table = "EmergencyCauses", Column = cause.CauseName });
    }

    // удаление причины ЧС по Id
    public async Task<IActionResult> DeleteEmergencyCauseById(int id)
    {
        try
        {
            // найти нужную причину ЧС
            EmergencyCause cause = _db.EmergencyCauses.First(c => c.Id == id);

            // если нашли удаляем
            if (cause != null) _db.EmergencyCauses.Remove(cause);

            await _db.SaveChangesAsync();
        }
        catch (Exception ex)
        { }

        // вывести обновленную коллекцию
        return Redirect("~/References/EmergencyCauses");
    }

    #endregion

    #region Типы ЧС

    // вызов страницы со списком Типов ЧС
    public async Task<IActionResult> EmergencyTypes()
    {
        ViewBag.CurUser = GetCurUserFromCookie();

        return View(await _db.EmergencyTypes.ToListAsync());
    }

    // добавление типа ЧС
    public IActionResult AddEmergencyType()
    {
        ViewBag.Header = ViewBag.Title = "Добавление типа ЧС";
        ViewBag.ColName = "Название типа ЧС";
        return View("UpdateById", new ForUpdeteRef() { Table = "EmergencyTypes" });
    }

    // Вывод страницы с формой редактирования типа ЧС
    public IActionResult UpdateEmergencyTypeById(int id)
    {
        EmergencyType type = _db.EmergencyTypes.First(t => t.Id == id);

        ViewBag.Header = ViewBag.Title = "Изменение типа ЧС";
        ViewBag.ColName = "Название типа ЧС";
        return View("UpdateById", new ForUpdeteRef() { Id = type.Id, Table = "EmergencyTypes", Column = type.TypeName });
    }

    // удаление типа ЧС по Id
    public async Task<IActionResult> DeleteEmergencyTypeById(int id)
    {
        try
        {
            // найти нужный тип ЧС
            EmergencyType type = _db.EmergencyTypes.First(t => t.Id == id);

            // если нашли удаляем
            if (type != null) _db.EmergencyTypes.Remove(type);

            await _db.SaveChangesAsync();
        }
        catch (Exception ex)
        { }

        // вывести обновленную коллекцию
        return Redirect("~/References/EmergencyTypes");
    }

    #endregion

    #region Должности

    // вызов страницы со списком Должностей
    public async Task<IActionResult> Positions()
    {
        ViewBag.CurUser = GetCurUserFromCookie();

        return View(await _db.Positions.ToListAsync());
    }

    // добавление должности
    public IActionResult AddPosition()
    {
        ViewBag.Header = ViewBag.Title = "Добавление должности";
        ViewBag.ColName = "Название должности";
        return View("UpdateById", new ForUpdeteRef() { Table = "Positions" });
    }

    // Вывод страницы с формой редактирования должности
    public IActionResult UpdatePositionById(int id)
    {
        Position position = _db.Positions.First(p => p.Id == id);

        ViewBag.Header = ViewBag.Title = "Изменение должности";
        ViewBag.ColName = "Название должности";
        return View("UpdateById", new ForUpdeteRef() { Id = position.Id, Table = "Positions", Column = position.PositionName });
    }

    // удаление должности по Id
    public async Task<IActionResult> DeletePositionById(int id)
    {
        try
        {
            // найти нужную должность
            Position position = _db.Positions.First(p => p.Id == id);

            // если нашли удаляем
            if (position != null) _db.Positions.Remove(position);

            await _db.SaveChangesAsync();
        }
        catch (Exception ex)
        { }

        // вывести обновленную коллекцию
        return Redirect("~/References/Positions");
    }

    #endregion

    #region Типы выроботки

    // вызов страницы со списком Типов выроботки
    public async Task<IActionResult> ProductionTypes()
    {
        ViewBag.CurUser = GetCurUserFromCookie();

        return View(await _db.ProductionTypes.ToListAsync());
    }

    // добавление типа выроботки
    public IActionResult AddProductionType()
    {
        ViewBag.Header = ViewBag.Title = "Добавление типа выроботки";
        ViewBag.ColName = "Название типа выроботки";
        return View("UpdateById", new ForUpdeteRef() { Table = "ProductionTypes" });
    }

    // Вывод страницы с формой редактирования типа выроботки
    public IActionResult UpdateProductionTypeById(int id)
    {
        ProductionType type = _db.ProductionTypes.First(t => t.Id == id);

        ViewBag.Header = ViewBag.Title = "Изменение типа выроботки";
        ViewBag.ColName = "Название типа выроботки";
        return View("UpdateById", new ForUpdeteRef() { Id = type.Id, Table = "ProductionTypes", Column = type.TypeName });
    }

    // удаление должности по Id
    public async Task<IActionResult> DeleteProductionTypeById(int id)
    {
        try
        {
            // найти нужный тип
            ProductionType type = _db.ProductionTypes.First(t => t.Id == id);

            // если нашли удаляем
            if (type != null) _db.ProductionTypes.Remove(type);

            await _db.SaveChangesAsync();
        }
        catch (Exception ex)
        { }

        // вывести обновленную коллекцию
        return Redirect("~/References/ProductionTypes");
    }

    #endregion

    // используем для вывода
    public IActionResult UpdateById(ForUpdeteRef data) => View(data);

    // обработчик сведений, полученных из формы редактирования
    // данных справочника
    [HttpPost]
    public IActionResult Update(ForUpdeteRef data)
    {
        try
        {
            // в зависимости от того что мы изменяли выполняем нужное действие с нужной таблицей
            // если пришёл новый элемент добавляем его в коллекцию
            // иначе изменяем существующий
            switch (data.Table)
            {
                case "Cities":
                    City city = new() { Id = data.Id, CityName = data.Column };
                    if (city.Id == null)
                        _db.Cities.Add(city);
                    else
                        _db.Cities.Update(city);
                    break;
                case "CoalTypes":
                    CoalType coalType = new() { Id = data.Id, TypeName = data.Column };
                    if (coalType.Id == null)
                        _db.CoalTypes.Add(coalType);
                    else
                        _db.CoalTypes.Update(coalType);
                    break;
                case "EmergencyCauses":
                    EmergencyCause causes = new() { Id = data.Id, CauseName = data.Column };
                    if (causes.Id == null)
                        _db.EmergencyCauses.Add(causes);
                    else
                        _db.EmergencyCauses.Update(causes);
                    break;
                case "EmergencyTypes":
                    EmergencyType type = new() { Id = data.Id, TypeName = data.Column };
                    if (type.Id == null)
                        _db.EmergencyTypes.Add(type);
                    else
                        _db.EmergencyTypes.Update(type);
                    break;
                case "Positions":
                    Position position = new() { Id = data.Id, PositionName = data.Column };
                    if (position.Id == null)
                        _db.Positions.Add(position);
                    else
                        _db.Positions.Update(position);
                    break;
                case "ProductionTypes":
                    ProductionType ptype = new() { Id = data.Id, TypeName = data.Column };
                    if (ptype.Id == null)
                        _db.ProductionTypes.Add(ptype);
                    else
                        _db.ProductionTypes.Update(ptype);
                    break;
                default:
                    break;
            }

            _db.SaveChanges();
        }
        catch (Exception ex)
        {
            ViewBag.ErrorMessage = ex.Message;
        }
        // вывести обновленную коллекцию
        return Redirect($"~/References/{data.Table}");
    }
}
