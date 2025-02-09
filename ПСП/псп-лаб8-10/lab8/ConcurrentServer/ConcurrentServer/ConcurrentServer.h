
#pragma once

#include <winsock2.h>
#include <windows.h>
#include <iostream>
#include <string>
#include <list>
#include <cstring>

#pragma comment(lib, "ws2_32.lib")

using namespace std;

// Глобальные переменные и дескрипторы потоков
extern HANDLE hAcceptServer, hDispatchServer, hGarbageCleaner, hConsolePipe, hResponseServer;
extern int port, udpport;
extern const char* servercall;
extern CRITICAL_SECTION ListContactCriticalSection;

// Перечисление состояний подключения
enum class ConnectionType {
    EMPTY,       // Пустой элемент списка подключений
    ACCEPT,      // Подключен, но не обслуживается
    CONTACT      // Передан обслуживающему серверу
};

// Перечисление состояний потока сервера
enum class ServerThreadState {
    WORK,        // Идет обмен данными с клиентом
    ABORT,       // Обслуживающий сервер завершился ненормально
    TIMEOUT,     // Обслуживающий сервер завершился по таймеру
    FINISH       // Обслуживающий сервер завершился нормально
};

// Структура, представляющая одно подключение
struct Contact {
    ConnectionType type;               // Тип подключения
    ServerThreadState sthread;          // Состояние потока обслуживающего сервера

    SOCKET s;                           // Сокет для обмена данными с клиентом
    SOCKADDR_IN prms;                   // Параметры сокета
    int lprms;                          // Длина prms

    HANDLE hthread;                     // Дескриптор потока
    HANDLE htimer;                      // Дескриптор таймера для ограничения времени работы потока

    bool TimerOff;                      // Метка срабатывания таймера
    bool CloseConn;                     // Метка завершения обслуживания

    char msg[50];                       // Диагностирующее сообщение
    char srvname[15];                   // Имя обслуживающего потока

    HANDLE hAcceptServer;               // Дескриптор обслуживающего потока

    // Конструктор
    Contact(ConnectionType t = ConnectionType::EMPTY, const char* namesrv = "") {
        memset(&prms, 0, sizeof(SOCKADDR_IN));
        lprms = sizeof(SOCKADDR_IN);    // Размер сокета
        type = t;
        strcpy_s(srvname, namesrv);
        msg[0] = 0;
        CloseConn = false;
        TimerOff = false;
    }

    // Установить состояние потока
    void SetST(ServerThreadState sth, const char* m = "") {
        sthread = sth;
        strcpy_s(msg, m);
    }
};

// Тип для списка контактов
typedef list<Contact> ListContact;
extern ListContact Contacts;

// Перечисление команд для сервера
enum class TalkersCommand {
    START,        // Старт
    STOP,         // Стоп
    EXIT,         // Выход
    STATISTICS,   // Статистика
    WAIT,         // Ожидание
    SHUTDOWN,     // Завершение
    GETCOMMAND    // Получение команды
};

// Прототипы функций
string GetErrorMsgText(int code);
string SetErrorMsgText(string msgText, int code);

#define AS_SQUIRT 10  // Константа для циклов

bool AcceptCycle(int squirt, SOCKET* s);
void CommandsCycle(TalkersCommand& cmd, SOCKET* s);
DWORD WINAPI AcceptServer(LPVOID pPrm);
DWORD WINAPI GarbageCleaner(LPVOID pPrm);
DWORD WINAPI DispatchServer(LPVOID pPrm);
DWORD WINAPI ConsolePipe(LPVOID pPrm);
DWORD WINAPI ResponseServer(LPVOID pPrm);

extern HANDLE(*sss)(char*, LPVOID);     // Указатель на функцию в DLL
extern HMODULE st;                       // Дескриптор DLL
extern const char* dllname;              // Имя DLL
extern wstring pipename;                 // Имя канала

void WaitClients();                      // Ожидание клиентов

// Статистика по клиентам
extern volatile LONG CurrentClients;
extern volatile LONG TotalClients;
extern volatile LONG RejectedClients;

// Таймер для ограничений
void CALLBACK ASWTimer(LPVOID Lprm, DWORD, DWORD);

// Событие для приема подключений
extern HANDLE AcceptEvent;

// Флаг остановки сервера
extern bool serverIsStop;

