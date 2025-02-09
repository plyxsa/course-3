#include <iostream>
#include <thread>
#include <atomic>
#include <chrono>

// Флаг синхронизации
std::atomic<int> sync_flag(0);

void printMessage(const char* message) {
    printf("%s\n", message);
}

// Первый поток
void Thread1() {
    while (true) {
        bool bitSet;
        __asm {
            mov eax, sync_flag // Загрузить sync_flag
            bts eax, 0         // Установить бит 0
            setc al            // Установить AL, если бит уже был установлен
            mov bitSet, al     // Сохранить результат
        }
        if (!bitSet) break;    // Если бит не был установлен, выходим из цикла
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }

    std::this_thread::sleep_for(std::chrono::milliseconds(5000)); // Работа потока

    __asm {
        mov eax, sync_flag // Загрузить sync_flag
        btr eax, 0         // Очистить бит 0
        mov sync_flag, eax // Сохранить результат
    }

    printMessage("Thread 1 finished");
}

// Второй поток
void Thread2() {
    std::this_thread::sleep_for(std::chrono::milliseconds(1000)); // Работа потока

    while (true) {
        bool bitSet;
        __asm {
            mov eax, sync_flag             
            bts eax, 0
            setc al
            mov bitSet, al
        }
        if (!bitSet) break;
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }

    std::this_thread::sleep_for(std::chrono::milliseconds(1000)); // Работа потока

    __asm {
        mov eax, sync_flag // Загрузить sync_flag
        btr eax, 0         // Очистить бит 0
        mov sync_flag, eax // Сохранить результат
    }

    printMessage("Thread 2 finished");
}

int main() {
    std::thread t1(Thread1);
    std::thread t2(Thread2);

    t1.join();
    t2.join();

    return 0;
}
