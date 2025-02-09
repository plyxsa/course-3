#include <iostream>
#include <Windows.h>
using namespace std;

int main() {
    int num = 2;

    while (true) {
        bool isPrime = true;

        for (int i = 2; i * i <= num; ++i) {
            if (num % i == 0) {
                isPrime = false;
                break;
            }
        }

        if (isPrime) {
            cout << num << endl;
        }

        num++;
    }

    return 0;
}
