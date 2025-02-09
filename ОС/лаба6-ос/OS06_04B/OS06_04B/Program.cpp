#include <iostream>
#include <Windows.h>

int main() {
    setlocale(LC_ALL, "RUS");
    HANDLE semaphore = OpenSemaphore(SEMAPHORE_ALL_ACCESS, FALSE, L"OS06_04");

    for (int i = 1; i <= 90; ++i) {
        if (i == 30) {
            WaitForSingleObject(semaphore, INFINITE);  // Ожидание семафора
        }
        if (i == 60) {
            ReleaseSemaphore(semaphore, 1, NULL);  // Освобождение семафора
        }

        printf("[OS06_04B] Итерация: %d\n", i);  // Удален вывод PID
        Sleep(100);
    }

    if (semaphore) {
        CloseHandle(semaphore);
    }

    return 0;
}
