#include <Windows.h>
#include <iostream>

int main()
{
    setlocale(LC_ALL, "rus");
    DWORD processId = GetCurrentProcessId();
    std::cout << "ID ��������: " << processId << std::endl;

    // �������� ���� �������� ���������
    STARTUPINFO si1, si2;
    PROCESS_INFORMATION pi1, pi2;

    ZeroMemory(&si1, sizeof(si1));
    si1.cb = sizeof(si1);
    ZeroMemory(&pi1, sizeof(pi1));

    ZeroMemory(&si2, sizeof(si2));
    si2.cb = sizeof(si2);
    ZeroMemory(&pi2, sizeof(pi2));

    // ������ ������� ��������� ��������
    if (!CreateProcess(L"C:/Users/plyushka/source/repos/OS03_02_1/x64/Debug/OS03_02_1.exe", 
        NULL,   // ��������� ������ ��� ������ �������� 
        NULL,   // ��������� �� �������� ������������ ��� �������� 
        NULL,   // ��������� �� �������� ������������ ��� ������ 
        FALSE,  // ���� ������������ ������������. FALSE = ����������� �� ����������� �������� ���������
        0,      // ����� �������� ��������
        NULL,   // ��������� �� ���� ����� ��� ������ �������� 
        NULL,   // ��������� �� ������� ���������� ��� ������ �������� 
        &si1,   // ��������� �� ��������� STARTUPINFO ��� ������������ ���� ������ ��������
        &pi1))  // ��������� �� ��������� PROCESS_INFORMATION ��� ��������� ���������� � ����� ��������
    {
        std::cout << "�� ������� ������� ������� OS03_02_1." << std::endl;
        return 1;
    }
    std::cout << "������� ������� OS03_02_1. ID: " << pi1.dwProcessId << std::endl;

    // ������ ������� ��������� �������� 
    if (!CreateProcess(L"C:/Users/plyushka/source/repos/OS03_02_2/x64/Debug/OS03_02_2.exe", 
        NULL, NULL, NULL, FALSE, 0, NULL, NULL, &si2, &pi2))
    {
        std::cout << "�� ������� ������� ������� OS03_02_2." << std::endl;
        return 1;
    }

    std::cout << "������� ������� OS03_02_2. ID: " << pi2.dwProcessId << std::endl;

    for (int i = 0; i < 100; i++)
    {
        Sleep(1000);
        std::cout << "�������� �������. ��������: " << i << std::endl;
    }

    // �������� ���������� �������� ���������
    WaitForSingleObject(pi1.hProcess, INFINITE);
    WaitForSingleObject(pi2.hProcess, INFINITE);

    // �������� ������������
    CloseHandle(pi1.hProcess);
    CloseHandle(pi1.hThread);
    CloseHandle(pi2.hProcess);
    CloseHandle(pi2.hThread);

    return 0;
}
