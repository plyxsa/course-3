#include <tchar.h>
#include <iostream>
#include <Windows.h>
#include <ctime>
#include <string>

using namespace std;

string SetPipeError(string msgText, int code);
string GetPipeError(int code);

void ShowAvailableCommands() {
    cout << "\n ---------- Доступные команды ---------- \n";
    cout << "1 - Sytart\tРазрешить подключение клиентов к серверу\n";
    cout << "2 - Stop\tЗапретить подключение клиентов к серверу\n";
    cout << "3 - Exit\tЗавершить работу сервера\n";
    cout << "4 - Statistics\tВывод статистики\n";
    cout << "5 - Wait\tПриостановить подключение клиентов, пока не обслужится последний клиент, подключенный к серверу\n";
    cout << "6 - Shutdown\tРавносильна последовательности команд: wait, exit\n";
    cout << "0 - Выход из консоли\n";
    cout << "\n ----------------------------------------- \n";
}

bool ConnectToNamedPipe(const wstring& pipeName, HANDLE& hNamedPipe) {
    wchar_t name[512];
    swprintf_s(name, sizeof(name) / sizeof(wchar_t), L"\\\\.\\pipe\\%s", pipeName.c_str());

    wcout << L"Подключение к каналу: " << name << endl;

    hNamedPipe = CreateFile(name,
        GENERIC_READ | GENERIC_WRITE,
        NULL,
        NULL,
        OPEN_EXISTING,
        NULL,
        NULL);

    if (hNamedPipe == INVALID_HANDLE_VALUE) {
        cout << "Ошибка подключения к каналу: " << GetPipeError(GetLastError()) << endl;
        return false;
    }

    return true;
}

void ProcessCommand(HANDLE hNamedPipe, int command) {
    char WriteBuf[2] = "";
    char ReadBuf[50] = "";
    DWORD nBytesRead, nBytesWrite;

    sprintf_s(WriteBuf, "%d", command);

    if (!WriteFile(hNamedPipe, WriteBuf, strlen(WriteBuf) + 1, &nBytesWrite, NULL)) {
        cout << "Ошибка записи в канал: WriteFile error" << endl;
        return;
    }

    if (!ReadFile(hNamedPipe, ReadBuf, sizeof(ReadBuf), &nBytesRead, NULL)) {
        cout << "Ошибка чтения из канала: ReadFile error" << endl;
        return;
    }

    cout << ReadBuf << endl;
}

int main(int argc, _TCHAR* argv[]) {
    setlocale(LC_ALL, "Russian");

    int command = 0;
    HANDLE hNamedPipe;

    try {
        ShowAvailableCommands();

        wstring pipename;
        cout << "Введите имя сервера: ";
        wcin >> pipename;

        if (!ConnectToNamedPipe(pipename, hNamedPipe)) {
            throw "Ошибка подключения к серверу.";
        }

        while (true) {
            cout << "Введите команду: ";
            scanf_s("%d", &command);

            if (command == 0) break;

            if (command > 0 && command < 7) {
                ProcessCommand(hNamedPipe, command);
            }
            else {
                cout << "Неверная команда. Попробуйте снова." << endl;
            }
        }

        if (!CloseHandle(hNamedPipe)) {
            throw SetPipeError("CloseHandle error: ", GetLastError());
        }

    }
    catch (string ErrorPipeText) {
        cout << endl << ErrorPipeText << endl;
    }

    return 0;
}


string SetPipeError(string msgText, int code)
{
    return msgText + GetPipeError(code);
}

string GetPipeError(int code)
{
    string msgText;
    switch (code)
    {
    case WSAEINTR:
        msgText = "Function interrupted";
        break;
    case WSAEACCES:
        msgText = "Permission denied";
        break;
    case WSAEFAULT:
        msgText = "Wrong address";
        break;
    case WSAEINVAL:
        msgText = "Wrong args";
        break;
    case WSAEMFILE:
        msgText = "Too many files have opened";
        break;
    case WSAEWOULDBLOCK:
        msgText = "Resource temporarily unavailable";
        break;
    case WSAEINPROGRESS:
        msgText = "Operation in progress";
        break;
    case WSAEALREADY:
        msgText = "Operation already in progress";
        break;
    case WSAENOTSOCK:
        msgText = "Wrong socket";
        break;
    case WSAEDESTADDRREQ:
        msgText = "Required adress location";
        break;
    case WSAEMSGSIZE:
        msgText = "Message is too long ";
        break;
    case WSAEPROTOTYPE:
        msgText = "Wrong protocol type to socket";
        break;
    case WSAENOPROTOOPT:
        msgText = "Error in protocol option";
        break;
    case WSAEPROTONOSUPPORT:
        msgText = "Protocol is not supported";
        break;
    case WSAESOCKTNOSUPPORT:
        msgText = "Socket type is not supported";
        break;
    case WSAEOPNOTSUPP:
        msgText = "Operation is not supported";
        break;
    case WSAEPFNOSUPPORT:
        msgText = "Protocol type is not supported";
        break;
    case WSAEAFNOSUPPORT:
        msgText = "Addresses type is not supported by protocol";
        break;
    case WSAEADDRINUSE:
        msgText = "Address is already used";
        break;
    case WSAEADDRNOTAVAIL:
        msgText = "Requested address cannot be used";
        break;
    case WSAENETDOWN:
        msgText = "Network disconnected";
        break;
    case WSAENETUNREACH:
        msgText = "Network is unttainable";
        break;
    case WSAENETRESET:
        msgText = "Network dropped the connection";
        break;
    case WSAECONNABORTED:
        msgText = "Connection aborted";
        break;
    case WSAECONNRESET:
        msgText = "Connection restored";
        break;
    case WSAENOBUFS:
        msgText = "Not enough memory for buffers";
        break;
    case WSAEISCONN:
        msgText = "Socket has already connected";
        break;
    case WSAENOTCONN:
        msgText = "Socket has not connected";
        break;
    case WSAESHUTDOWN:
        msgText = "Send cannot be performed: socket was shutdowned";
        break;
    case WSAETIMEDOUT:
        msgText = "Alloted time interval has ended";
        break;
    case WSAECONNREFUSED:
        msgText = "Connection was rejected";
        break;
    case WSAEHOSTDOWN:
        msgText = "Host was shotdowned";
        break;
    case WSAEHOSTUNREACH:
        msgText = "Has not way for host";
        break;
    case WSAEPROCLIM:
        msgText = "Too many processes";
        break;
    case WSASYSNOTREADY:
        msgText = "Network is unavailable";
        break;
    case WSAVERNOTSUPPORTED:
        msgText = "Version is not supported";
        break;
    case WSANOTINITIALISED:
        msgText = "WS2_32.dll is not initialised";
        break;
    case WSAEDISCON:
        msgText = "Connection in progress";
        break;
    case WSATYPE_NOT_FOUND:
        msgText = "Type is not found";
        break;
    case WSAHOST_NOT_FOUND:
        msgText = "Host is not found";
        break;
    case WSATRY_AGAIN:
        msgText = "Try again";
        break;
    case WSANO_RECOVERY:
        msgText = "Unknown error";
        break;
    case WSANO_DATA:
        msgText = "Has not data type";
        break;
    case WSAEINVALIDPROCTABLE:
        msgText = "Invalid provider";
        break;
    case WSAEINVALIDPROVIDER:
        msgText = "Error in provider version";
        break;
    case WSAEPROVIDERFAILEDINIT:
        msgText = "Failed provider initialization";
        break;
    case WSASYSCALLFAILURE:
        msgText = "Abnormal termination of a system call";
        break;
    default:
        msgText = "Unknown error";
        break;
    }
    return msgText;
}