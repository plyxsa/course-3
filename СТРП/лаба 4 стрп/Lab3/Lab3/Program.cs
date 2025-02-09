var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews(); 

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error"); // ������� ��� ��������� ������
    app.UseHsts();
}

app.UseHttpsRedirection(); // ��������������� ���� HTTP-�������� �� HTTPS
app.UseStaticFiles(); // ��������� ���������� ����������� ����������� �����

app.UseRouting(); // EndpointRoutingMiddleware 

app.UseAuthorization(); 

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();