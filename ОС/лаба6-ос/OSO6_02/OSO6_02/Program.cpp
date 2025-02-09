#include <iostream>
#include <windows.h>

using namespace std;

CRITICAL_SECTION critical_section;

DWORD WINAPI loop(LPVOID param) {
    char* thread_name = static_cast<char*>(param);

    for (int i = 1; i <= 90; ++i) {
        // Синхронизация в диапазоне итераций [30; 60]
        if (i == 30) EnterCriticalSection(&critical_section);
        printf("[%s]\tИтерация: %d\n", thread_name, i);
        if (i == 60) LeaveCriticalSection(&critical_section);
        Sleep(100);
    }

    printf("[%s]\tЗакончил выполнение\n", thread_name);
    return 0;
}

int main() {
    setlocale(LC_ALL, "rus");
    const int num_threads = 2;
    HANDLE threads[num_threads];

    // Инициализация критической секции
    InitializeCriticalSection(&critical_section);

    threads[0] = CreateThread(NULL, 0, loop, (LPVOID)"A", 0, NULL);
    if (threads[0] == NULL) {
        cerr << "Ошибка при создании потока A\n";
        return 1;
    }

    threads[1] = CreateThread(NULL, 0, loop, (LPVOID)"B", 0, NULL);
    if (threads[1] == NULL) {
        cerr << "Ошибка при создании потока B\n";
        return 1;
    }

    // Основной поток выполняет свои итерации
    for (int i = 1; i <= 90; ++i) {
        if (i == 30) EnterCriticalSection(&critical_section);

        printf("[MAIN]\tИтерация: %d\n", i);

        if (i == 60) LeaveCriticalSection(&critical_section);

        // Задержка между итерациями
        Sleep(100);
    }

    printf("[MAIN]\tЗакончил выполнение\n");

    WaitForMultipleObjects(num_threads, threads, TRUE, INFINITE);

    for (int i = 0; i < num_threads; ++i) {
        CloseHandle(threads[i]);
    }

    DeleteCriticalSection(&critical_section);

    return 0;
}
