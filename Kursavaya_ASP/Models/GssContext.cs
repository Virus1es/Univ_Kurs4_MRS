using Kursavaya_ASP.Models.Tables.References;
using Kursavaya_ASP.Models.Tables.Main;
using Microsoft.EntityFrameworkCore;

namespace Kursavaya_ASP.Models;

// класс описывающий базу данных Горно-спасательной службы
public class GssContext : DbContext
{
    #region таблицы базы данных

    public DbSet<City> Cities => Set<City>();
    public DbSet<CoalType> CoalTypes => Set<CoalType>();
    public DbSet<EmergencyCause> EmergencyCauses => Set<EmergencyCause>();
    public DbSet<EmergencyType> EmergencyTypes => Set<EmergencyType>();
    public DbSet<Position> Positions => Set<Position>();
    public DbSet<ProductionType> ProductionTypes => Set<ProductionType>();
    public DbSet<Mine> Mines => Set<Mine>();
    public DbSet<Plot> Plots => Set<Plot>();
    public DbSet<User> Users => Set<User>();
    public DbSet<Department> Departments => Set<Department>();
    public DbSet<Employee> Employees => Set<Employee>();
    public DbSet<Incident> Incidents => Set<Incident>();
    public DbSet<IncidentIner> IncidentIners => Set<IncidentIner>();
    public DbSet<JsonTable> JsonTable => Set<JsonTable>();

    #endregion

    // конструктор контекста
    public GssContext()
    { }

    // конструктор с параметром, испоьзуется в Program.cs
    public GssContext(DbContextOptions<GssContext> options) : base(options)
    { }

    // настройка модели на стадии создания
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Задание отношений между таблицами при помощи Fluent API

        // Настройка отношений "один ко многим"

        // таблица Рабочие
        modelBuilder.Entity<Employee>()
            .HasOne(e => e.Position)
            .WithMany(e => e.Employees)
            .HasForeignKey(e => e.IdPosition);

        modelBuilder.Entity<Employee>()
            .HasOne(e => e.Department)
            .WithMany(e => e.Employees)
            .HasForeignKey(e => e.IdDepartment);
        
        // таблица Отделы
        modelBuilder.Entity<Department>()
            .HasOne(d => d.City)
            .WithMany(d => d.Departments)
            .HasForeignKey(d => d.IdCity);

        // таблица Чрезвычайные проишествия
        modelBuilder.Entity<Incident>()
            .HasOne(i => i.Plot)
            .WithMany(i => i.Incidents)
            .HasForeignKey(i => i.IdPlot);

        modelBuilder.Entity<Incident>()
            .HasOne(i => i.EmergencyCause)
            .WithMany(i => i.Incidents)
            .HasForeignKey(i => i.IdEmergencyCause);

        modelBuilder.Entity<Incident>()
            .HasOne(i => i.EmergencyType)
            .WithMany(i => i.Incidents)
            .HasForeignKey(i => i.IdEmergencyType);

        // таблица Участники ликвидаций проишествий
        modelBuilder.Entity<IncidentIner>()
            .HasOne(i => i.Incident)
            .WithMany(i => i.IncidentIners)
            .HasForeignKey(i => i.IdIncident);

        modelBuilder.Entity<IncidentIner>()
            .HasOne(i => i.Employee)
            .WithMany(i => i.IncidentIners)
            .HasForeignKey(i => i.IdEmployee);

        // таблица Шахты
        modelBuilder.Entity<Mine>()
            .HasOne(m => m.City)
            .WithMany(m => m.Mines)
            .HasForeignKey(m => m.IdCity);

        // таблица участки
        modelBuilder.Entity<Plot>()
            .HasOne(p => p.Mine)
            .WithMany(p => p.Plots)
            .HasForeignKey(p => p.IdMine);

        modelBuilder.Entity<Plot>()
            .HasOne(p => p.CoalType)
            .WithMany(p => p.Plots)
            .HasForeignKey(p => p.IdCoalType);

        modelBuilder.Entity<Plot>()
            .HasOne(p => p.ProductionType)
            .WithMany(p => p.Plots)
            .HasForeignKey(p => p.IdProductionType);

        // таблица Пользователей
        modelBuilder.Entity<User>()
            .HasOne(u => u.Department)
            .WithMany(u => u.Users)
            .HasForeignKey(u => u.IdDepartment);
    }

}
