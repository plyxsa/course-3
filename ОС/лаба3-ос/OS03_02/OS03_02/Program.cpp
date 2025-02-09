#include <Windows.h>
#include <iostream>

int main()
{
    setlocale(LC_ALL, "rus");
    DWORD processId = GetCurrentProcessId();
    std::cout << "ID процесса: " << processId << std::endl;

    // создание двух дочерних процессов
    STARTUPINFO si1, si2;
    PROCESS_INFORMATION pi1, pi2;

    ZeroMemory(&si1, sizeof(si1));
    si1.cb = sizeof(si1);
    ZeroMemory(&pi1, sizeof(pi1));

    ZeroMemory(&si2, sizeof(si2));
    si2.cb = sizeof(si2);
    ZeroMemory(&pi2, sizeof(pi2));

    // запуск первого дочернего процесса
    if (!CreateProcess(L"C:/Users/plyushka/source/repos/OS03_02_1/x64/Debug/OS03_02_1.exe", 
        NULL,   // командная строка для нового процесса 
        NULL,   // указатель на атрибуты безопасности для процесса 
        NULL,   // указатель на атрибуты безопасности для потока 
        FALSE,  // флаг наследования дескрипторов. FALSE = дескрипторы не наследуются дочерним процессом
        0,      // флаги создания процесса
        NULL,   // указатель на блок среды для нового процесса 
        NULL,   // указатель на рабочую директорию для нового процесса 
        &si1,   // указатель на структуру STARTUPINFO для конфигурации окна нового процесса
        &pi1))  // указатель на структуру PROCESS_INFORMATION для получения информации о новом процессе
    {
        std::cout << "Не удалось создать процесс OS03_02_1." << std::endl;
        return 1;
    }
    std::cout << "Запущен процесс OS03_02_1. ID: " << pi1.dwProcessId << std::endl;

    // запуск второго дочернего процесса 
    if (!CreateProcess(L"C:/Users/plyushka/source/repos/OS03_02_2/x64/Debug/OS03_02_2.exe", 
        NULL, NULL, NULL, FALSE, 0, NULL, NULL, &si2, &pi2))
    {
        std::cout << "Не удалось создать процесс OS03_02_2." << std::endl;
        return 1;
    }

    std::cout << "Запущен процесс OS03_02_2. ID: " << pi2.dwProcessId << std::endl;

    for (int i = 0; i < 100; i++)
    {
        Sleep(1000);
        std::cout << "Основной процесс. Итерация: " << i << std::endl;
    }

    // ожидание завершения дочерних процессов
    WaitForSingleObject(pi1.hProcess, INFINITE);
    WaitForSingleObject(pi2.hProcess, INFINITE);

    // закрытие дескрипторов
    CloseHandle(pi1.hProcess);
    CloseHandle(pi1.hThread);
    CloseHandle(pi2.hProcess);
    CloseHandle(pi2.hThread);

    return 0;
}
