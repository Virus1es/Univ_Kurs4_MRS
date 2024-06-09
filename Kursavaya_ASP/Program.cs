using System.Globalization;
using Kursavaya_ASP.Models;
using Microsoft.EntityFrameworkCore;

// для решения проблемы ввода дробных чиел в поля типа number
CultureInfo.DefaultThreadCurrentCulture = new CultureInfo("en");
CultureInfo.DefaultThreadCurrentUICulture = new CultureInfo("en");

var builder = WebApplication.CreateBuilder(args);

// добавление функционала MVC
builder.Services.AddControllersWithViews();

// подключение EF как сервиса - поставщика данных
// строку подключения определяем в appsettings.json
string connection = builder.Configuration.GetConnectionString("DefaultConnection");

builder.Services.AddDbContext<GssContext>(
    options => options
        // подключение lazy loading, сначала установить NuGet-пакет Microsoft.EntityFrameworkCore.Proxies
        .UseLazyLoadingProxies()
        .UseSqlServer(connection));

var app = builder.Build();

// для доступа к HTML, CSS в папке wwwroot
app.UseStaticFiles();

// разрешение работы маршрутизации
app.UseRouting();

// обязательное задание маршрута
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();

