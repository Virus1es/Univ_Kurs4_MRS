namespace Kursavaya_ASP.Models.Tables.Main;

// класс описывающий таблицу с данными типа Json
// в основном нужна для выполнения 7 лр
public class JsonTable
{
    // ПК сущности
    public int Id { get; set; }
    
    // строка json
    public string Dataj { get; set; }
}
