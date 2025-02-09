@echo off
chcp 1251 > nul
set "target_dir=TXT"

move *%1 "%target_dir%\"

pause
