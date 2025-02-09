#define _CRT_SECURE_NO_WARNINGS
#include <Windows.h>
#include <iostream>

#define FILE_PATH L"D:\\Уник\\1sem\\ОС\\лаба9-ос\\OS09_01.txt"
#define READ_BYTES 1000

using namespace std;

DWORD countLinesInFile(LPWSTR fileName)
{
    DWORD lineCount = 0;
    try
    {
        HANDLE hf = CreateFile(fileName, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
        if (hf == INVALID_HANDLE_VALUE)
            throw "Не удалось открыть файл.";

        char buf[1024];
        DWORD n = 0;
        ZeroMemory(buf, sizeof(buf));
        BOOL b = ReadFile(hf, &buf, sizeof(buf), &n, NULL);
        if (!b)
            throw "Не удалось прочитать файл.";

        for (DWORD i = 0; i < n; i++)
        {
            if (buf[i] == '\n')
                lineCount++;
        }

        CloseHandle(hf);
    }
    catch (const char* em)
    {
        cout << "Ошибка: " << em << endl;
        return -1;
    }

    return lineCount;
}

BOOL printWatchRowFileTxt(LPWSTR fileName, DWORD mIsec)
{
    try
    {
        HANDLE hDir = FindFirstChangeNotification(L"D:\\Уник\\1sem\\ОС\\лаба9-ос", FALSE, FILE_NOTIFY_CHANGE_LAST_WRITE);
        if (hDir == INVALID_HANDLE_VALUE)
            throw "Не удалось открыть каталог для наблюдения.";

        DWORD prevLineCount = countLinesInFile(fileName);
        if (prevLineCount == -1)
            throw "Не удалось подсчитать количество строк.";

        cout << "Наблюдение за файлом начато..." << endl;

        DWORD dwWaitStatus;
        DWORD startTime = GetTickCount64();

        while (true)
        {
            DWORD elapsedTime = GetTickCount64() - startTime;
            if (elapsedTime >= mIsec)
            {
                cout << "Программа завершена по истечению времени." << endl;
                break;
            }

            dwWaitStatus = WaitForSingleObject(hDir, mIsec);
            if (dwWaitStatus == WAIT_OBJECT_0)
            {
                DWORD currentLineCount = countLinesInFile(fileName);
                if (currentLineCount != prevLineCount)
                {
                    if (currentLineCount == -1)
                    {
                        cout << "Ошибка: Не удалось прочитать файл." << endl;
                        break;
                    }
                    cout << "Количество строк в файле изменилось: " << prevLineCount << " -> " << currentLineCount << endl;
                    prevLineCount = currentLineCount;
                }

                if (!FindNextChangeNotification(hDir))
                {
                    cout << "Ошибка при повторном ожидании изменений." << endl;
                    break;
                }
            }
            else if (dwWaitStatus == WAIT_TIMEOUT)
            {
                continue;
            }
            else
            {
                cout << "Ошибка при ожидании изменений." << endl;
                break;
            }
        }

        CloseHandle(hDir);
        return TRUE;
    }
    catch (const char* em)
    {
        cout << em << endl;
        return FALSE;
    }
}

int main()
{
    setlocale(LC_ALL, "ru");

    LPWSTR file = (LPWSTR)FILE_PATH;
    DWORD mIsec = 10000;

    if (!printWatchRowFileTxt(file, mIsec))
    {
        cout << "Программа завершена с ошибкой." << endl;
    }

    return 0;
}
