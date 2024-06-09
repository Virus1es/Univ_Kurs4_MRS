namespace Kursavaya_ASP.Models.Dto;

#region Простые запросы

// симметричное внутреннее соединение с условием(по дате)
// выбирает ЧС случившиеся в выбранную дату
public record SelectIncidentsByDate(DateTime IncDate, string TypeName, string CauseName, string MineName,
                                    string Number, int Damage);

// симметричное внутреннее соединение с условием(по дате)
// выбирает работников устраняющих ЧС в выбранную дату
public record SelectIncidentInersByDate(string EmployeeFullname, DateTime IncDate, string TypeName, string MineName,
                                        string Number, int DaysAmount);

// правое внешнее соединение
// рабочие не участвовавшие в устранениях ЧС
// запрос на запросе по принципу левого соединения
// рабочие, которые не участвовали в устранениях ЧС в определённую дату
public record EmployeesWithPosAndDep(string Surname, string FirstName, string Patronymic, string PositionName, string DepName);


#endregion

#region Сложные запросы

// Итоговый без условия
// Количество чрезвычайных ситуаций по типам 
public record CountEmergenciesByType(string TypeName, int Amount);

// Итоговый с условием на данные
// Количество ЧС по датам с ущербом на сумму больше указанной
public record GroupIncidentsByDamage(DateTime IncDate, int Amount);

// Итоговый с условием на группы
// Участки с суммарным ущербом за всё время больше указанного
// Итоговый с условием на группы и данные
// Участки, где суммарный ущерб больше указанного за определённый промежуток времени
public record GroupPlotsByDamageAndRangeDate(string MineName, string Number, int SumDamage);

// Запрос на запросе по принципу итогового запроса
// Количетсво ЧС с минимальным ущербом для каждой шахты
public record CountIncidentsByMinDamage(string MineName, int IncidentsCount);

#endregion

#region Дополнительные запросы

// запрос с подзапросом(IN)
// рабочие учавствовавшие в устранении слабых проишествий
// запрос с условием по маске
// выбрать всех рабочих с именем начинающимся на А
public record EmployeesInfo(string FirstName, string Surname, string Patronymic, string DepName, string PositionName);

// запрос с подзапросом(NOT IN)
// рабочие вступившие на службу с 2000
public record EmployeesSienceTwo(string FirstName, string Surname, string Patronymic, string DepName, string PositionName,
                                 int YearStart);

// запрос с подзапросом(Case)
// если проиишествие с ущербом более чем 500000 вывести "Сильное" иначе "Обычное"
public record IncidentsWithComment(DateTime IncDate, string Number, string CauseName, string TypeName, int Damage,
                                    string Comment);

// запрос с объедтнением
// рабочие бойцы и командиры взвода
public record EmployeesCommonAndComandors(string Fullname, string DepName, string PositionName);

// запрос всего и в том числе
// участие отделений в устранениях ЧП и всего
public record CountDepIners(string? DepName, int Amount);

#endregion

