#include <Windows.h>
#include <iostream>

int main()
{
    setlocale(LC_ALL, "rus");
    DWORD processId = GetCurrentProcessId();
    std::cout << "ID процесса OS03_02_2: " << processId << std::endl;

    for (int i = 0; i < 125; i++)
    {
        Sleep(1000);
        std::cout << "OS03_02_2. Итерация: " << i << std::endl;
    }

    return 0;
}
