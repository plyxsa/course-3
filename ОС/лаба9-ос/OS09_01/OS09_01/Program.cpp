#include <windows.h>
#include <iostream>
#include <iomanip>

using namespace std;

#define FILE_PATH "D:\\����\\1sem\\��\\����9-��\\OS09_01.txt" 

string getFileName(const char* filePath) {
    string filename(filePath);
    const size_t last_slash_idx = filename.find_last_of("\\/");
    if (string::npos != last_slash_idx)
        filename.erase(0, last_slash_idx + 1);
    return filename;
}

LPCSTR getFileType(HANDLE file) {
    switch (GetFileType(file)) {
    case FILE_TYPE_UNKNOWN: //0
        return "����������� ��� �����";
    case FILE_TYPE_DISK: //1
        return "���� �� �����";
    case FILE_TYPE_CHAR: //2
        return "���������� ����";
    case FILE_TYPE_PIPE: //3
        return "���� ������";
    case FILE_TYPE_REMOTE: //4
        return "�������� ����";
    default:
        return "[������]: ����������� ��� �����";
    }
}

BOOL printFileInfo(const char* path) {
    HANDLE file = CreateFileA(
        path,
        GENERIC_READ,          // �������� � ������
        FILE_SHARE_READ,       // ���������� �� ���������� ������
        NULL,                  // ��������� �� �������� ������������
        OPEN_EXISTING,         // ����� �������� �����
        FILE_ATTRIBUTE_NORMAL, // �������� �����
        NULL                   // ��������� �� ������ �����
    );

    if (file == INVALID_HANDLE_VALUE) {
        cerr << "������ ��� �������� �����: " << path << endl;
        return FALSE;
    }

    BY_HANDLE_FILE_INFORMATION fi;
    if (!GetFileInformationByHandle(file, &fi)) {
        cerr << "�� ������� �������� ���������� � �����." << endl;
        CloseHandle(file);
        return FALSE;
    }

    SYSTEMTIME sysTime;
    string filename = getFileName(path);
    cout << "��� �����: " << filename << endl;
    cout << "��� �����: " << getFileType(file) << endl;

    DWORD fileSize = fi.nFileSizeLow;
    cout << "������ �����: " << fileSize << " ����" << endl;

    FileTimeToSystemTime(&fi.ftCreationTime, &sysTime);
    cout << "����� ��������: " << setfill('0') << setw(2) << sysTime.wDay << "."
        << setw(2) << sysTime.wMonth << "." << setw(4) << sysTime.wYear << " "
        << setw(2) << sysTime.wHour << ":" << setw(2) << sysTime.wMinute << ":"
        << setw(2) << sysTime.wSecond << endl;

    FileTimeToSystemTime(&fi.ftLastWriteTime, &sysTime);
    cout << "����� ���������� ���������: " << setfill('0') << setw(2) << sysTime.wDay << "."
        << setw(2) << sysTime.wMonth << "." << setw(4) << sysTime.wYear << " "
        << setw(2) << sysTime.wHour << ":" << setw(2) << sysTime.wMinute << ":"
        << setw(2) << sysTime.wSecond << endl;

    CloseHandle(file);
    return TRUE;
}

BOOL printFileTxt(const char* path) {
    HANDLE file = CreateFileA(
        path,
        GENERIC_READ,          // �������� � ������
        FILE_SHARE_READ,       // ���������� �� ���������� ������
        NULL,                  // ��������� �� �������� ������������
        OPEN_EXISTING,         // ����� �������� �����
        FILE_ATTRIBUTE_NORMAL, // �������� �����
        NULL                   // ��������� �� ������ �����
    );

    if (file == INVALID_HANDLE_VALUE) {
        cerr << "������ ��� �������� �����: " << path << endl;
        return FALSE;
    }

    DWORD bytesRead;
    const DWORD bufferSize = 1024;
    char buffer[bufferSize];

    cout << "\n���������� �����:" << endl;
    while (ReadFile(file, buffer, bufferSize, &bytesRead, NULL) && bytesRead > 0) {
        cout.write(buffer, bytesRead);
    }

    CloseHandle(file);
    return TRUE;
}

int main() {
    setlocale(LC_ALL, "RUS");
    const char* fileName = FILE_PATH;

    cout << "���������� � �����:" << endl;
    if (!printFileInfo(fileName)) {
        cerr << "�� ������� �������� ���������� � �����." << endl;
    }

    if (!printFileTxt(fileName)) {
        cerr << "�� ������� ��������� ���������� �����." << endl;
    }

    return 0;
}
