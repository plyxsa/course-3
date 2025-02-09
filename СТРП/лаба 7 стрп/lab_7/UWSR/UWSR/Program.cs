using Microsoft.EntityFrameworkCore;
using UWSR.Data;
using Microsoft.AspNetCore.Http;

var builder = WebApplication.CreateBuilder(args);

// Настройка кэширования для сессий
builder.Services.AddDistributedMemoryCache();  // Используем память для хранения сессий

// Настройка сессий
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);  // Время жизни сессии
    options.Cookie.HttpOnly = true;  // Для повышения безопасности
    options.Cookie.IsEssential = true;  // Делает cookie обязательными для работы с сессиями
});

// Настройка службы для работы с контроллерами и представлениями
builder.Services.AddControllersWithViews();

// Настройка подключения к базе данных через Entity Framework
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Создание веб-приложения
var app = builder.Build();

// Использование сессий в приложении
app.UseSession();

// Настройка обработки запросов в пайплайне
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");  // Обработка ошибок
    app.UseHsts();  // Безопасность на продакшн сервере
}

app.UseHttpsRedirection();  // Перенаправление на HTTPS
app.UseStaticFiles();  // Статические файлы, такие как CSS, JS

// Настройка маршрутов
app.UseRouting();  // Включаем маршрутизацию

// Авторизация пользователя
app.UseAuthorization();

// Настройка маршрутов для контроллеров
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Link}/{action=Index}/{id?}");  // Используем LinkController по умолчанию

// Запуск приложения
app.Run();
