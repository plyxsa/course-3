#include <Windows.h>
#include <tlhelp32.h>  // функции снимка процессов
#include <iostream>

void ListProcesses()
{
    // снимок всех процессов в системе
    HANDLE hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hProcessSnap == INVALID_HANDLE_VALUE)
    {
        std::cerr << "Ошибка создания снимка процессов." << std::endl;
        return;
    }

    PROCESSENTRY32 pe32;
    pe32.dwSize = sizeof(PROCESSENTRY32);

    // первый процесс 
    if (!Process32First(hProcessSnap, &pe32))
    {
        std::cerr << "Ошибка при получении первого процесса." << std::endl;
        CloseHandle(hProcessSnap);
        return;
    }

    // все процессы в снимке
    do
    {
        std::wcout << L"Процесс: " << pe32.szExeFile << L" (PID: " << pe32.th32ProcessID << L")" << std::endl;
    } while (Process32Next(hProcessSnap, &pe32));  // переход к следующему процессу

    CloseHandle(hProcessSnap);  // закрываем снимок
}

int main()
{
    setlocale(LC_ALL, "rus");

    std::cout << "Перечень процессов, выполняющихся в данный момент:" << std::endl;
    ListProcesses();

    return 0;
}
