#include "ConcurrentServer.h"

bool AcceptCycle(int squirt, SOCKET* s)
{
    bool rc = false;
    Contact contact(Contact::ACCEPT, "EchoServer");
    while (squirt-- > 0 && rc == false)
    {
        if ((contact.s = accept(*s, (sockaddr*)&contact.prms, &contact.lprms)) == INVALID_SOCKET)
        {
            int err = WSAGetLastError();
            if (err == WSAEWOULDBLOCK) {
                Sleep(100);
            }
            else if (err == WSAECONNRESET || err == WSAECONNABORTED) {
                cerr << "Client disconnected or aborted connection" << endl;
                break;
            }
            else throw SetErrorMsgText("accept: ", WSAGetLastError());
        }
        else
        {
            rc = true;
            contact.hAcceptServer = hAcceptServer;
            EnterCriticalSection(&ListContactCriticalSection);
            Contacts.push_front(contact);
            LeaveCriticalSection(&ListContactCriticalSection);
            InterlockedIncrement(&CurrentClients);
            InterlockedIncrement(&TotalClients);
            SetEvent(AcceptEvent);
        }
    }
    return rc;
}

void CommandsCycle(TalkersCommand& cmd, SOCKET* s)
{
    int squirt = 0;
    while (cmd != EXIT)
    {
        switch (cmd) {
        case START:
            cout << "start" << endl;
            cmd = GETCOMMAND;
            squirt = AS_SQUIRT;
            break;
        case STOP:
            cout << "stop" << endl;
            cmd = GETCOMMAND;
            squirt = 0;
            break;
        case WAIT:
            squirt = 0;
            WaitClients();
            cmd = START;
            break;
        case SHUTDOWN:
            squirt = 0;
            WaitClients();
            cmd = EXIT;
            break;
        }
        if (cmd != EXIT) {
            if (AcceptCycle(squirt, s))
            {
                cmd = GETCOMMAND;
            }
            else SleepEx(0, TRUE);
        }
    };
}

DWORD WINAPI AcceptServer(LPVOID pPrm)
{
    WSADATA wsaData;
    SOCKET  serverSocket;

    try {
        if (WSAStartup(MAKEWORD(2, 0), &wsaData) != 0)
            throw  SetErrorMsgText("startup:", WSAGetLastError());

        if ((serverSocket = socket(AF_INET, SOCK_STREAM, NULL)) == INVALID_SOCKET)
            throw  SetErrorMsgText("socket:", WSAGetLastError());

        cout << "Using port in AcceptServer: " << port << endl;

        SOCKADDR_IN serv;
        serv.sin_family = AF_INET;
        serv.sin_port = htons(port);
        serv.sin_addr.s_addr = INADDR_ANY;

        u_long nonblk;
        if (ioctlsocket(serverSocket, FIONBIO, &(nonblk = 1)) == SOCKET_ERROR)
            throw SetErrorMsgText("ioctlsocket:", WSAGetLastError());

        if (bind(serverSocket, (LPSOCKADDR)&serv, sizeof(serv)) == SOCKET_ERROR)
            throw  SetErrorMsgText("bind:", WSAGetLastError());

        if (listen(serverSocket, SOMAXCONN) == SOCKET_ERROR)
            throw SetErrorMsgText("listen:", WSAGetLastError());

        TalkersCommand* command = (TalkersCommand*)pPrm;
        CommandsCycle(*((TalkersCommand*)command), &serverSocket);

        if (closesocket(serverSocket) == SOCKET_ERROR)
            throw  SetErrorMsgText("closesocket:", WSAGetLastError());

        if (WSACleanup() == SOCKET_ERROR)
            throw  SetErrorMsgText("cleanup:", WSAGetLastError());
    }
    catch (string errorMsgText)
    {
        cout << endl << errorMsgText;
    }

    DWORD rc = 0;
    ExitThread(rc);
}

void WaitClients() {
    bool EveryoneIsServed = false;
    while (!EveryoneIsServed) {
        EnterCriticalSection(&ListContactCriticalSection);
        EveryoneIsServed = Contacts.empty();
        LeaveCriticalSection(&ListContactCriticalSection);
        SleepEx(0, TRUE);
    }
}