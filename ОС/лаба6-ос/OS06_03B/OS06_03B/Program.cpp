#include <iostream>
#include <Windows.h>

using namespace std;

int main() {
    setlocale(LC_ALL, "rus");
    HANDLE mutex = OpenMutex(SYNCHRONIZE, FALSE, L"OS06_03");
    if (mutex == NULL) {
        cerr << "Ошибка при открытии мьютекса\n";
        return 1;
    }

    for (int i = 1; i <= 90; ++i) {
        if (i == 30) WaitForSingleObject(mutex, INFINITE);
        else if (i == 60) ReleaseMutex(mutex);

        printf("[OS06_03B] Итерация: %d\n", i);
        Sleep(100);
    }

    CloseHandle(mutex);
    return 0;
}
