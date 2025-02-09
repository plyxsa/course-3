#include <iostream>
#include <ctime>

int main() {
    std::time_t now = std::time(nullptr);
    std::tm local_time;

    localtime_s(&local_time, &now);

    char buffer[20];
    std::strftime(buffer, sizeof(buffer), "%d.%m.%Y %H:%M:%S", &local_time);
    std::cout << buffer << std::endl;

    return 0;
}
