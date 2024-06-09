using Kursavaya_ASP.Models;
using Kursavaya_ASP.Models.Dto;
using Microsoft.EntityFrameworkCore;
using Kursavaya_ASP.Models.Tables.Main;
using Newtonsoft.Json;
using static System.Runtime.InteropServices.JavaScript.JSType;
using System.IO;
using System.Text;

namespace Kursavaya_ASP.Infrastructure;

public class Utils
{
    static Random random = new Random();

    // определение роли пользователя
    public static string ChooseRole(GssContext db, string login)
    {
        // выбираем всех пользователей и их роли в бд
        List<RoleUsers> users = db.Database.SqlQueryRaw<RoleUsers>("EXEC sp_helprolemember")
                                           .ToList();

        // если не нашли нужного пользователя кидаем исключение
        var user = users.Find(u => u.MemberName == login) ?? throw new Exception($"У данного пользователя нет роли {login}");

        // выбираем роль пользователя
        string role = user.DbRole switch
        {
            "admin" => "Администратор",
            "comandor" => "Офицер",
            _ => "Рабочий"
        };

        return role;
    }

    // случайный день
    public static DateTime RandomDay(DateTime start, DateTime end)
    {
        int range = (end - start).Days;
        return start.AddDays(random.Next(range));
    }

    #region заполнение таблиц псевдоданными
    
    public static void FillTables(GssContext db)
    {
        // заполнение таблицы Департаменты
        //FillDepartments(db);

        // заполнение таблицы Шахты
        //FillMines(db);

        // заполнение таблицы Участки
        //FillPlots(db);

        // заполнение таблицы Рабочие
        //FillEmployees(db);

        // заполнение таблицы журнал чс
        //FillIncidents(db);

        // заполнение таблицы участия в устранениях ЧС
        FillIncidentIners(db);
    }

    // заполнение таблицы json
    public static void FillJson_Text(GssContext db)
    {
        var employees = db.Employees.ToList();
        // сериализуем в Json добавляем каждого рабочего в таблицу
        foreach (var item in employees)
        {
            db.JsonTable.Add(new JsonTable() { 
                Dataj = $"{{ \"FirstName\": \"{item.FirstName}\", " +
                        $"\"Surname\": \"{item.Surname}\", " +
                        $"\"Patronymic\": \"{item.Patronymic}\", " +
                        $"\"Position\": {{ " +
                        $"\"PositionName\": \"{item.Position.PositionName}\" " +
                        $"}}, " +
                        $"\"Salary\": {item.Salary}, " +
                        $"\"YearStart\": {item.YearStart}, " +
                        $"\"Birthday\": \"{item.Birthday:yyyy-MM-dd}\", " +
                        $"\"Department\": {{ " +
                        $"\"DepName\": \"{item.Department.DepName}\", " +
                        $"\"City\": {{ " +
                        $"\"CityName\": \"{item.Department.City.CityName}\"" +
                        $"}}, " +
                        $"\"Phone\": \"{item.Department.Phone}\", " +
                        $"\"YearCreation\": {item.Department.YearCreation} " +
                        $"}} " +
                        $"}}"
            });
        }
        db.SaveChangesAsync();
    }

    // заполнение таблицы Департаменты
    private static void FillDepartments(GssContext db)
    {
        List<string> strings = ["Отчаяные", "Ангелы", "Ратник", "Дружина", "Крепкие"];
        for (int i = 0; i < 5; i++)
        {
            db.Departments.Add(new Department()
            {
                DepName = strings[i],
                IdCity = random.Next(1, 16),
                Phone = $"+7949{random.Next(1000000, 9999999)}",
                YearCreation = random.Next(1980, 2008)
            });
        }
        db.SaveChangesAsync();
    }

    // заполнение таблицы Шахты
    private static void FillMines(GssContext db)
    {
        List<string> strings = ["Жильная", "Добрая", "Золотая", "Миниральная", "Счастливая"];
        for (int i = 0; i < 5; i++)
        {
            db.Mines.Add(new Mine()
            {
                MineName = strings[i],
                IdCity = random.Next(1, 16),
                MaxDepth = random.Next(100, 6000),
                Area = random.Next(100, 3000)
            });
        }
        db.SaveChangesAsync();
    }

    // заполнение таблицы Участки
    private static void FillPlots(GssContext db)
    {
        for (int i = 0; i < 30; i++)
        {
            // шахта
            int mine = random.Next(1, 10);

            // берём имя шахты для присвоения участку более уникального номера
            string mineName = db.Mines.Where(m => m.Id == mine).First().MineName.ToUpper();

            // название шахты
            string number = $"{mineName[0]}{mineName[mineName.Length - 1]}{random.Next(1000, 9999)}";

            db.Plots.Add(new Plot()
            {
                Number = number,
                IdMine = mine,
                LengthPlot = random.Next(100, 3000),
                IdCoalType = random.Next(1, 7),
                IdProductionType = random.Next(1, 4),
                YearStart = random.Next(1960, 2018)
            });
        }
        db.SaveChangesAsync();
    }

    // заполнение таблицы Рабочие
    private static void FillEmployees(GssContext db)
    {
        List<string> maleNames = ["Илья", "Вадим", "Антон", "Макар", "Константин", "Артём", "Михаил",
                                  "Павел", "Марк", "Алесандр", "Иван", "Пётр", "Николай", "Егор"];
        List<string> femleNames = ["Мирия", "Валерия", "Александра", "Любовь", "Вера", "Елизавета", "Ангелина",
                                   "Дарья", "Анастасия", "Евгения", "Вероника", "Ксения"];
        List<string> surnames = ["Коваленко", "Черных", "Дюма", "Моруа", "Золя", "Рушайло", "Колесниченко",
                                 "Долгих", "Удалых", "Оглу", "Гримм"];
        for (int i = 0; i < 40; i++)
        {
            var names = maleNames;
            string last = "вич";
            if (random.Next(1, 3) == 1)
            {
                names = femleNames;
                last = "вна";
            }

            db.Employees.Add(new Employee()
            {
                FirstName = names[random.Next(0, names.Count - 1)],
                Surname = surnames[random.Next(0, surnames.Count - 1)],
                Patronymic = $"{maleNames[random.Next(0, maleNames.Count - 1)]}{last}",
                IdDepartment = random.Next(1, 11),
                IdPosition = random.Next(1, 5),
                Salary = random.Next(10000, 100001),
                YearStart = random.Next(1985, 2006),
                Birthday = RandomDay(new DateTime(1975, 1, 1), new DateTime(2006, 12, 31))
            });
        }
        db.SaveChangesAsync();
    }

    // заполнение таблицы Журнал ЧС
    private static void FillIncidents(GssContext db)
    {
        for (int i = 0; i < 100; i++)
        {
            db.Incidents.Add(new Incident()
            {
                IdPlot = random.Next(1, 36),
                IdEmergencyCause = random.Next(1, 3),
                IdEmergencyType = random.Next(1, 7),
                IncDate = RandomDay(new DateTime(1970, 1, 1), DateTime.Now),
                Damage = random.Next(0, 1000001)
            });
        }
        db.SaveChangesAsync();
    }

    // заполнение таблицы участие в устранении ЧС
    private static void FillIncidentIners(GssContext db)
    {
        for (int i = 0; i < 10000; i++)
        {
            db.IncidentIners.Add(new IncidentIner()
            {
                IdIncident = random.Next(1, 106),
                IdEmployee = random.Next(1, 61),
                DaysAmount = random.Next(1, 11)
            });
        }
        db.SaveChangesAsync();
    }

    #endregion


}
