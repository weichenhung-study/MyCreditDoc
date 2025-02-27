@echo off

:: 產生隨機的身份證字號
setlocal enabledelayedexpansion
:: 定義大寫英文字母
set "LETTERS=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
:: 產生首字（大寫字母）
set /a randIndex=%random% %% 26
set "CID="
for %%A in (!randIndex!) do set "CID=!LETTERS:~%%A,1!"
:: 產生後續 9 碼（0-9 數字）
for /l %%i in (1,1,9) do (
    set /a randNum=!random! %% 10
    set "CID=!CID!!randNum!"
)
:: 顯示結果
echo !CID!
pause
:: :: :: :: :: :: :: :: :: :: 


curl -X POST "http://localhost:8080/ebankC/res/sc020703001" ^
     -H "Content-Type: application/json" ^
     -d "{\"cid\": \"!CID!\", \"loginUID\": \"admin1\", \"token\": \"qmo987and978\"}"
::curl -X PUT "http://localhost:8080/ebankC/res/sc020703001" ^
::     -H "Content-Type: application/json" ^
::     -d "{\"cid\": \"!RESULT!\", \"loginUID\": \"admin1\", \"token\": \"qmo987and978\"}"
::curl -X GET "https://example.com/api"
pause
