#include <iostream>
#include <Windows.h>
#include <bitset>


using namespace std;

void printBinaryMask(DWORD_PTR mask) {
    for (int i = sizeof(mask) * 8 - 1; i >= 0; i--) {
        cout << ((mask >> i) & 1);
    }
    cout << endl;
}

int main() {
    setlocale(LC_ALL, "rus");

    // ���������� �������� �������� � ������
    HANDLE hProcess = GetCurrentProcess();
    HANDLE hThread = GetCurrentThread();

    // �������������� �������� � ������
    DWORD processId = GetCurrentProcessId();
    DWORD threadId = GetCurrentThreadId();

    // ������������ ����� ��������
    DWORD processPriorityClass = GetPriorityClass(hProcess);
    int threadPriority = GetThreadPriority(hThread);

    // ����� ��������� ����������� � ���������� �����������
    DWORD_PTR processAffinityMask, systemAffinityMask;
    GetProcessAffinityMask(hProcess, &processAffinityMask, &systemAffinityMask);
    DWORD numberOfProcessors = bitset<sizeof(DWORD_PTR) * 8>(processAffinityMask).count();

    // ���������, ����������� �������� ������
    DWORD_PTR threadIdealProcessor = SetThreadIdealProcessor(hThread, MAXIMUM_PROCESSORS);

    // ����� ����������
    cout << "������������� �������� ��������: " << processId << endl;
    cout << "������������� �������� ������: " << threadId << endl;

    cout << "������������ ����� �������� ��������: ";
    switch (processPriorityClass) {
    case IDLE_PRIORITY_CLASS: cout << "IDLE_PRIORITY_CLASS"; break;
    case BELOW_NORMAL_PRIORITY_CLASS: cout << "BELOW_NORMAL_PRIORITY_CLASS"; break;
    case NORMAL_PRIORITY_CLASS: cout << "NORMAL_PRIORITY_CLASS"; break;
    case ABOVE_NORMAL_PRIORITY_CLASS: cout << "ABOVE_NORMAL_PRIORITY_CLASS"; break;
    case HIGH_PRIORITY_CLASS: cout << "HIGH_PRIORITY_CLASS"; break;
    case REALTIME_PRIORITY_CLASS: cout << "REALTIME_PRIORITY_CLASS"; break;
    default: cout << "UNKNOWN"; break;
    }
    cout << endl;

    cout << "��������� �������� ������: " << threadPriority << endl;

    cout << "����� ��������� �������� ����������� (affinity mask): ";
    printBinaryMask(processAffinityMask);

    cout << "���������� ��������� �����������: " << numberOfProcessors << endl;
    cout << "���������, ����������� �������� ������: " << threadIdealProcessor << endl;

    return 0;
}
