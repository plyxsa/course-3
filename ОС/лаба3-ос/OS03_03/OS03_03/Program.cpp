#include <Windows.h>
#include <tlhelp32.h>  // ������� ������ ���������
#include <iostream>

void ListProcesses()
{
    // ������ ���� ��������� � �������
    HANDLE hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hProcessSnap == INVALID_HANDLE_VALUE)
    {
        std::cerr << "������ �������� ������ ���������." << std::endl;
        return;
    }

    PROCESSENTRY32 pe32;
    pe32.dwSize = sizeof(PROCESSENTRY32);

    // ������ ������� 
    if (!Process32First(hProcessSnap, &pe32))
    {
        std::cerr << "������ ��� ��������� ������� ��������." << std::endl;
        CloseHandle(hProcessSnap);
        return;
    }

    // ��� �������� � ������
    do
    {
        std::wcout << L"�������: " << pe32.szExeFile << L" (PID: " << pe32.th32ProcessID << L")" << std::endl;
    } while (Process32Next(hProcessSnap, &pe32));  // ������� � ���������� ��������

    CloseHandle(hProcessSnap);  // ��������� ������
}

int main()
{
    setlocale(LC_ALL, "rus");

    std::cout << "�������� ���������, ������������� � ������ ������:" << std::endl;
    ListProcesses();

    return 0;
}
