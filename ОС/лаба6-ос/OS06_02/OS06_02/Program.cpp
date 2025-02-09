#include <iostream>
#include <thread>
#include <atomic>
#include <chrono>

// ���� �������������
std::atomic<int> sync_flag(0);

void printMessage(const char* message) {
    printf("%s\n", message);
}

// ������ �����
void Thread1() {
    while (true) {
        bool bitSet;
        __asm {
            mov eax, sync_flag // ��������� sync_flag
            bts eax, 0         // ���������� ��� 0
            setc al            // ���������� AL, ���� ��� ��� ��� ����������
            mov bitSet, al     // ��������� ���������
        }
        if (!bitSet) break;    // ���� ��� �� ��� ����������, ������� �� �����
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }

    std::this_thread::sleep_for(std::chrono::milliseconds(5000)); // ������ ������

    __asm {
        mov eax, sync_flag // ��������� sync_flag
        btr eax, 0         // �������� ��� 0
        mov sync_flag, eax // ��������� ���������
    }

    printMessage("Thread 1 finished");
}

// ������ �����
void Thread2() {
    std::this_thread::sleep_for(std::chrono::milliseconds(1000)); // ������ ������

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

    std::this_thread::sleep_for(std::chrono::milliseconds(1000)); // ������ ������

    __asm {
        mov eax, sync_flag // ��������� sync_flag
        btr eax, 0         // �������� ��� 0
        mov sync_flag, eax // ��������� ���������
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
