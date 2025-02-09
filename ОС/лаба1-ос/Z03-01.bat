@echo off
chcp 1251 > nul
echo ========================================
echo Информация о системе
echo ========================================

echo Имя компьютера: %COMPUTERNAME%
echo Операционная система: %OS%
echo Процессор: %PROCESSOR_IDENTIFIER%
echo Количество процессоров: %NUMBER_OF_PROCESSORS%
echo Имя пользователя: %USERNAME%

pause
