using System.Diagnostics;

public class Program
{
    public static void MySleep(int milliseconds)
    {
        var startTime = DateTime.Now;

        while (DateTime.Now - startTime < TimeSpan.FromMilliseconds(milliseconds))
        {
            int result = 1;
            for (int i = 0; i < 10000; i++)
            {
                result *= 2;
            }
        }
    }

    public static void Main(string[] args)
    {
        Stopwatch time = Stopwatch.StartNew();
        Console.WriteLine("Начало");
        MySleep(10000);
        time.Stop();
        Console.WriteLine("Конец. Время работы: {0} секунд", time.Elapsed.TotalSeconds);
    }
}


