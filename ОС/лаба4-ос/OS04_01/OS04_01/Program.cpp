#include <windows.h>
#include <iostream>
#include <thread>

using namespace std;

int main()
{
    setlocale(LC_ALL, "rus");
    DWORD processId = GetCurrentProcessId();
    DWORD threadId = GetCurrentThreadId();

    for (int i = 0; i < 1000; ++i)
    {
        cout << "��������: " << i + 1 << ", ID ��������: " << processId << ", ID ������: " << threadId << endl;
        Sleep(1000);
    }

    return 0;
}