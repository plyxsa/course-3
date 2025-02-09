#include <iostream>
#include <windows.h>

using namespace std;

CRITICAL_SECTION criticalSection;

DWORD WINAPI OS04_02_T1(LPVOID) {
    DWORD processId = GetCurrentProcessId();
    DWORD threadId = GetCurrentThreadId();

    for (int i = 0; i < 50; ++i) {
        EnterCriticalSection(&criticalSection);
        cout << "Поток 1: ID процесса: " << processId << ", ID потока: " << threadId
            << ", Итерация: " << i + 1 << endl;
        LeaveCriticalSection(&criticalSection);
        Sleep(1000);
    }
    return 0;
}

DWORD WINAPI OS04_02_T2(LPVOID) {
    DWORD processId = GetCurrentProcessId();
    DWORD threadId = GetCurrentThreadId();

    for (int i = 0; i < 125; ++i) {
        EnterCriticalSection(&criticalSection);
        cout << "Поток 2: ID процесса: " << processId << ", ID потока: " << threadId
            << ", Итерация: " << i + 1 << endl;
        LeaveCriticalSection(&criticalSection);
        Sleep(1000);
    }
    return 0;
}

int main() {
    setlocale(LC_ALL, "rus");

    DWORD processId = GetCurrentProcessId();

    InitializeCriticalSection(&criticalSection);

    HANDLE hThread1 = CreateThread(NULL, 0, OS04_02_T1, NULL, 0, NULL);
    HANDLE hThread2 = CreateThread(NULL, 0, OS04_02_T2, NULL, 0, NULL);

    for (int i = 0; i < 100; ++i) {
        EnterCriticalSection(&criticalSection);
        cout << "ID процесса: " << processId << ", Итерация основного потока: " << i + 1 << endl;
        LeaveCriticalSection(&criticalSection);
        Sleep(1000);
    }

    if (hThread1 == NULL || hThread2 == NULL) {
        cerr << "Ошибка при создании потоков." << endl;
        return 1;
    }

    WaitForSingleObject(hThread1, INFINITE);
    WaitForSingleObject(hThread2, INFINITE);

    CloseHandle(hThread1);
    CloseHandle(hThread2);
    DeleteCriticalSection(&criticalSection);

    return 0;
}
