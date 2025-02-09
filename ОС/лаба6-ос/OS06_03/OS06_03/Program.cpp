#include <iostream>
#include <Windows.h>

using namespace std;

int main() {
    setlocale(LC_ALL, "rus");
    HANDLE mutex = CreateMutex(NULL, FALSE, L"OS06_03");
    if (mutex == NULL) {
        cerr << "Ошибка при создании мьютекса\n";
        return 1;
    }

    STARTUPINFO si = { sizeof(si) };
    PROCESS_INFORMATION piA, piB;

    if (!CreateProcess(L"C:\\Users\\plyushka\\source\\repos\\OS06_03A\\x64\\Debug\\OS06_03A.exe", NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si, &piA)) {
        cerr << "Ошибка при создании процесса A\n";
        return 1;
    }

    if (!CreateProcess(L"C:\\Users\\plyushka\\source\\repos\\OS06_03B\\x64\\Debug\\OS06_03B.exe", NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si, &piB)) {
        cerr << "Ошибка при создании процесса B\n";
        return 1;
    }

    for (int i = 1; i <= 90; ++i) {
        if (i == 30) WaitForSingleObject(mutex, INFINITE);
        else if (i == 60) ReleaseMutex(mutex);

        printf("[OS06_03] Итерация: %d\n", i);
        Sleep(100);
    }

    WaitForSingleObject(piA.hProcess, INFINITE);
    WaitForSingleObject(piB.hProcess, INFINITE);

    CloseHandle(piA.hProcess);
    CloseHandle(piB.hProcess);
    CloseHandle(mutex);

    return 0;
}

