var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// 1. Http-обработчик должен быть привязан к расширению XYZ(инициалам студента) и http-методу GET.
// Обработчик должен принимать два параметра (ParmA И ParmB) переданных ему в http-запросе.
// http-ответ (text/plain) обработчика должен иметь следующий формат:  GET-Http-XYZ:ParmA = aaa,ParmB = bbb,
// где  aaa, bbbb значения параметров. 

app.MapGet("/LPV", async (HttpContext context) => {
    context.Response.ContentType = "text/plain";
    await context.Response.WriteAsync($"GET-Http-LPV:ParmA = {context.Request.Query["ParmA"]}," +
                                      $"ParmB = {context.Request.Query["ParmB"]}");
});

///LPV?ParmA=aaa&ParmB=bbb

//2. Http-обработчик должен быть привязан к расширению XYZ(инициалам студента) и http-методу POST.
//Обработчик должен принимать два параметра(ParmA И ParmB) переданных ему http-запросе. http-ответ (text/plain) обработчика должен
//иметь следующий формат: POST-Http-XYZ:ParmA = aaa,ParmB = bbb, где  aaa, bbbb значения параметров. 

app.MapPost("/LPV", async (HttpContext context) => {
    var form = await context.Request.ReadFormAsync();
    var parmA = form["ParmA"];
    var parmB = form["ParmB"];

    context.Response.ContentType = "text/plain";
    await context.Response.WriteAsync($"POST-Http-LPV:ParmA = {parmA}, ParmB = {parmB}");
});


//3.Разработайте http-обработчик. Http-обработчик должен быть привязан к расширению XYZ(инициалам студента) и http-методу PUT.
//Обработчик должен принимать два параметра(ParmA И ParmB) переданных ему в http-запросе. hhtp-ответ (text/plain)  обработчика должен
//иметь следующий формат: PUT-Http-XYZ:ParmA = aaa,ParmB = bbb,где  aaa, bbbb значения параметров.
app.MapPut("/LPV", async (HttpContext context) => {
    var form = await context.Request.ReadFormAsync();
    var parmA = form["ParmA"];
    var parmB = form["ParmB"];

    context.Response.ContentType = "text/plain";

    await context.Response.WriteAsync($"PUT-Http-LPV:ParmA = {parmA}, ParmB = {parmB}");
});


//4. Разработайте http-обработчик, который возвращает сумму двух чисел, переданных ему в качестве параметров X и Y POST-запросом.
//Разработайте windows-клиент, реализующий форму для сложения двух чисел (три поля и кнопка) с помощью  запроса к обработчику
app.MapPost("/SUM", async (HttpContext context) => {
    var form = await context.Request.ReadFormAsync();
    int x = int.Parse(form["X"]);
    int y = int.Parse(form["Y"]);
    int sum = x + y;
    context.Response.ContentType = "text/plain";
    await context.Response.WriteAsync(sum.ToString());
});


//5.Разработайте http-обработчик, который  обрабатывает GET и POST-запросы. На GET-запрос обработчик возвращает html-страницу.
//На POST-запрос обработчик принимает два числовых параметра x и y, в ответе отправляет произведение x*y.
//html-страница с помощью XMLHTTPRequest делает POST-запрос к обработчику, передает числовые значения x и y и отображает результат,
//полученный от обработчика.  
app.MapGet("/multiply", async (HttpContext context) =>
{
    context.Response.ContentType = "text/html";
    await context.Response.WriteAsync(@"
        <html>
        <head>
            <meta charset='UTF-8'>
            <title>Произведение чисел</title>
            <script>
                function calculateProduct() {
                    var x = document.getElementById('x').value;
                    var y = document.getElementById('y').value;
                    var xhr = new XMLHttpRequest();
                    xhr.open('POST', '/multiply', true);
                    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState == 4 && xhr.status == 200) {
                            document.getElementById('result').innerText = 'Результат: ' + xhr.responseText;
                        }
                    };
                    xhr.send('x=' + x + '&y=' + y);
                }
            </script>
        </head>
        <body>
            <h1>Вычисление произведения двух чисел</h1>
            <label for='x'>Введите X:</label>
            <input type='number' id='x' /><br><br>
            <label for='y'>Введите Y:</label>
            <input type='number' id='y' /><br><br>
            <button onclick='calculateProduct()'>Вычислить произведение</button>
            <p id='result'></p>
        </body>
        </html>
    ");
});

app.MapPost("/multiply", async (HttpContext context) =>
{
    var form = await context.Request.ReadFormAsync();
    int x = int.Parse(form["x"]);
    int y = int.Parse(form["y"]);
    int product = x * y;
    context.Response.ContentType = "text/plain";
    await context.Response.WriteAsync(product.ToString());
});


//Разработайте http-обработчик, который  обрабатывает GET и POST-запросы. На GET-запрос обработчик возвращает html-страницу.
//На POST-запрос обработчик принимает два числовых параметра x и y, в ответе отправляет произведение x*y. html-страница с помощью
//тега <form> делает POST-запрос к обработчику, передает числовые значения x и y и отображает результат, полученный от обработчика.
app.MapGet("/multiply2", async (HttpContext context) =>
{
    context.Response.ContentType = "text/html";
    await context.Response.WriteAsync(@"
        <html>
        <head>
            <meta charset='UTF-8'>
            <title>Произведение чисел</title>
        </head>
        <body>
            <h1>Вычисление произведения двух чисел</h1>
            <form method='post' action='/multiply'>
                <label for='x'>Введите X:</label>
                <input type='number' id='x' name='x' /><br><br>
                <label for='y'>Введите Y:</label>
                <input type='number' id='y' name='y' /><br><br>
                <button type='submit'>Вычислить произведение</button>
            </form>
            <p id='result'></p>
        </body>
        </html>
    ");
});

app.MapPost("/multiply2", async (HttpContext context) =>
{
    var form = await context.Request.ReadFormAsync();
    int x = int.Parse(form["x"]);
    int y = int.Parse(form["y"]);
    int product = x * y;

    context.Response.ContentType = "text/plain";
    await context.Response.WriteAsync(product.ToString());
});


app.Run();
