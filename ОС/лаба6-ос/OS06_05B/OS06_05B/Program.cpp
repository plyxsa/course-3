#include <iostream>
#include <Windows.h>

int main() {
    setlocale(LC_ALL, "RUS");
    // �������� ������� ��� �������������
    HANDLE event = OpenEvent(EVENT_ALL_ACCESS, FALSE, L"OS06_05_Event");

    // �������� ������� �� ��������� ��������
    WaitForSingleObject(event, INFINITE);

    // ������� B ��������� �������� � 1 �� 90
    for (int i = 1; i <= 90; ++i) {
        printf("[OS06_05B] ��������: %d\n", i);
        Sleep(100);
    }

    // �������� ����������� �������
    CloseHandle(event);

    return 0;
}
