@echo on && rem Script feito por SecureCyonic
title SecureCyonic - Updating...
set "main.file=%1" && set "url=%2" && set "securecy.path.archive=%3" && set "securecy.name=%4" && set "filetoupdate.link=%5"

curl -o sc.cmd.update %filetoupdate.link% > nul 2>&1
del /q sc.cmd >nul && pause && rename sc.cmd.update sc.cmd

sc.cmd %main.file% %url% && pause && del %0 >nul