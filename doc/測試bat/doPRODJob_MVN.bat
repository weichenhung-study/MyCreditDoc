@echo off

set /p id=請輸入進館編號: 
set "projName=Cardless"
set "savePlace=D:\PROD_Cardless_PROGRAM"
set "gitRepo=D:\GIT_REPO\%projName%"
set "fullPath=%savePlace%\backup\%id%"
mkdir %fullPath%\%projName%
Xcopy %gitRepo% %fullPath%\%projName% /E /H /C /I
echo ====== 已完成程式備份 ======
echo.
echo.
echo.

REM 將開發者的程式放置於D:\PROD_Cardless_PROGRAM，此資料夾內的程式將移動到D:\GIT_REPO\Cardless(主儲存倉庫)準備做比對
Xcopy %savePlace%\%projName% %gitRepo% /E /H /C /I
echo ====== 已將本次新增修改之程式移動到GIT_REPO ======
echo.
echo.
echo.

REM 依照programList.txt新增刪除修改。依照開發者的清單使程式異動
setlocal enabledelayedexpansion
for /f "delims=" %%i in (%savePlace%\programList.txt) do (
    set Line_word=%%i
	echo Line_word:!Line_word!
	
	REM 取得第一個字母
	set "First_letter=!Line_word:~0,1!"
	
	REM git刪除(D)
	if "!First_letter!" == "D" (
		 REM 使用 tokens 和 delims 取得 Tab 後的文字
        for /f "tokens=2 delims=	" %%j in ("!Line_word!") do (
            set Tab_after_text=%%j
			
			set "deleteFile=%gitRepo%\!Tab_after_text:/=\!"
			del !deleteFile!
			echo Deleted:!deleteFile!
		)
	)
)
start D:\Git\git-bash.exe -c "cd /d/GIT_REPO/!projName! && git add ."
echo ====== 已依照programList新刪修 ======
echo.
echo.
echo.
pause

REM 產出diff檔及程式清單
cd /d %gitRepo%
git diff > diff.txt
git diff --cached >> diff.txt
git diff --name-status > programList.txt
git diff --name-status --cached >> programList.txt

REM 將程式數量總計，回寫到programList.txt
set /A count_A=0
set /A count_D=0
set /A count_M=0
setlocal enabledelayedexpansion
for /f "delims=" %%i in (%CD%\programList.txt) do (
	set Line_word=%%i
	echo [0;32m Line_word:!Line_word! [0m
	
	REM 取得第一個字母
	set "First_letter=!Line_word:~0,1!"
	
	REM 計算A,D,M總量
	 if "!First_letter!" == "A" (
        set /A count_A+=1
    ) else if "!First_letter!" == "D" (
        set /A count_D+=1
    ) else if "!First_letter!" == "M" (
        set /A count_M+=1
    )
	
)

set /A total=count_A + count_M + count_D

echo. >> programList.txt
echo add(A): !count_A! >> programList.txt
echo modify(M): !count_M! >> programList.txt
echo delete(D): !count_D! >> programList.txt
echo total: !total! >> programList.txt

REM 將產出diff檔及程式清單 rename以符合資管需求 DataCompaire簡稱dc開頭
set "prod_diffName=dcdiff.txt"
set "prod_programListName=dcprogramList.txt"
rename diff.txt %prod_diffName%
rename programList.txt %prod_programListName%
echo ====== 已產生diff和程式清單 ======
echo.
echo.
echo.

REM 移動到指定資料夾後刪除 1.diff.txt 2.programList.txt
mkdir %fullPath%\diff
mkdir %fullPath%\diff\PROD_CompareResult
Xcopy %gitRepo%\%prod_diffName% %fullPath%\diff\PROD_CompareResult /C
Xcopy %gitRepo%\%prod_programListName% %fullPath%\diff\PROD_CompareResult /C
del /F %prod_diffName%
del /F %prod_programListName%
echo ====== 執行備份及刪除-已移動完成 PROD:diff, programList into backup ======
echo.
echo.
echo.
Xcopy %savePlace%\diff.txt %fullPath%\diff /C
Xcopy %savePlace%\programList.txt %fullPath%\diff /C
del /F %savePlace%\diff.txt
del /F %savePlace%\programList.txt
echo ====== 執行備份及刪除-已移動完成 開發人員帶入原始文件:diff, programList into backup ======
pause
echo.
echo.
echo.

echo ====== 執行compare作業 ======
set "prodProgramList=%fullPath%\diff\PROD_CompareResult\%prod_programListName%"
set "prodDiff=%fullPath%\diff\PROD_CompareResult\%prod_diffName%"
set "devProgramList=%fullPath%\diff\programList.txt"
set "devDiff=%fullPath%\diff\diff.txt"

fc "%prodProgramList%" "%devProgramList%"
if errorlevel 1 (
    echo ###### prodProgramList不同 ######
	echo ###### 1.請revert後重新執行 ######
	echo ###### 2.請重新將Cardless程式資料夾,程式清單,diff放入工作區 ######
	rmdir /s /q "%savePlace%\Cardless"
	echo ====== 已移除開發人員帶入原始程式:"%savePlace%\Cardless 資料夾 ======
	pause
	goto :eof
) else (
	echo ====== prodProgramList OK ======
)

fc "%prodDiff%" "%devDiff%"
if errorlevel 1 (
    echo ###### diff不同 ######
	echo ###### 1.請revert後重新執行 ######
	echo ###### 2.請重新將Cardless程式資料夾,程式清單,diff放入工作區 ######
	rmdir /s /q "%savePlace%\Cardless"
	echo ====== 已移除開發人員帶入原始程式:%savePlace%\Cardless 資料夾 ======
	pause
	goto :eof
) else (
	echo ====== diff OK ======
)
echo ====== compare OK ======
echo.
echo.
echo.
pause

echo ****** 請確認程式皆無誤 ******
git status
echo ****** 接下來要執行Commit ******
echo ****** 按下Enter後立即Commit ******
echo.
echo.
echo.
pause

git commit -m "%id%"
echo ====== commit OK ======
echo.
echo.
echo.
pause

REM 包版
cd /d %gitRepo%
call mvn clean package
echo ====== war OK ======
echo.
echo.
echo.
pause

REM 備份
mkdir %fullPath%\war
Xcopy %gitRepo%\target %fullPath%\war /E /H /C /I
echo ====== war已移至backup ======
echo.
echo.
echo.

REM clean
cd /d %gitRepo%
call mvn clean
echo ====== clean OK ======
echo.
echo.
echo.
pause

rmdir /s /q "%savePlace%\Cardless"
echo ====== 已移除開發人員帶入原始程式:%savePlace%\Cardless 資料夾 ======
echo.
echo.
echo.
echo ====== doPRODJob.bat OK ======
echo.
echo.
echo.
pause