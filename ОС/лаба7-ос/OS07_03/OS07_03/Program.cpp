#include <Windows.h>
#include <iostream>
#include <ctime>
using namespace std;

int main()
{
    setlocale(LC_ALL, "rus");

    HANDLE hTimer = CreateWaitableTimer(NULL, TRUE, NULL);
    if (hTimer == NULL) {
        cout << "Не удалось создать таймер." << endl;
        return 1;
    }

    LARGE_INTEGER liDueTime;
    liDueTime.QuadPart = -30000000LL;

    if (!SetWaitableTimer(hTimer, &liDueTime, 3000, NULL, NULL, FALSE)) {
        cout << "Не удалось установить таймер." << endl;
        CloseHandle(hTimer);
        return 1;
    }

    int counter = 0;
    clock_t start = clock();
    bool flag_3_sec = true, flag_15_sec = false;

    while (!flag_15_sec)
    {
        DWORD dwWaitResult = WaitForSingleObject(hTimer, INFINITE);

        if (dwWaitResult == WAIT_OBJECT_0) {
            counter++;
            clock_t elapsed = clock() - start;
            double elapsedSeconds = (double)elapsed / CLOCKS_PER_SEC;

            if ((int)elapsedSeconds % 3 == 0 && flag_3_sec) {
                cout << "Итерации после " << (int)elapsedSeconds << " секунд: " << counter << endl;
                flag_3_sec = false;
            }

            if (elapsedSeconds >= 15) {
                flag_15_sec = true;
            }
        }

        if ((clock() - start) / CLOCKS_PER_SEC % 3 != 0) {
            flag_3_sec = true;
        }
    }

    CloseHandle(hTimer);

    return 0;
}
