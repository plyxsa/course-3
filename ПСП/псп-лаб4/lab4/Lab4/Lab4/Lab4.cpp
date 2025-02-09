﻿#include "Winsock2.h"                
#pragma comment(lib, "WS2_32.lib")   
#include <ws2tcpip.h>
#include <string>
#include <vector>
#include <iostream>

using namespace std;

string GetErrorMsgText(int code)
{
    string msgText;
    switch (code)
    {
    case WSAEINTR:          msgText = "WSAEINTR: Работа функции прервана";
        break;
    case WSAEACCES:         msgText = "WSAEACCES: Разрешение отвергнуто";
        break;
    case WSAEFAULT:         msgText = "WSAEFAULT: Ошибочный адрес";
        break;
    case WSAEINVAL:         msgText = "WSAEINVAL: Ошибка в аргументе";
        break;
    case WSAEMFILE:         msgText = "WSAEMFILE: Слишком много файлов открыто";
        break;
    case WSAEWOULDBLOCK:    msgText = "WSAEWOULDBLOCK: Ресурс временно недоступен";
        break;
    case WSAEINPROGRESS:    msgText = "WSAEINPROGRESS: Операция в процессе развития";
        break;
    case WSAEALREADY:       msgText = "WSAEALREADY: Операция уже выполняется";
        break;
    case WSAENOTSOCK:       msgText = "WSAENOTSOCK: Сокет задан неправильно";
        break;
    case WSAEDESTADDRREQ:   msgText = "WSAEDESTADDRREQ: Требуется адрес расположения";
        break;
    case WSAEMSGSIZE:       msgText = "WSAEMSGSIZE: Сообщение слишком длинное";
        break;
    case WSAEPROTOTYPE:     msgText = "WSAEPROTOTYPE: Неправильный тип протокола для сокета";
        break;
    case WSAENOPROTOOPT:    msgText = "WSAENOPROTOOPT: Ошибка в опции протокола";
        break;
    case WSAEPROTONOSUPPORT: msgText = "WSAEPROTONOSUPPORT: Протокол не поддерживается";
        break;
    case WSAESOCKTNOSUPPORT: msgText = "WSAESOCKTNOSUPPORT: Тип сокета не поддерживается";
        break;
    case WSAEOPNOTSUPP:     msgText = "WSAEOPNOTSUPP: Операция не поддерживается";
        break;
    case WSAEPFNOSUPPORT:   msgText = "WSAEPFNOSUPPORT: Тип протоколов не поддерживается";
        break;
    case WSAEAFNOSUPPORT:   msgText = "WSAEAFNOSUPPORT: Тип адресов не поддерживается протоколом";
        break;
    case WSAEADDRINUSE:     msgText = "WSAEADDRINUSE: Адрес уже используется";
        break;
    case WSAEADDRNOTAVAIL:  msgText = "WSAEADDRNOTAVAIL: Запрошенный адрес не может быть использован";
        break;
    case WSAENETDOWN:       msgText = "WSAENETDOWN: Сеть отключена";
        break;
    case WSAENETUNREACH:    msgText = "WSAENETUNREACH: Сеть не достижима";
        break;
    case WSAENETRESET:      msgText = "WSAENETRESET: Сеть разорвала соединение";
        break;
    case WSAECONNABORTED:   msgText = "WSAECONNABORTED: Программный отказ связи";
        break;
    case WSAECONNRESET:     msgText = "WSAECONNRESET: Связь восстановлена";
        break;
    case WSAENOBUFS:        msgText = "WSAENOBUFS: Не хватает памяти для буферов";
        break;
    case WSAEISCONN:        msgText = "WSAEISCONN: Сокет уже подключен";
        break;
    case WSAENOTCONN:       msgText = "WSAENOTCONN: Сокет не подключен";
        break;
    case WSAESHUTDOWN:      msgText = "WSAESHUTDOWN: Нельзя выполнить send: сокет завершил работу";
        break;
    case WSAETIMEDOUT:      msgText = "WSAETIMEDOUT: Закончился отведенный интервал времени";
        break;
    case WSAECONNREFUSED:   msgText = "WSAECONNREFUSED: Соединение отклонено";
        break;
    case WSAEHOSTDOWN:      msgText = "WSAEHOSTDOWN: Хост в неработоспособном состоянии";
        break;
    case WSAEHOSTUNREACH:   msgText = "WSAEHOSTUNREACH: Нет маршрута для хоста";
        break;
    case WSAEPROCLIM:       msgText = "WSAEPROCLIM: Слишком много процессов";
        break;
    case WSASYSNOTREADY:    msgText = "WSASYSNOTREADY: Сеть не доступна";
        break;
    case WSAVERNOTSUPPORTED: msgText = "WSAVERNOTSUPPORTED: Данная версия недоступна";
        break;
    case WSANOTINITIALISED: msgText = "WSANOTINITIALISED: Не выполнена инициализация WS2_32.DLL";
        break;
    case WSAEDISCON:        msgText = "WSAEDISCON: Выполняется отключение";
        break;
    case WSATYPE_NOT_FOUND: msgText = "WSATYPE_NOT_FOUND: Класс не найден";
        break;
    case WSAHOST_NOT_FOUND: msgText = "WSAHOST_NOT_FOUND: Хост не найден";
        break;
    case WSATRY_AGAIN:      msgText = "WSATRY_AGAIN: Неавторизированный хост не найден";
        break;
    case WSANO_RECOVERY:    msgText = "WSANO_RECOVERY: Неопределенная ошибка";
        break;
    case WSANO_DATA:        msgText = "WSANO_DATA: Нет записи запрошенного типа";
        break;
    case WSA_INVALID_HANDLE: msgText = "WSA_INVALID_HANDLE: Указанный дескриптор события с ошибкой";
        break;
    case WSA_INVALID_PARAMETER: msgText = "WSA_INVALID_PARAMETER: Один или более параметров с ошибкой";
        break;
    case WSA_IO_INCOMPLETE: msgText = "WSA_IO_INCOMPLETE: Объект ввода-вывода не в сигнальном состоянии";
        break;
    case WSA_IO_PENDING:    msgText = "WSA_IO_PENDING: Операция завершится позже";
        break;
    case WSA_NOT_ENOUGH_MEMORY: msgText = "WSA_NOT_ENOUGH_MEMORY: Не достаточно памяти";
        break;
    case WSA_OPERATION_ABORTED: msgText = "WSA_OPERATION_ABORTED: Операция отвергнута";
        break;
    case WSASYSCALLFAILURE: msgText = "WSASYSCALLFAILURE: Аварийное завершение системного вызова";
        break;
    default:                msgText = "***ERROR***";        break;
    };
    return msgText;
};

string SetErrorMsgText(string msgText, int code)
{
    return  msgText + GetErrorMsgText(code);
};

bool GetRequestFromClient(char* name, short port, struct sockaddr* from, int* flen)
{
    SOCKET sS;

    sS = socket(AF_INET, SOCK_DGRAM, NULL);
    if (sS == INVALID_SOCKET) {
        cout << "Socket creation failed: " << WSAGetLastError() << endl;
    }

    SOCKADDR_IN server_addr;
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    server_addr.sin_addr.s_addr = INADDR_ANY;

    if (bind(sS, (SOCKADDR*)&server_addr, sizeof(server_addr)) == SOCKET_ERROR) {
        cout << "Bind failed: " << WSAGetLastError() << endl;
    }

    int recv_len;
    char buffer[50] = "";

    memset(buffer, 0, sizeof(buffer));

    cout << "Wait message..." << endl;
    while (true)
    {
        if ((recv_len = recvfrom(sS, buffer, sizeof(buffer), NULL, from, flen)) == SOCKET_ERROR)
        {
            if (WSAGetLastError() == WSAETIMEDOUT) {
                closesocket(sS);
                return false;
            }
            else {
                closesocket(sS);
                throw SetErrorMsgText("error: ", WSAGetLastError());
            }
        }
        closesocket(sS);

        if (strcmp(buffer, name) == 0)
            return true;
        else
            return false;
    }
}

bool PutAnswerToClient(char* name, const struct sockaddr_in* to, int* lto)
{
    SOCKET sS = socket(AF_INET, SOCK_DGRAM, NULL); 
    if (sS == INVALID_SOCKET) {
        throw SetErrorMsgText("socket: ", WSAGetLastError());  
    }

    int sent_len;
    if ((sent_len = sendto(sS, name, strlen(name), 0, (sockaddr*)to, *lto)) == SOCKET_ERROR) {
        int errorCode = WSAGetLastError();
        closesocket(sS);  
        cout << "sendto failed with error: " << errorCode << " (" << GetErrorMsgText(errorCode) << ")" << endl;

        throw SetErrorMsgText("sendto: ", errorCode);
    }


    if (closesocket(sS) == SOCKET_ERROR) {
        throw SetErrorMsgText("closesocket: ", WSAGetLastError());
    }

    return true;
}


int countServers = 1;
vector<string> serverIPs;  
bool isIPExists(const string& ip) {
    for (const string& storedIP : serverIPs) {
        if (storedIP == ip) {
            return true;
        }
    }
    return false;
}

void  GetServer(char* call, short port, struct sockaddr* from, int* flen) {
    SOCKET sS;

    sS = socket(AF_INET, SOCK_DGRAM, NULL);
    if (sS == INVALID_SOCKET) {
        cout << "Создание сокета не удалось: " << WSAGetLastError() << endl;
    }

    SOCKADDR_IN broadcast_addr;
    broadcast_addr.sin_family = AF_INET;
    broadcast_addr.sin_port = htons(port);
    broadcast_addr.sin_addr.s_addr = INADDR_BROADCAST;

    int broadcast = 1;
    int sent_len;
    int recv_len;
    char buffer[50];

    if (setsockopt(sS, SOL_SOCKET, SO_BROADCAST, (char*)&broadcast, sizeof(broadcast)) == SOCKET_ERROR) {
        closesocket(sS);
        throw SetErrorMsgText("Opt: ", WSAGetLastError());
    }

    int timeout = 500;
    if (setsockopt(sS, SOL_SOCKET, SO_RCVTIMEO, (char*)&timeout, sizeof(timeout)) == SOCKET_ERROR) {
        closesocket(sS);
        throw SetErrorMsgText("Setsockopt (SO_RCVTIMEO): ", WSAGetLastError());
    }


    if ((sent_len = sendto(sS, call, strlen(call), NULL, (sockaddr*)&broadcast_addr, sizeof(broadcast_addr))) == SOCKET_ERROR) {
        int errorCode = WSAGetLastError();
        closesocket(sS);
        cout << "Sendto закончился с ошибкой: " << errorCode << " (" << GetErrorMsgText(errorCode) << ")" << endl;
        throw SetErrorMsgText("Sendto: ", errorCode);
    }

    memset(buffer, 0, sizeof(buffer));
    clock_t startTime = clock();

    while (((clock() - startTime) / CLOCKS_PER_SEC) < 10) {

        if ((recv_len = recvfrom(sS, buffer, sizeof(buffer), NULL, from, flen)) == SOCKET_ERROR)
        {
            if (WSAGetLastError() == WSAETIMEDOUT) {
            }
            else {
                throw SetErrorMsgText("Ошибка: ", WSAGetLastError());
            }
        }

        if (strcmp(buffer, call) == 0) {
            char ip[INET_ADDRSTRLEN];
            inet_ntop(AF_INET, &(((SOCKADDR_IN*)from)->sin_addr), ip, INET_ADDRSTRLEN);

            if (!isIPExists(ip)) {
                countServers++;
                cout << "Server №" << countServers << " is found" << endl;;

                cout << "IP: " << ip << endl;
                cout << "Port: " << ntohs(((struct sockaddr_in*)from)->sin_port) << endl;

                serverIPs.push_back(ip);  
            }
        }
    }
    closesocket(sS);
}



int main()
{
    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);
    
    WSADATA wsaData;

    char name[20] = "Hello";
    short port = 2000;
    sockaddr_in client_addr;
    int addr_len = sizeof(client_addr);

    try
    {
        if (WSAStartup(MAKEWORD(2, 0), &wsaData) != 0)
            throw  SetErrorMsgText("startup:", WSAGetLastError());

        GetServer(name, port, (sockaddr*)&client_addr, &addr_len);
        cout << "Servers: " << countServers << endl;


        while (true) {
            if (GetRequestFromClient(name, port, (sockaddr*)&client_addr, &addr_len))
            {
                cout << "Connected by name" << endl;

                char ip[INET_ADDRSTRLEN];
                inet_ntop(AF_INET, &(client_addr.sin_addr), ip, INET_ADDRSTRLEN);

                cout << "IP: " << ip << endl;
                cout << "Port: " << htons(client_addr.sin_port) << endl;

                if (!PutAnswerToClient((char*)name, &client_addr, &addr_len))
                {
                    cout << "Error in sending response" << endl;
                }
            }

            else {
                cout << "Don't connected by name" << endl;
            }
        }

        if (WSACleanup() == SOCKET_ERROR)
            throw  SetErrorMsgText("cleanup:", WSAGetLastError());

    }
    catch (string errorMsgText)
    {
        cout << endl << errorMsgText;
    }
    return 0;
}