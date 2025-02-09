using Microsoft.EntityFrameworkCore;
using UWSR.Data;
using Microsoft.AspNetCore.Http;

var builder = WebApplication.CreateBuilder(args);

// ��������� ����������� ��� ������
builder.Services.AddDistributedMemoryCache();  // ���������� ������ ��� �������� ������

// ��������� ������
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);  // ����� ����� ������
    options.Cookie.HttpOnly = true;  // ��� ��������� ������������
    options.Cookie.IsEssential = true;  // ������ cookie ������������� ��� ������ � ��������
});

// ��������� ������ ��� ������ � ������������� � ���������������
builder.Services.AddControllersWithViews();

// ��������� ����������� � ���� ������ ����� Entity Framework
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// �������� ���-����������
var app = builder.Build();

// ������������� ������ � ����������
app.UseSession();

// ��������� ��������� �������� � ���������
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");  // ��������� ������
    app.UseHsts();  // ������������ �� �������� �������
}

app.UseHttpsRedirection();  // ��������������� �� HTTPS
app.UseStaticFiles();  // ����������� �����, ����� ��� CSS, JS

// ��������� ���������
app.UseRouting();  // �������� �������������

// ����������� ������������
app.UseAuthorization();

// ��������� ��������� ��� ������������
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Link}/{action=Index}/{id?}");  // ���������� LinkController �� ���������

// ������ ����������
app.Run();
