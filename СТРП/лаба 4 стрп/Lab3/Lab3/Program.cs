var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews(); 

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error"); // маршрут для обработки ошибок
    app.UseHsts();
}

app.UseHttpsRedirection(); // перенаправление всех HTTP-запросов на HTTPS
app.UseStaticFiles(); // указывает приложению обслуживать статические файлы

app.UseRouting(); // EndpointRoutingMiddleware 

app.UseAuthorization(); 

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();