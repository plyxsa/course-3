using Microsoft.AspNetCore.Builder;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "M01_1",
    pattern: "MResearch/M01/1",
    defaults: new { controller = "TMResearch", action = "M01" }
);

app.MapControllerRoute(
    name: "M01_2",
    pattern: "MResearch/M01",
    defaults: new { controller = "TMResearch", action = "M01" }
);

app.MapControllerRoute(
    name: "M01_3",
    pattern: "MResearch",
    defaults: new { controller = "TMResearch", action = "M01" }
);

app.MapControllerRoute(
    name: "M01_4",
    pattern: "",
    defaults: new { controller = "TMResearch", action = "M01" }
);

app.MapControllerRoute(
    name: "M01_5",
    pattern: "V2/MResearch/M01",
    defaults: new { controller = "TMResearch", action = "M01" }
);

app.MapControllerRoute(
    name: "M01_6",
    pattern: "V3/MResearch/{str}/M01",
    defaults: new { controller = "TMResearch", action = "M01" }
);

app.MapControllerRoute(
    name: "M02_1",
    pattern: "V2",
    defaults: new { controller = "TMResearch", action = "M02" }
);

app.MapControllerRoute(
    name: "M02_2",
    pattern: "V2/MResearch",
    defaults: new { controller = "TMResearch", action = "M02" }
);

app.MapControllerRoute(
    name: "M02_3",
    pattern: "V2/MResearch/M02",
    defaults: new { controller = "TMResearch", action = "M02" }
);

app.MapControllerRoute(
    name: "M02_4",
    pattern: "MResearch/M02",
    defaults: new { controller = "TMResearch", action = "M02" }
);

app.MapControllerRoute(
    name: "M02_5",
    pattern: "V3/MResearch/{str}/M02",
    defaults: new { controller = "TMResearch", action = "M02" }
);

app.MapControllerRoute(
    name: "M03_1",
    pattern: "V3",
    defaults: new { controller = "TMResearch", action = "M03" }
);

app.MapControllerRoute(
    name: "M03_2",
    pattern: "V3/MResearch/{str}",
    defaults: new { controller = "TMResearch", action = "M03" }
);

app.MapControllerRoute(
    name: "M03_3",
    pattern: "V3/MResearch/{str}/M03",
    defaults: new { controller = "TMResearch", action = "M03" }
);

app.MapControllerRoute(
    name: "catchall",
    pattern: "{*url}",
    defaults: new { controller = "TMResearch", action = "MXX" }
);

app.Run();
