#include "ConcurrentServer.h"

DWORD WINAPI ConsolePipe(LPVOID pPrm) {
	cout << "ConsolePipe started\n";
	HANDLE hPipe;
	try 
	{
		wchar_t name[512];
		swprintf_s(name, sizeof(name) / sizeof(wchar_t), L"\\\\.\\pipe\\%s", pipename.c_str());

		HANDLE hPipe = CreateNamedPipe(name, PIPE_ACCESS_DUPLEX, PIPE_TYPE_MESSAGE | PIPE_WAIT, 1, NULL, NULL, INFINITE, NULL);
		if (hPipe == INVALID_HANDLE_VALUE) {
			throw SetErrorMsgText("Create:", GetLastError());
		}

		while (*((TalkersCommand*)pPrm) != EXIT) {
			if (!ConnectNamedPipe(hPipe, NULL)) throw SetErrorMsgText("Connect error:", GetLastError());
			char readBuffer[50], writeBuffer[50];
			DWORD bytesRead = 0, bytesWrite = 0;
			TalkersCommand SetCommand;
			bool serverCommand;

			while (*((TalkersCommand*)pPrm) != EXIT) {
				if (*((TalkersCommand*)pPrm) == GETCOMMAND) {
					if (!ReadFile(hPipe, readBuffer, sizeof(readBuffer), &bytesRead, NULL)) {
						break;
					}
					if (bytesRead > 0) {
						int n = atoi(readBuffer);
						switch (n) {
							case 1:
								sprintf_s(writeBuffer, "%s", "START");
								SetCommand = TalkersCommand::START;
								break;
							case 2:
								sprintf_s(writeBuffer, "%s", "STOP");
								SetCommand = TalkersCommand::STOP;
								break;
							case 3:
								sprintf_s(writeBuffer, "%s", "EXIT");
								SetCommand = TalkersCommand::EXIT;
								break;
							case 4:
								sprintf_s(writeBuffer, "\nTotal:   \t%i\nActive:  \t%i\nRejected:\t%i\n", TotalClients, CurrentClients, RejectedClients);
								SetCommand = TalkersCommand::GETCOMMAND;
								break;
							case 5:
								sprintf_s(writeBuffer, "%s", "WAIT");
								SetCommand = TalkersCommand::WAIT;
								break;
							case 6:
								sprintf_s(writeBuffer, "%s", "SHUTDOWN");
								SetCommand = TalkersCommand::SHUTDOWN;
								break;
							default:
								sprintf_s(writeBuffer, "%s", "error");
								SetCommand = TalkersCommand::GETCOMMAND;
								break;
						}
						*((TalkersCommand*)pPrm) = SetCommand;
						if (!WriteFile(hPipe, writeBuffer, sizeof(writeBuffer), &bytesRead, NULL)) throw SetErrorMsgText("WriteFile error:", GetLastError());
					}
				}
				Sleep(1000);
			}
		}
		DisconnectNamedPipe(hPipe);
		CloseHandle(hPipe);
		cout << "ConsolePipe finished" << endl;
	}
	catch (string ErrorPipeText) {
		cout << ErrorPipeText << endl;
	}
	DWORD rc = 0;
	ExitThread(rc);
}
