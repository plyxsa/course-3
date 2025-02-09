#include <iostream>
#include <Windows.h>

using namespace std;

HANDLE FirstProcessTimer, SecondProcessTimer;
HANDLE processes[2] = { NULL, NULL };

int main() {
    setlocale(LC_ALL, "Russian");

    FirstProcessTimer = CreateWaitableTimer(NULL, FALSE, L"three_sec");
    SecondProcessTimer = CreateWaitableTimer(NULL, FALSE, L"fifteen_sec");

    if (!FirstProcessTimer || !SecondProcessTimer) {
        cout << "[ОШИБКА] Не удалось создать таймеры\n";
        return 1;
    }

    PROCESS_INFORMATION processInfos[2];
    LPCWSTR exePath = L"C:\\Users\\plyushka\\source\\repos\\OS07_04_X\\x64\\Debug\\OS07_04_X.exe";
    STARTUPINFO startupInfo = { sizeof(STARTUPINFO) };

    for (int i = 0; i < 2; ++i) {
        if (CreateProcessW(exePath, NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &startupInfo, &processInfos[i])) {
            cout << "Процесс " << i + 1 << " создан\n";
            processes[i] = processInfos[i].hProcess;
        }
        else {
            cout << "[ОШИБКА] Не удалось создать процесс " << i + 1 << endl;
        }
    }

    LARGE_INTEGER firstTimeout, secondTimeout;
    firstTimeout.QuadPart = -600000000LL;
    secondTimeout.QuadPart = -1200000000LL;

    SetWaitableTimer(FirstProcessTimer, &firstTimeout, 0, NULL, NULL, FALSE);
    SetWaitableTimer(SecondProcessTimer, &secondTimeout, 0, NULL, NULL, FALSE);

    DWORD dwWaitResult;
    while (processes[0] || processes[1]) {
        dwWaitResult = WaitForMultipleObjects(2, new HANDLE[2]{ FirstProcessTimer, SecondProcessTimer }, FALSE, INFINITE);

        if (dwWaitResult == WAIT_OBJECT_0) {
            if (processes[0]) {
                cout << "Завершаем процесс 1\n";
                TerminateProcess(processes[0], 0);
                CloseHandle(processes[0]);
                processes[0] = NULL;
            }
        }
        else if (dwWaitResult == WAIT_OBJECT_0 + 1) {
            if (processes[1]) {
                cout << "Завершаем процесс 2\n";
                TerminateProcess(processes[1], 0);
                CloseHandle(processes[1]);
                processes[1] = NULL;
            }
        }
    }

    CloseHandle(FirstProcessTimer);
    CloseHandle(SecondProcessTimer);

    cout << "Все процессы завершены\n";
    system("pause");
    return 0;
}
