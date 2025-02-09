#include <windows.h>
#include <iostream>
#include <iomanip>

using namespace std;

#define FILE_PATH "D:\\Уник\\1sem\\ОС\\лаба9-ос\\OS09_01.txt" 

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
        return "Неизвестный тип файла";
    case FILE_TYPE_DISK: //1
        return "Файл на диске";
    case FILE_TYPE_CHAR: //2
        return "Символьный файл";
    case FILE_TYPE_PIPE: //3
        return "Файл канала";
    case FILE_TYPE_REMOTE: //4
        return "Удалённый файл";
    default:
        return "[ОШИБКА]: Неизвестный тип файла";
    }
}

BOOL printFileInfo(const char* path) {
    HANDLE file = CreateFileA(
        path,
        GENERIC_READ,          // Операции с файлом
        FILE_SHARE_READ,       // Разрешение на совместный доступ
        NULL,                  // Указатель на атрибуты безопасности
        OPEN_EXISTING,         // Режим открытия файла
        FILE_ATTRIBUTE_NORMAL, // Атрибуты файла
        NULL                   // Указатель на шаблон файла
    );

    if (file == INVALID_HANDLE_VALUE) {
        cerr << "Ошибка при открытии файла: " << path << endl;
        return FALSE;
    }

    BY_HANDLE_FILE_INFORMATION fi;
    if (!GetFileInformationByHandle(file, &fi)) {
        cerr << "Не удалось получить информацию о файле." << endl;
        CloseHandle(file);
        return FALSE;
    }

    SYSTEMTIME sysTime;
    string filename = getFileName(path);
    cout << "Имя файла: " << filename << endl;
    cout << "Тип файла: " << getFileType(file) << endl;

    DWORD fileSize = fi.nFileSizeLow;
    cout << "Размер файла: " << fileSize << " байт" << endl;

    FileTimeToSystemTime(&fi.ftCreationTime, &sysTime);
    cout << "Время создания: " << setfill('0') << setw(2) << sysTime.wDay << "."
        << setw(2) << sysTime.wMonth << "." << setw(4) << sysTime.wYear << " "
        << setw(2) << sysTime.wHour << ":" << setw(2) << sysTime.wMinute << ":"
        << setw(2) << sysTime.wSecond << endl;

    FileTimeToSystemTime(&fi.ftLastWriteTime, &sysTime);
    cout << "Время последнего изменения: " << setfill('0') << setw(2) << sysTime.wDay << "."
        << setw(2) << sysTime.wMonth << "." << setw(4) << sysTime.wYear << " "
        << setw(2) << sysTime.wHour << ":" << setw(2) << sysTime.wMinute << ":"
        << setw(2) << sysTime.wSecond << endl;

    CloseHandle(file);
    return TRUE;
}

BOOL printFileTxt(const char* path) {
    HANDLE file = CreateFileA(
        path,
        GENERIC_READ,          // Операции с файлом
        FILE_SHARE_READ,       // Разрешение на совместный доступ
        NULL,                  // Указатель на атрибуты безопасности
        OPEN_EXISTING,         // Режим открытия файла
        FILE_ATTRIBUTE_NORMAL, // Атрибуты файла
        NULL                   // Указатель на шаблон файла
    );

    if (file == INVALID_HANDLE_VALUE) {
        cerr << "Ошибка при открытии файла: " << path << endl;
        return FALSE;
    }

    DWORD bytesRead;
    const DWORD bufferSize = 1024;
    char buffer[bufferSize];

    cout << "\nСодержимое файла:" << endl;
    while (ReadFile(file, buffer, bufferSize, &bytesRead, NULL) && bytesRead > 0) {
        cout.write(buffer, bytesRead);
    }

    CloseHandle(file);
    return TRUE;
}

int main() {
    setlocale(LC_ALL, "RUS");
    const char* fileName = FILE_PATH;

    cout << "Информация о файле:" << endl;
    if (!printFileInfo(fileName)) {
        cerr << "Не удалось получить информацию о файле." << endl;
    }

    if (!printFileTxt(fileName)) {
        cerr << "Не удалось прочитать содержимое файла." << endl;
    }

    return 0;
}
