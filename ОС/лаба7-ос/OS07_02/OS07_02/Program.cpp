#include <Windows.h>
#include <iostream>
#include <ctime>
using namespace std;

int main()
{
    setlocale(LC_ALL, "rus");
    clock_t start = clock();
    int counter = 0;
    bool is_5_sec = true, is_10_sec = true;

    while (true)
    {
        counter++;

        if (is_5_sec && (clock() - start) / CLOCKS_PER_SEC == 5) {
            cout << "Итерации после 5 секунд: " << counter << '\n';
            is_5_sec = false;
        }

        if (is_10_sec && (clock() - start) / CLOCKS_PER_SEC == 10) {
            cout << "Итерации после 10 секунд: " << counter << '\n';
            is_10_sec = false;
        }

        if ((clock() - start) / CLOCKS_PER_SEC == 15) {
            cout << "Итерации после 15 секунд: " << counter << '\n';
            break;
        }
    }

    return 0;
}
