#include <iostream>
#include <Windows.h>

using namespace std;

int main() {
    setlocale(LC_ALL, "RUS");
    const int size = 2;
    HANDLE event;  // Событие для синхронизации
    HANDLE processes[size] = { NULL, NULL };

    STARTUPINFO startupInfoA, startupInfoB;
    PROCESS_INFORMATION processInfoA, processInfoB;
    ZeroMemory(&startupInfoA, sizeof(STARTUPINFO));
    startupInfoA.cb = sizeof(STARTUPINFO);
    ZeroMemory(&startupInfoB, sizeof(STARTUPINFO));
    startupInfoB.cb = sizeof(STARTUPINFO);

    // Создание события
    event = CreateEvent(NULL, TRUE, FALSE, L"OS06_05_Event");

    if (CreateProcessW(L"C:\\Users\\plyushka\\source\\repos\\OS06_05A\\x64\\Debug\\OS06_05A.exe", NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &startupInfoA, &processInfoA)) {
        cout << "Процесс A создан\n";
        processes[0] = processInfoA.hProcess;
    }
    else {
        cout << "Не удалось создать процесс A\n";
    }

    if (CreateProcessW(L"C:\\Users\\plyushka\\source\\repos\\OS06_05B\\x64\\Debug\\OS06_05B.exe", NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &startupInfoB, &processInfoB)) {
        cout << "Процесс B создан\n";
        processes[1] = processInfoB.hProcess;
    }
    else {
        cout << "Не удалось создать процесс B\n";
    }

    for (int i = 1; i <= 15; ++i) {
        printf("[OS06_05] Итерация: %d\n", i);
        Sleep(100);
    }

    // Сигнализация дочерним процессам о продолжении работы
    SetEvent(event);

    // Основной процесс продолжает выполнение итераций
    for (int i = 16; i <= 90; ++i) {
        printf("[OS06_05] Итерация: %d\n", i);
        Sleep(100);
    }

    WaitForMultipleObjects(size, processes, TRUE, INFINITE);

    CloseHandle(processInfoA.hProcess);
    CloseHandle(processInfoA.hThread);
    CloseHandle(processInfoB.hProcess);
    CloseHandle(processInfoB.hThread);
    CloseHandle(event);

    cout << '\n';
    system("pause");
    return 0;
}
