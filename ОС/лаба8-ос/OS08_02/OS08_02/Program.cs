using System.Diagnostics;

namespace OS08_02
{
    class Program
    {
        static void Main(string[] args)
        {
            List<Big> lbig = new List<Big>();

            int processId = Process.GetCurrentProcess().Id;

            Console.WriteLine($"ID процесса: {processId}");
            Console.WriteLine("OS08_02: Использование памяти, Platform Target: x86");

            Thread memoryFillerThread = new Thread(FillMemory);
            memoryFillerThread.Start();

            while (true)
            {
                lbig.Add(new Big());

                long usedMemory = GC.GetTotalMemory(true);
                Console.WriteLine($"Используемая память: {usedMemory / (1024 * 1024)} MB");

                Thread.Sleep(5000);
            }
        }

        static void FillMemory()
        {
            Random rand = new Random();
            while (true)
            {
                for (int i = 0; i < 128 * 1024 * 1024 / sizeof(int); i++)
                {
                    int value = rand.Next();
                }
                Thread.Sleep(1000);
            }
        }
    }

    class Big
    {
        public byte[] ByteArray;
        public Big()
        {
            ByteArray = new byte[128 * 1024 * 1024];
        }
    }
}
