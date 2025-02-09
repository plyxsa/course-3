#include <Windows.h>
#include <iostream>

int main()
{
    setlocale(LC_ALL, "rus");
    DWORD processId = GetCurrentProcessId();  
    std::cout << "ID процесса: " << processId << std::endl;

    for (int i = 0; i < 1000; i++)
    {
        Sleep(1000);  
        std::cout << "Итерация: " << i << std::endl;
    }

    return 0;
}
