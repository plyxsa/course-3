public class Program
{
    const int TaskCount = 8;          // Уменьшено количество задач до 8
    const int TaskLifeTime = 10;      // Время жизни каждой задачи в секундах
    const int ObservationTime = 30;   // Время наблюдения в секундах

    static int[,] Matrix = new int[TaskCount, ObservationTime];  // Матрица для хранения данных о работе задач
    static DateTime StartTime = DateTime.Now;

    static async Task Work(int id)
    {
        for (int i = 0; i < TaskLifeTime * 20; i++)
        {
            DateTime CurrentTime = DateTime.Now;
            int ElapsedSeconds = (int)Math.Round(CurrentTime.Subtract(StartTime).TotalSeconds);

            if (ElapsedSeconds < ObservationTime)
            {
                Matrix[id, ElapsedSeconds] += 50;
            }

            await MySleep(50);
        }
    }

    public static Task MySleep(int milliseconds)
    {
        return Task.Run(() =>
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
        });
    }

    static async Task Main(string[] args)
    {
        Console.WriteLine("Лопатнюк Полина создаёт задачи...");

        for (int i = 0; i < TaskCount; i++)
        {
            int taskId = i;
            await Work(taskId);
        }

        Console.WriteLine("Лопатнюк Полина ожидает завершения задач...");

        for (int s = 0; s < ObservationTime; s++)
        {
            Console.Write("{0,3}: ", s);
            for (int th = 0; th < TaskCount; th++)
            {
                Console.Write(" {0,5}", Matrix[th, s]);
            }
            Console.WriteLine();
        }
    }
}

