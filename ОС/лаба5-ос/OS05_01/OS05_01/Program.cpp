#include <iostream>
#include <Windows.h>
#include <bitset>


using namespace std;

void printBinaryMask(DWORD_PTR mask) {
    for (int i = sizeof(mask) * 8 - 1; i >= 0; i--) {
        cout << ((mask >> i) & 1);
    }
    cout << endl;
}

int main() {
    setlocale(LC_ALL, "rus");

    // Дескриптор текущего процесса и потока
    HANDLE hProcess = GetCurrentProcess();
    HANDLE hThread = GetCurrentThread();

    // Идентификаторы процесса и потока
    DWORD processId = GetCurrentProcessId();
    DWORD threadId = GetCurrentThreadId();

    // Приоритетный класс процесса
    DWORD processPriorityClass = GetPriorityClass(hProcess);
    int threadPriority = GetThreadPriority(hThread);

    // Маска доступных процессоров и количество процессоров
    DWORD_PTR processAffinityMask, systemAffinityMask;
    GetProcessAffinityMask(hProcess, &processAffinityMask, &systemAffinityMask);
    DWORD numberOfProcessors = bitset<sizeof(DWORD_PTR) * 8>(processAffinityMask).count();

    // Процессор, назначенный текущему потоку
    DWORD_PTR threadIdealProcessor = SetThreadIdealProcessor(hThread, MAXIMUM_PROCESSORS);

    // Вывод информации
    cout << "Идентификатор текущего процесса: " << processId << endl;
    cout << "Идентификатор текущего потока: " << threadId << endl;

    cout << "Приоритетный класс текущего процесса: ";
    switch (processPriorityClass) {
    case IDLE_PRIORITY_CLASS: cout << "IDLE_PRIORITY_CLASS"; break;
    case BELOW_NORMAL_PRIORITY_CLASS: cout << "BELOW_NORMAL_PRIORITY_CLASS"; break;
    case NORMAL_PRIORITY_CLASS: cout << "NORMAL_PRIORITY_CLASS"; break;
    case ABOVE_NORMAL_PRIORITY_CLASS: cout << "ABOVE_NORMAL_PRIORITY_CLASS"; break;
    case HIGH_PRIORITY_CLASS: cout << "HIGH_PRIORITY_CLASS"; break;
    case REALTIME_PRIORITY_CLASS: cout << "REALTIME_PRIORITY_CLASS"; break;
    default: cout << "UNKNOWN"; break;
    }
    cout << endl;

    cout << "Приоритет текущего потока: " << threadPriority << endl;

    cout << "Маска доступных процессу процессоров (affinity mask): ";
    printBinaryMask(processAffinityMask);

    cout << "Количество доступных процессоров: " << numberOfProcessors << endl;
    cout << "Процессор, назначенный текущему потоку: " << threadIdealProcessor << endl;

    return 0;
}
