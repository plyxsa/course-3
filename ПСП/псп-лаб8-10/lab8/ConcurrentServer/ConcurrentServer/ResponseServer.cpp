#include "ConcurrentServer.h"
#include <vector>


DWORD WINAPI ResponseServer(LPVOID pPrm) {
	DWORD rc = 0;
	SOCKET servsock;
	WSADATA wsaData;
	SOCKADDR_IN client;  
	int clientsockaddrlen = sizeof(client);
	SOCKADDR_IN serv; 	
	serv.sin_family = AF_INET;
	serv.sin_port = htons(udpport);
	serv.sin_addr.s_addr = ADDR_ANY;

	cout << "ResponseServer start\n";

	try
	{
		if (WSAStartup(MAKEWORD(2, 0), &wsaData) != 0)	throw  SetErrorMsgText("Startup:", WSAGetLastError());
		if ((servsock = socket(AF_INET, SOCK_DGRAM, NULL)) == INVALID_SOCKET)
			throw  SetErrorMsgText("Socket:", WSAGetLastError());

		u_long nonblk = 1;
		if (ioctlsocket(servsock, FIONBIO, &(nonblk = 1)) == SOCKET_ERROR)
			throw SetErrorMsgText("Ioctlsocket:", WSAGetLastError());

		if (bind(servsock, (LPSOCKADDR)&serv, sizeof(serv)) == SOCKET_ERROR)
			throw  SetErrorMsgText("Bind:", WSAGetLastError());

		while (*((TalkersCommand*)pPrm) != EXIT) {
			char ibuf[50];
			char obuf[100];
			int  libuf = 0;

			memset(ibuf, 0, sizeof(ibuf));
			if ((libuf = recvfrom(servsock, ibuf, sizeof(ibuf) - 1, NULL, (LPSOCKADDR)&client, &clientsockaddrlen)) == SOCKET_ERROR) {
				switch (WSAGetLastError()) {
				case WSAEWOULDBLOCK: {
					Sleep(1000); 
					break;
				}
					default: throw SetErrorMsgText("Recv:", WSAGetLastError());
				}
			}
			if (libuf > 0) {
				if (strcmp(ibuf, servercall) == 0) {
					if ((libuf = sendto(servsock, ibuf, strlen(ibuf) + 1, NULL, (LPSOCKADDR)&client, sizeof(client))) == SOCKET_ERROR)
						throw SetErrorMsgText("Sendto:", WSAGetLastError());
				}
			}
		}
		if (closesocket(servsock) == SOCKET_ERROR) 
			throw SetErrorMsgText("Closesocket:", WSAGetLastError());
		if (WSACleanup() == SOCKET_ERROR)
			throw SetErrorMsgText("Cleanup:", WSAGetLastError());
	}
	catch (string errorMsgText) {
		cout << errorMsgText << endl;
	}
	cout << "ResponseServer is stopped\n" << endl;
	ExitThread(rc);
}
