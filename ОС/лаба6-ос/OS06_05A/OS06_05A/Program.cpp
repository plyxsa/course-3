#include <iostream>
#include <Windows.h>

int main() {
    setlocale(LC_ALL, "RUS");
    // �������� ������� ��� �������������
    HANDLE event = OpenEvent(EVENT_ALL_ACCESS, FALSE, L"OS06_05_Event");

    // �������� ������� �� ��������� ��������
    WaitForSingleObject(event, INFINITE);

    for (int i = 1; i <= 90; ++i) {
        printf("[OS06_05A] ��������: %d\n", i);
        Sleep(100);
    }

    CloseHandle(event);

    return 0;
}
