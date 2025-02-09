#pragma once
#include <winsock2.h>
#include <windows.h>
#include <iostream>
#include <string>
#include <list>
#pragma comment(lib, "ws2_32.lib")

using namespace std;

extern HANDLE hAcceptServer, hDispatchServer;
extern int port, udpport;
extern const char* servercall;
extern CRITICAL_SECTION ListContactCriticalSection;

struct Contact
{
    //��������� ������� �����������
    enum TE {
        EMPTY,              // ������ ������� ������ ����������� 
        ACCEPT,             // ���������, �� �� �������������
        CONTACT             // ������� �������������� �������  
    }    type;

    // ��������� �������������� �������
    enum ST {
        WORK,               // ���� ����� ������� � ��������
        ABORT,              // ������������� ������ ���������� ����������� 
        TIMEOUT,            // ������������� ������ ���������� �� ������� 
        FINISH              // ������������� ������ ����������  ��������� 
    }      sthread;

    // ��� �������� ���������� ����������
    SOCKET      s;         // ����� ��� ������ ������� � ��������
    SOCKADDR_IN prms;      // ���������  ������ 
    int         lprms;     // ����� prms 


    HANDLE      hthread;   // ���������� ������  EchoServer
    HANDLE      htimer;    // ���������� ���������� �������, ������������ ���������� ����� ������ �������������� ��������

    bool        TimerOff;  // ����� ������������ �������
    bool        CloseConn;  // ����� ���������� ������������

    //���������������� ��������� � ������������� ���� �������������� �������.
    char msg[50];           // ��������� 
    char srvname[15];       // ��� �������������� ������ 

    HANDLE hAcceptServer; // Handle �������������� ������

    Contact(TE t = EMPTY, const char* namesrv = "") // ����������� 
    {
        memset(&prms, 0, sizeof(SOCKADDR_IN));
        lprms = sizeof(SOCKADDR_IN); //������ ������
        type = t;
        strcpy_s(srvname, namesrv);
        msg[0] = 0;
        CloseConn = false;
        TimerOff = false;
    };

    void SetST(ST sth, const char* m = "") {
        sthread = sth;
        strcpy_s(msg, m);
    }
};

typedef list<Contact> ListContact;
extern ListContact Contacts;
enum TalkersCommand { START, STOP, EXIT, STATISTICS, WAIT, SHUTDOWN, GETCOMMAND };

string GetErrorMsgText(int code);
string SetErrorMsgText(string msgText, int code);

#define AS_SQUIRT 10

bool AcceptCycle(int squirt, SOCKET* s);
void CommandsCycle(TalkersCommand& cmd, SOCKET* s);
DWORD WINAPI AcceptServer(LPVOID pPrm);
DWORD WINAPI GarbageCleaner(LPVOID pPrm);
DWORD WINAPI DispatchServer(LPVOID pPrm);
DWORD WINAPI ConsolePipe(LPVOID pPrm);
DWORD WINAPI ResponseServer(LPVOID pPrm);

extern HANDLE(*sss)(char*, LPVOID);
extern HMODULE st;
extern const char* dllname;
extern wstring pipename;
void WaitClients();

extern volatile LONG CurrentClients;
extern volatile LONG TotalClients;
extern volatile LONG RejectedClients;

void CALLBACK ASWTimer(LPVOID Lprm, DWORD, DWORD);

extern HANDLE AcceptEvent;

extern bool serverIsStop;