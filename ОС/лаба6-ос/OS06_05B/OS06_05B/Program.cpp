#include <iostream>
#include <Windows.h>

int main() {
    setlocale(LC_ALL, "RUS");
    // Открытие события для синхронизации
    HANDLE event = OpenEvent(EVENT_ALL_ACCESS, FALSE, L"OS06_05_Event");

    // Ожидание сигнала от основного процесса
    WaitForSingleObject(event, INFINITE);

    // Процесс B выполняет итерации с 1 по 90
    for (int i = 1; i <= 90; ++i) {
        printf("[OS06_05B] Итерация: %d\n", i);
        Sleep(100);
    }

    // Закрытие дескриптора события
    CloseHandle(event);

    return 0;
}
