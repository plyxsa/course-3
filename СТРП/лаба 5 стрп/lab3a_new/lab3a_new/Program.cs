var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

var app = builder.Build();//приложение создается с помощью метода builder.Build()

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();//Включается перенаправление на HTTPS. 
app.UseStaticFiles();// обслуживать статические ресурсы клиентов.

app.UseRouting();//какие контроллеры и действия будут обрабатывать запросы.

app.UseAuthorization();//определять права доступа к ресурсам.

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Calc}/{action=Index}");
//маршрут по умолчанию для контроллера .Этот маршрут будет использоваться, если URL-адрес запроса не указывает на конкретный контроллер и метод.
app.Run();