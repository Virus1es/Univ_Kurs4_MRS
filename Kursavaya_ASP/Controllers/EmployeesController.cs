using Kursavaya_ASP.Models;
using Kursavaya_ASP.Models.Tables.Main;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace Kursavaya_ASP.Controllers;

public class EmployeesController : Controller
{
    private static GssContext _db;

    // В конструкторе получаем доступ к контексту базы данных
    public EmployeesController(GssContext context) =>
        _db = context;


    public async Task<IActionResult> Index()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);

        // если зашёл администратор перенаправляем его на страницу с отображением всех коллективов
        if (user == "Администратор") return Redirect("~/Employees/IndexForAdmin"); ;

        Request.Cookies.TryGetValue("UserDepartment", out string dep);
        
        int.TryParse(dep, out int idDep);

        ViewBag.CurUser = user;

        ViewBag.EmplAmount = _db.Employees.Count();

        return View(await _db.Employees.Where(e => e.IdDepartment == idDep)
                                   .OrderByDescending(e => e.Position.PositionName)
                                   .ToListAsync());
    }

    // вывод всех коллекстивов отделений для администратора
    public async Task<IActionResult> IndexForAdmin()
    {
        // пользователь в любом случае будет администратор
        ViewBag.CurUser = "Администратор";

        // создаём словать для вывода всех рабочих по отделениям
        Dictionary<string, List<Employee>> employeesByDeps = new Dictionary<string, List<Employee>>();

        var deps = await _db.Departments.ToListAsync();
        var empls = await _db.Employees.ToListAsync();

        // распределяем рабочих по департаментам
        // т. к. 2 разных отделения могут называться одинаково дополнительно выводим город отделения
        for (int i = 0; i < _db.Departments.Count(); i++)
        {
            employeesByDeps.Add($"{deps[i].DepName}, {deps[i].City.CityName}", empls.Where(e => e.IdDepartment == deps[i].Id)
                                                                                    .OrderByDescending(e => e.Position.PositionName)
                                                                                    .ToList());
        }

        return View(employeesByDeps);
    }

    // добавление рабочего
    public IActionResult AddEmployee()
    {
        Request.Cookies.TryGetValue("CurUser", out string user);
        Request.Cookies.TryGetValue("UserDepartment", out string dep);

        Employee employee = new Employee() { IdDepartment = (user != "Администратор") ? int.Parse(dep) : 1 };

        // передаём список отделений ГСС
        ViewBag.Departments = new SelectList(_db.Departments.ToList(), "Id", "NameAndCity", _db.Departments.ToList()[employee.IdDepartment - 1]);

        // передаём список званий
        ViewBag.Positions = new SelectList(_db.Positions.ToList(), "Id", "PositionName", _db.Positions.ToList()[0]);

        // задём макимально возможную дату рождения (человек должно быть 18)
        ViewBag.MaxDate = $"{DateTime.Now.AddYears(-18):yyyy-MM-dd}";

        ViewBag.Title = "Добавление рабочего";
        ViewBag.Header = "Добавление сведений о рабочем";
        return View("UpdateById", employee);
    }


    // Вывод страницы с формой редактирования сведений о рабочем
    public IActionResult UpdateById(int id)
    {
        Employee employee = _db.Employees.First(client => client.Id == id);

        // передаём список отделений ГСС
        ViewBag.Departments = new SelectList(_db.Departments.ToList(), "Id", "NameAndCity", _db.Departments.ToList()[employee.IdDepartment - 1]);

        // передаём список званий
        ViewBag.Positions = new SelectList(_db.Positions.ToList(), "Id", "PositionName", _db.Positions.ToList()[employee.IdPosition - 1]);

        // задём макимально возможную дату рождения (человек должно быть 18)
        ViewBag.MaxDate = $"{DateTime.Now.AddYears(-18):yyyy-MM-dd}";

        ViewBag.Title = "Редактирование рабочего";
        ViewBag.Header = "Редактирование сведений о рабочем";
        return View(employee);
    }


    // обработчик сведений, полученных из формы редактирования
    // данных рабочего
    [HttpPost]
    public IActionResult Update(Employee employeeData)
    {
        try
        {
            // если пришёл новый элемент добавляем его в коллекцию
            if (employeeData.Id == null)
                _db.Employees.Add(employeeData);
            // иначе изменяем существующий
            else
                _db.Employees.Update(employeeData);

            _db.SaveChanges();
        }
        catch (Exception ex)
        {
            ViewBag.ErrorMessage = ex.Message;
        }
        // вывести обновленную коллекцию
        return Redirect("~/Employees/Index");
    }

    // удаление сотрудника по Id
    public async Task<IActionResult> DeleteById(int id)
    {
        // найти нужного сотрудника
        Employee employee = _db.Employees.First(client => client.Id == id);
        
        // если нашли удаляем
        if(employee != null) _db.Employees.Remove(employee);

        await _db.SaveChangesAsync();

        // вывести обновленную коллекцию
        return Redirect("~/Employees/Index");
    }
}
