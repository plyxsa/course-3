#include <iostream>
#include <Windows.h>

using namespace std;

int main() {
    setlocale(LC_ALL, "RUS");
    const int size = 2;
    HANDLE semaphore;
    HANDLE processes[size] = { NULL, NULL };

    STARTUPINFO startupInfoA, startupInfoB;
    PROCESS_INFORMATION processInfoA, processInfoB;
    ZeroMemory(&startupInfoA, sizeof(STARTUPINFO));
    startupInfoA.cb = sizeof(STARTUPINFO);
    ZeroMemory(&startupInfoB, sizeof(STARTUPINFO));
    startupInfoB.cb = sizeof(STARTUPINFO);

    if (CreateProcessW(L"C:\\Users\\plyushka\\source\\repos\\OS06_04A\\x64\\Debug\\OS06_04A.exe", NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &startupInfoA, &processInfoA)) {
        cout << "Процесс A создан\n";
        processes[0] = processInfoA.hProcess;
    }
    else {
        cout << "Не удалось создать процесс A\n";
    }

    if (CreateProcessW(L"C:\\Users\\plyushka\\source\\repos\\OS06_04B\\x64\\Debug\\OS06_04B.exe", NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &startupInfoB, &processInfoB)) {
        cout << "Процесс B создан\n";
        processes[1] = processInfoB.hProcess;
    }
    else {
        cout << "Не удалось создать процесс B\n";
    }

    semaphore = CreateSemaphore(NULL, 2, 2, L"OS06_04");

    for (int i = 1; i <= 90; ++i) {
        if (i == 30) {
            WaitForSingleObject(semaphore, INFINITE);  // Ожидание семафора
        }
        if (i == 60) {
            ReleaseSemaphore(semaphore, 1, NULL);  // Освобождение семафора
        }

        printf("[OS06_04] Итерация: %d\n", i);
        Sleep(100);
    }

    WaitForMultipleObjects(size, processes, TRUE, INFINITE);

    CloseHandle(processInfoA.hProcess);
    CloseHandle(processInfoA.hThread);
    CloseHandle(processInfoB.hProcess);
    CloseHandle(processInfoB.hThread);

    if (semaphore) {
        CloseHandle(semaphore);
    }

    cout << '\n';
    system("pause");
    return 0;
}
