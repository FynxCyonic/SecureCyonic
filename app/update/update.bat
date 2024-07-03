@echo on && rem Script feito por SecureCyonic
title SecureCyonic - Updating...
set main.file=%1 && set url=%2 && set securecy.path.archive=%3 && set securecy.name=%4 && set filetoupdate.link=%5
(
    :update.task
    setlocal >nul 2>&1
    curl -o "%securecy.name%" %filetoupdate.link% > nul 2>&1
    del /q %securecy.path.archive% >nul
    move /y "%securecy.name%" "%securecy.path.archive%" > nul 2>&1
)
call %securecy.path.archive%sc.cmd %main.file% %url% && pause && del %0 >nul
(
    :confirm
    if exist "%0" ( del %0 >nul )
    del %0 >nul && exit /b >nul && call :confirm >nul
)