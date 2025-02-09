#include <iostream>
#include <windows.h>

using namespace std;

CRITICAL_SECTION critical_section;

DWORD WINAPI loop(LPVOID param) {
    char* thread_name = static_cast<char*>(param);

    for (int i = 1; i <= 90; ++i) {
        // ������������� � ��������� �������� [30; 60]
        if (i == 30) EnterCriticalSection(&critical_section);
        printf("[%s]\t��������: %d\n", thread_name, i);
        if (i == 60) LeaveCriticalSection(&critical_section);
        Sleep(100);
    }

    printf("[%s]\t�������� ����������\n", thread_name);
    return 0;
}

int main() {
    setlocale(LC_ALL, "rus");
    const int num_threads = 2;
    HANDLE threads[num_threads];

    // ������������� ����������� ������
    InitializeCriticalSection(&critical_section);

    threads[0] = CreateThread(NULL, 0, loop, (LPVOID)"A", 0, NULL);
    if (threads[0] == NULL) {
        cerr << "������ ��� �������� ������ A\n";
        return 1;
    }

    threads[1] = CreateThread(NULL, 0, loop, (LPVOID)"B", 0, NULL);
    if (threads[1] == NULL) {
        cerr << "������ ��� �������� ������ B\n";
        return 1;
    }

    // �������� ����� ��������� ���� ��������
    for (int i = 1; i <= 90; ++i) {
        if (i == 30) EnterCriticalSection(&critical_section);

        printf("[MAIN]\t��������: %d\n", i);

        if (i == 60) LeaveCriticalSection(&critical_section);

        // �������� ����� ����������
        Sleep(100);
    }

    printf("[MAIN]\t�������� ����������\n");

    WaitForMultipleObjects(num_threads, threads, TRUE, INFINITE);

    for (int i = 0; i < num_threads; ++i) {
        CloseHandle(threads[i]);
    }

    DeleteCriticalSection(&critical_section);

    return 0;
}
