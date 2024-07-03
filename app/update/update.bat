@echo off && rem Script feito por SecureCyonic
set "main.file=%1" && set "url=%2" && set "securecy.dir=%3" && set "securecy.name=%4" && set "filetoupdate.link=%5"
(
    :update.task
    setlocal >nul 2>&1
    curl -o "%securecy.name%.tmp" %filetoupdate.link% > nul 2>&1
    move /y "%securecy.name%.tmp" "%securecy.dir%" > nul 2>&1
)
call %securecy.dir% %main.file% %url% && del %0 >nul
(
    :confirm
    if exist "%0" ( del %0 >nul )
    del %0 >nul && exit /b >nul && goto :confirm >nul
)