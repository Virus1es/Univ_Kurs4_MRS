using Kursavaya_ASP.Models;
using Kursavaya_ASP.Models.Dto;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
//using Microsoft.Office.Interop.Excel;
using OfficeOpenXml;
using static System.Runtime.InteropServices.JavaScript.JSType;
using System.Reflection.Metadata;
using System.Text;
using Microsoft.Extensions.Primitives;
//using Application = Microsoft.Office.Interop.Excel.Application;


namespace Kursavaya_ASP.Controllers;

public class ReportsController : Controller
{
    private static GssContext _db;

    // В конструкторе получаем доступ к контексту базы данных
    public ReportsController(GssContext context) =>
        _db = context;

    // 1 часть отчётов: простые запросы
    public IActionResult SimpleQueries()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        ViewBag.CurUser = user;

        // симметричное внутреннее соединение с условием(по дате)
        // выбирает ЧС случившиеся в выбранную дату
        ViewBag.SelectIncidentsByDate = _db.Database.SqlQueryRaw<SelectIncidentsByDate>("EXEC SelectIncidentsByDate '2022-10-11'")
                                                        .ToList();

        // симметричное внутреннее соединение с условием(по дате)
        // выбирает работников устраняющих ЧС в выбранную дату
        ViewBag.SelectIncidentInersByDate = _db.Database
                                               .SqlQueryRaw<SelectIncidentInersByDate>("EXEC SelectIncidentInersByDate '2022-10-11'")
                                               .ToList();

        // левое внешнее соединение
        // типы ЧС по которым нет ни одного случая
        ViewBag.LeftJoin = _db.Database.SqlQueryRaw<string>("select * from ViewEmergencyTypesWithoutIncidents")
                                       .ToList();

        // правое внешнее соединение
        // рабочие не участвовавшие в устранениях ЧС
        ViewBag.RightJoin = _db.Database.SqlQueryRaw<EmployeesWithPosAndDep>("select * from ViewEmployeesWithoutIncidents")
                                        .ToList();

        // запрос на запросе по принципу левого соединения
        // рабочие, которые не участвовали в устранениях ЧС в определённую дату
        ViewBag.QueryOnQuery = _db.Database.SqlQueryRaw<EmployeesWithPosAndDep>("EXEC SelectEmployeesWithoutInsByDate '2022-10-11'")
                                           .ToList();

        // + 2 запроса по внешнему ключу "реализованы" у админа: рабочие и участки шахт
        
        return View();
    }

    // 2 часть отчётов: сложные запросы
    public IActionResult DifficultQueries()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        ViewBag.CurUser = user;

        // Итоговый без условия
        // Количество чрезвычайных ситуаций по типам
        ViewBag.WithoutCond = _db.Database.SqlQueryRaw<CountEmergenciesByType>("select * from ViewCountEmergenciesByType")
                                          .ToList();

        // Итоговый с условием на данные
        // Количество ЧС по датам с ущербом на сумму больше указанной
        ViewBag.WithCondData = _db.Database.SqlQueryRaw<GroupIncidentsByDamage>("exec SelectGroupIncidentsByDamage 300000")
                                            .ToList();

        // Итоговый с условием на группы
        // Участки с суммарным ущербом за всё время больше указанного
        ViewBag.WithCondGroup = _db.Database
                                   .SqlQueryRaw<GroupPlotsByDamageAndRangeDate>("exec SelectGroupPlotsByDamage 300000")
                                   .ToList();

        // Итоговый с условием на группы и данные
        // Участки, где суммарный ущерб больше указанного за определённый промежуток времени
        ViewBag.WithCondDataAndGroup = _db.Database
                                          .SqlQueryRaw<GroupPlotsByDamageAndRangeDate>(
                                              "exec SelectGroupPlotsByDamageAndRangeDate 300000, '2022-01-01', '2023-01-01'")
                                          .ToList();

        // Запрос на запросе по принципу итогового запроса
        // Количетсво ЧС с минимальным ущербом для каждой шахты
        ViewBag.QueryOnQuery = _db.Database
                                  .SqlQueryRaw<CountIncidentsByMinDamage>("select * from ViewCountIncidentsByMinDamage")
                                  .ToList();

        // Запрос с подзапросом
        // Шахты находящиеся в определённом городе
        ViewBag.WithSubQuery = _db.Database.SqlQueryRaw<string>("exec SelectMinesByCity 'Донецк'")
                                           .ToList();
        return View();
    }

    // 3 часть отчётов: доп запросы
    public IActionResult AddQueries()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        ViewBag.CurUser = user;

        // запрос с подзапросом(IN)
        // рабочие учавствовавшие в устранении слабых проишествий
        ViewBag.QueryIn = _db.Database.SqlQueryRaw<EmployeesInfo>("select * from ViewInersWeakIncidents")
                                      .ToList();

        // запрос с подзапросом(NOT IN)
        // рабочие вступившие на службу с 2000
        ViewBag.QueryNotIn = _db.Database.SqlQueryRaw<EmployeesSienceTwo>("select * from ViewEmployeesSienceTwo")
                                         .ToList();

        // запрос с подзапросом(Case)
        // если проиишествие с ущербом более чем 500000 вывести "Сильное" иначе "Обычное"
        ViewBag.QueryCase = _db.Database.SqlQueryRaw<IncidentsWithComment>("select * from ViewIncidentsWithComment")
                                        .ToList();

        // запрос с условием по маске
        // выбрать всех рабочих с именем начинающимся на А
        ViewBag.QueryMask = _db.Database.SqlQueryRaw<EmployeesInfo>("select * from ViewEmployeesSurnameLikeA")
                                        .ToList();

        // запрос с объедтнением
        // рабочие бойцы и командиры взвода
        ViewBag.QueryUnion = _db.Database.SqlQueryRaw<EmployeesCommonAndComandors>("select * from ViewEmployeesCommonAndcomandors")
                                         .ToList();

        // запрос: всего и в том числе
        // участие отделений в устранениях ЧП и всего
        ViewBag.QueryAll = _db.Database.SqlQueryRaw<CountDepIners>("exec CountDepIners").ToList();

        return View();
    }

    
    // используем для правильной записи в Excel с заголовками
    public record ForWrite(string Name, string Value);

    // импорт запроса в Excel
    public IActionResult ExcelImport()
    {
        var data = _db.Database.SqlQueryRaw<CountEmergenciesByType>("select * from ViewCountEmergenciesByType")
                                          .ToList();

        // создаём ещё 1 список с заголовками полей
        List<ForWrite> forWrite = [new ForWrite("Тип проишествия", "Количество проишествий")];

        // заполняем значениями
        foreach (var item in data) forWrite.Add(new ForWrite(item.TypeName, item.Amount.ToString()));

        // собственно запись в Excel
        try
        {
            using var package = new ExcelPackage(new FileInfo("Количество чрезвычайных ситуаций по типам.xlsx"));
            ExcelWorksheet excelWorksheet = package.Workbook.Worksheets.Add("Отчёт");
            excelWorksheet.Cells.LoadFromCollection(forWrite, false);
            package.Save();
        }
        catch (Exception) { }

        return Redirect("~/Home/Index");
    }

    
}
