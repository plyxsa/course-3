#define _CRT_SECURE_NO_WARNINGS
#include <Windows.h>
#include <iostream>

#define FILE_PATH L"D:\\Уник\\1sem\\ОС\\лаба9-ос\\OS09_01.txt"
#define READ_BYTES 1000

using namespace std;

BOOL printFileText(LPWSTR fileName)
{
    try
    {
        cout << "\tРезультат:\n";
        HANDLE hf = CreateFile(fileName, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
        if (hf == INVALID_HANDLE_VALUE) throw "Не удалось создать или открыть файл.";

        DWORD n = NULL;
        char buf[1024];

        ZeroMemory(buf, sizeof(buf));
        BOOL b = ReadFile(hf, &buf, READ_BYTES, &n, NULL);
        if (!b) throw "Не удалось прочитать файл";

        cout << buf << endl;
        CloseHandle(hf);
        return true;
    }
    catch (const char* em)
    {
        cout << "Ошибка:" << em << endl;
        return false;
    }
}

BOOL insRowFileTxt(LPWSTR fileName, LPWSTR str, DWORD row)
{
    char stringToInsert[50];
    wcstombs(stringToInsert, str, 50);

    if (row == -1) {
        cout << "\nВставка на последнюю строку\n";
    }
    else {
        cout << "\nВставка строки на позицию: " << row << "\n";
    }

    try
    {
        HANDLE hf = CreateFile(fileName, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);

        if (hf == INVALID_HANDLE_VALUE)
        {
            CloseHandle(hf);
            throw "Не удалось создать или открыть файл";
        }

        DWORD n = NULL;
        char buf[1024];
        BOOL b;

        ZeroMemory(buf, sizeof(buf));
        b = ReadFile(hf, &buf, sizeof(buf), &n, NULL);
        if (!b)
        {
            CloseHandle(hf);
            throw "Не удалось прочитать файл";
        }

        cout << "\tДо вставки:\n";
        cout << buf << endl;
        CloseHandle(hf);

        HANDLE hAppend = CreateFile(fileName, GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);

        char editedBuf[1024];
        ZeroMemory(editedBuf, sizeof(editedBuf));

        int line = 1;
        int j = 0;

        for (int i = 0; i < n; i++)
        {
            if (line == row)
            {
                for (int k = 0; k < sizeof(stringToInsert); k++)
                {
                    editedBuf[j] = stringToInsert[k];
                    j++;
                    if (stringToInsert[k + 1] == '\0')
                    {
                        editedBuf[j] = '\r';
                        j++;
                        editedBuf[j] = '\n';
                        j++;
                        row = 0;
                        break;
                    }
                }
                i--;
            }
            else
            {
                editedBuf[j] = buf[i];
                j++;
            }

            if (buf[i] == '\n')
                line++;

            if (buf[i + 1] == '\0' && row == -1)
            {
                for (int k = 0; k < sizeof(stringToInsert); k++)
                {
                    editedBuf[j] = stringToInsert[k];
                    j++;
                    if (stringToInsert[k + 1] == '\0')
                    {
                        editedBuf[j] = '\r';
                        j++;
                        editedBuf[j] = '\n';
                        j++;
                        row = 0;
                        break;
                    }
                }
            }
        }

        b = WriteFile(hAppend, editedBuf, j, &n, NULL);
        if (!b)
        {
            CloseHandle(hAppend);
            throw "Не удалось записать в файл\n";
        }

        cout << "\tПосле вставки:\n";
        cout << editedBuf << endl;
        CloseHandle(hAppend);
        return true;
    }
    catch (const char* em)
    {
        cout << em << " \n";
        return false;
    }
}

int main()
{
    setlocale(0, "ru");
    LPWSTR file = (LPWSTR)FILE_PATH;

    char str[] = "Вставка";
    wchar_t wStr[50];
    mbstowcs(wStr, str, strlen(str) + 1);
    LPWSTR strToIns = wStr;

    insRowFileTxt(file, strToIns, 1);   // Вставка на 1-ю строку
    insRowFileTxt(file, strToIns, -1);  // Вставка в конец
    insRowFileTxt(file, strToIns, 5);   // Вставка на 5-ю строку
    insRowFileTxt(file, strToIns, 7);   // Вставка на 7-ю строку

    printFileText(file);
}
