public class Program
{
    const int ThreadCount = 10;       // Количество потоков
    const int ThreadLifeTime = 10;    // Время работы каждого потока в секундах
    const int ObservationTime = 30;   // Время наблюдения в секундах

    static int[,] Matrix = new int[ThreadCount, ObservationTime];
    static DateTime StartTime = DateTime.Now;

    static void WorkThread(object o)
    {
        int id = (int)o;

        for (int i = 0; i < ThreadLifeTime * 20; i++)
        {
            DateTime CurrentTime = DateTime.Now;
            int ElapsedSeconds = (int)Math.Round(CurrentTime.Subtract(StartTime).TotalSeconds);

            if (ElapsedSeconds < ObservationTime)
            {
                Matrix[id, ElapsedSeconds] += 50;
            }

            MySleep(50);
        }
    }

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

    static void Main(string[] args)
    {
        Thread[] threads = new Thread[ThreadCount];

        for (int i = 0; i < ThreadCount; ++i)
        {
            object o = i;
            threads[i] = new Thread(WorkThread);

            // Устанавливаем приоритет в зависимости от индекса потока
            if (i < 2) // Первые два потока с приоритетом BelowNormal
            {
                threads[i].Priority = ThreadPriority.BelowNormal;
            }
            else // Остальные потоки с приоритетом Normal
            {
                threads[i].Priority = ThreadPriority.Normal;
            }

            threads[i].Start(o);
        }

        Console.WriteLine("Лопатнюк Полинка ожидает завершения всех потоков...");

        for (int i = 0; i < ThreadCount; ++i)
        {
            threads[i].Join();
        }

        for (int s = 0; s < ObservationTime; s++)
        {
            Console.Write("{0,3}: ", s);
            for (int th = 0; th < ThreadCount; th++)
            {
                Console.Write(" {0,5}", Matrix[th, s]);
            }
            Console.WriteLine();
        }
    }
}

