#include <Windows.h>
#include <iostream>

int main()
{
    setlocale(LC_ALL, "rus");
    DWORD processId = GetCurrentProcessId();
    std::cout << "ID процесса OS03_02_1: " << processId << std::endl;

    for (int i = 0; i < 50; i++)
    {
        Sleep(1000);
        std::cout << "OS03_02_1. Итерация: " << i << std::endl;
    }

    return 0;
}
