@echo off
chcp 1251 > nul
set "target_dir=TXT"

if not exist "%target_dir%" (
    mkdir "%target_dir%"
)

move *.txt "%target_dir%\"

if %errorlevel%==0 (
    echo ��� ����� .txt ������� ���������� � ������� "%target_dir%".
) else (
    echo ������ ��� ����������� ������ ��� ����� �����������.
)

pause