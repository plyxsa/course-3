var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// 1. Http-���������� ������ ���� �������� � ���������� XYZ(��������� ��������) � http-������ GET.
// ���������� ������ ��������� ��� ��������� (ParmA � ParmB) ���������� ��� � http-�������.
// http-����� (text/plain) ����������� ������ ����� ��������� ������:  GET-Http-XYZ:ParmA = aaa,ParmB = bbb,
// ���  aaa, bbbb �������� ����������. 

app.MapGet("/LPV", async (HttpContext context) => {
    context.Response.ContentType = "text/plain";
    await context.Response.WriteAsync($"GET-Http-LPV:ParmA = {context.Request.Query["ParmA"]}," +
                                      $"ParmB = {context.Request.Query["ParmB"]}");
});

///LPV?ParmA=aaa&ParmB=bbb

//2. Http-���������� ������ ���� �������� � ���������� XYZ(��������� ��������) � http-������ POST.
//���������� ������ ��������� ��� ���������(ParmA � ParmB) ���������� ��� http-�������. http-����� (text/plain) ����������� ������
//����� ��������� ������: POST-Http-XYZ:ParmA = aaa,ParmB = bbb, ���  aaa, bbbb �������� ����������. 

app.MapPost("/LPV", async (HttpContext context) => {
    var form = await context.Request.ReadFormAsync();
    var parmA = form["ParmA"];
    var parmB = form["ParmB"];

    context.Response.ContentType = "text/plain";
    await context.Response.WriteAsync($"POST-Http-LPV:ParmA = {parmA}, ParmB = {parmB}");
});


//3.������������ http-����������. Http-���������� ������ ���� �������� � ���������� XYZ(��������� ��������) � http-������ PUT.
//���������� ������ ��������� ��� ���������(ParmA � ParmB) ���������� ��� � http-�������. hhtp-����� (text/plain)  ����������� ������
//����� ��������� ������: PUT-Http-XYZ:ParmA = aaa,ParmB = bbb,���  aaa, bbbb �������� ����������.
app.MapPut("/LPV", async (HttpContext context) => {
    var form = await context.Request.ReadFormAsync();
    var parmA = form["ParmA"];
    var parmB = form["ParmB"];

    context.Response.ContentType = "text/plain";

    await context.Response.WriteAsync($"PUT-Http-LPV:ParmA = {parmA}, ParmB = {parmB}");
});


//4. ������������ http-����������, ������� ���������� ����� ���� �����, ���������� ��� � �������� ���������� X � Y POST-��������.
//������������ windows-������, ����������� ����� ��� �������� ���� ����� (��� ���� � ������) � �������  ������� � �����������
app.MapPost("/SUM", async (HttpContext context) => {
    var form = await context.Request.ReadFormAsync();
    int x = int.Parse(form["X"]);
    int y = int.Parse(form["Y"]);
    int sum = x + y;
    context.Response.ContentType = "text/plain";
    await context.Response.WriteAsync(sum.ToString());
});


//5.������������ http-����������, �������  ������������ GET � POST-�������. �� GET-������ ���������� ���������� html-��������.
//�� POST-������ ���������� ��������� ��� �������� ��������� x � y, � ������ ���������� ������������ x*y.
//html-�������� � ������� XMLHTTPRequest ������ POST-������ � �����������, �������� �������� �������� x � y � ���������� ���������,
//���������� �� �����������.  
app.MapGet("/multiply", async (HttpContext context) =>
{
    context.Response.ContentType = "text/html";
    await context.Response.WriteAsync(@"
        <html>
        <head>
            <meta charset='UTF-8'>
            <title>������������ �����</title>
            <script>
                function calculateProduct() {
                    var x = document.getElementById('x').value;
                    var y = document.getElementById('y').value;
                    var xhr = new XMLHttpRequest();
                    xhr.open('POST', '/multiply', true);
                    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState == 4 && xhr.status == 200) {
                            document.getElementById('result').innerText = '���������: ' + xhr.responseText;
                        }
                    };
                    xhr.send('x=' + x + '&y=' + y);
                }
            </script>
        </head>
        <body>
            <h1>���������� ������������ ���� �����</h1>
            <label for='x'>������� X:</label>
            <input type='number' id='x' /><br><br>
            <label for='y'>������� Y:</label>
            <input type='number' id='y' /><br><br>
            <button onclick='calculateProduct()'>��������� ������������</button>
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


//������������ http-����������, �������  ������������ GET � POST-�������. �� GET-������ ���������� ���������� html-��������.
//�� POST-������ ���������� ��������� ��� �������� ��������� x � y, � ������ ���������� ������������ x*y. html-�������� � �������
//���� <form> ������ POST-������ � �����������, �������� �������� �������� x � y � ���������� ���������, ���������� �� �����������.
app.MapGet("/multiply2", async (HttpContext context) =>
{
    context.Response.ContentType = "text/html";
    await context.Response.WriteAsync(@"
        <html>
        <head>
            <meta charset='UTF-8'>
            <title>������������ �����</title>
        </head>
        <body>
            <h1>���������� ������������ ���� �����</h1>
            <form method='post' action='/multiply'>
                <label for='x'>������� X:</label>
                <input type='number' id='x' name='x' /><br><br>
                <label for='y'>������� Y:</label>
                <input type='number' id='y' name='y' /><br><br>
                <button type='submit'>��������� ������������</button>
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
