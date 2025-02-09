﻿#include <iostream>
#include "Winsock2.h"
#include <string>
#include <thread>
#include <chrono>
#pragma comment(lib, "WS2_32.lib")
#pragma warning(disable: 4996)

using namespace std;

string GetErrorMsgText(int code) {
    string msgText;
    switch (code) {
    case WSAEINTR:          msgText = "WSAEINTR: Работа функции прервана"; break;
    case WSAEACCES:         msgText = "WSAEACCES: Разрешение отвергнуто"; break;
    case WSAEFAULT:         msgText = "WSAEFAULT: Ошибочный адрес"; break;
    case WSAEINVAL:         msgText = "WSAEINVAL: Ошибка в аргументе"; break;
    case WSAEMFILE:         msgText = "WSAEMFILE: Слишком много файлов открыто"; break;
    case WSAEWOULDBLOCK:    msgText = "WSAEWOULDBLOCK: Ресурс временно недоступен"; break;
    case WSAEINPROGRESS:    msgText = "WSAEINPROGRESS: Операция в процессе развития"; break;
    case WSAEALREADY:       msgText = "WSAEALREADY: Операция уже выполняется"; break;
    case WSAENOTSOCK:       msgText = "WSAENOTSOCK: Сокет задан неправильно"; break;
    case WSAEDESTADDRREQ:   msgText = "WSAEDESTADDRREQ: Требуется адрес расположения"; break;
    case WSAEMSGSIZE:       msgText = "WSAEMSGSIZE: Сообщение слишком длинное"; break;
    case WSAEPROTOTYPE:     msgText = "WSAEPROTOTYPE: Неправильный тип протокола для сокета"; break;
    default:                msgText = "***ERROR***: Unknown error"; break;
    }
    return msgText;
}

string SetErrorMsgText(string msgText, int code) {
    return msgText + " " + GetErrorMsgText(code);
}

int main() {
    setlocale(LC_ALL, "Rus");

    WSADATA wsaData; 
    SOCKET sS; 
    SOCKADDR_IN servAddr, from; 
    char bfrom[50]; // Буфер для получения сообщений от клиента
    int port = 2000, fromlen = sizeof(from);

    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) { //1
        throw SetErrorMsgText("Ошибка при вызове WSAStartup: ", WSAGetLastError());
    }
    cout << "Winsock библиотека инициализирована." << endl;

    // Создание UDP-сокета
    if ((sS = socket(AF_INET, SOCK_DGRAM, 0)) == INVALID_SOCKET) { //2
        throw SetErrorMsgText("Ошибка при создании сокета: ", WSAGetLastError());
    }
    cout << "Сокет создан." << endl;

    servAddr.sin_family = AF_INET; // Семейство адресов (IPv4)
    servAddr.sin_port = htons(port); // Установка порт
    servAddr.sin_addr.s_addr = INADDR_ANY; // Привязываемся ко всем доступным интерфейсам

    // Привязка сокета к адресу и порту
    if (bind(sS, (LPSOCKADDR)&servAddr, sizeof(servAddr)) == SOCKET_ERROR) { //3
        throw SetErrorMsgText("Ошибка при привязке сокета (bind): ", WSAGetLastError());
    }
    cout << "Сокет успешно привязан к порту " << port << "." << endl;
    cout << "Ожидание сообщений..." << endl;

    int bufSize = 32; // Размер входного буфера
    if (setsockopt(sS, SOL_SOCKET, SO_RCVBUF, (char*)&bufSize, sizeof(bufSize)) == SOCKET_ERROR) {
        throw SetErrorMsgText("Ошибка при установке размера буфера (setsockopt): ", WSAGetLastError());
    }
    cout << "Размер входного буфера сокета установлен на " << bufSize << " байт." << endl;

    while (true) {

        int recv_len = recvfrom(sS, bfrom, sizeof(bfrom), 0, (sockaddr*)&from, &fromlen);
        if (recv_len == SOCKET_ERROR) {
            throw SetErrorMsgText("Ошибка при получении сообщения (recvfrom): ", WSAGetLastError());
        }

        bfrom[recv_len] = '\0';
        cout << "Сообщение от клиента (IP: " << inet_ntoa(from.sin_addr) << ", Port: " << ntohs(from.sin_port) << "): " << bfrom << endl;

        Sleep(200); // Задержка перед отправкой ответа

        //
        if (sendto(sS, bfrom, recv_len, 0, (sockaddr*)&from, fromlen) == SOCKET_ERROR) {
            throw SetErrorMsgText("Ошибка при отправке сообщения (sendto): ", WSAGetLastError());
        }
        cout << "Сообщение отправлено обратно клиенту: " << bfrom << endl;
        //

        if (recv_len == 0) {
            break;
        }
    }

    if (closesocket(sS) == SOCKET_ERROR) {
        throw SetErrorMsgText("Ошибка при закрытии сокета: ", WSAGetLastError());
    }
    cout << "Сокет закрыт." << endl;

    if (WSACleanup() == SOCKET_ERROR) {
        throw SetErrorMsgText("Ошибка при вызове WSACleanup: ", WSAGetLastError());
    }
    cout << "Winsock библиотека завершила работу." << endl;

    return 0;
}