@echo off
echo Starting time %TIME%
	SET OS=Windows
	SET outputFile=drive.txt
	for /f %%g in ('whoami') do (
		SET USERNAME=%%g
	)
	for /f "usebackq delims=" %%g in (`wmic csproduct get UUID ^| find /i "-"`) do (
		SET UUID=%%g
	)
	
	echo caption, creation_date, file_name, file_size, file_type, last_access, last_modified, md5, os, system_id, system_user>>%outputFile%
	for /r "%1" %%a in (*) do (
		SET "folder=%%~pa"
				::caption
				echo|set /p="%%a, ">>%outputFile%
				
				::creation_date
				Setlocal enabledelayedexpansion
				set "wmicname=%%a"
				set "awmicname=!wmicname:\=\\!"
				for /f "delims=" %%g in ('wmic datafile where "name='!awmicname!'" get 'Creation Date' ^| find /i "+"') do (
					set datetime=%%g
					set year=!datetime:~0,4!
					set month=!datetime:~4,2!
					set day=!datetime:~6,2!
					set hour=!datetime:~8,2!
					set minute=!datetime:~10,2!
					set second=!datetime:~12,2!
					set standard=!year!-!month!-!day! !hour!:!minute!:!second!
					echo|set /p=!standard!,>>%outputFile%
				)

				::file_name
				echo|set /p="%%~na, ">>%outputFile%
				
				::file_size
				for /f "delims=" %%g in ('wmic datafile where "name='!awmicname!'" get 'Size' ^| findstr /r "[0-9][0-9]*"') do (
					set size=%%g
					set /A asize=!size: =!
					echo|set /p=!asize!,>>%outputFile%
				)
				
				::file_type
				set "x=%%~xa"
				set "ax=!x:.=!"
				echo|set /p=!ax!, >>%outputFile%
				
				::last_access
				for /f "delims=" %%g in ('wmic datafile where "name='!awmicname!'" get 'Last Accessed' ^| find /i "+"') do (
					set datetime=%%g
					set year=!datetime:~0,4!
					set month=!datetime:~4,2!
					set day=!datetime:~6,2!
					set hour=!datetime:~8,2!
					set minute=!datetime:~10,2!
					set second=!datetime:~12,2!
					set standard=!year!-!month!-!day! !hour!:!minute!:!second!
					echo|set /p=!standard!,>>%outputFile%
				)
				
				::last_modified
				for /f "delims=" %%g in ('wmic datafile where "name='!awmicname!'" get 'Last Modified' ^| find /i "+"') do (
					set datetime=%%g
					set year=!datetime:~0,4!
					set month=!datetime:~4,2!
					set day=!datetime:~6,2!
					set hour=!datetime:~8,2!
					set minute=!datetime:~10,2!
					set second=!datetime:~12,2!
					set standard=!year!-!month!-!day! !hour!:!minute!:!second!
					echo|set /p=!standard!,>>%outputFile%
				)
				
				::md5
				for /f "usebackq delims=" %%g in (`certUtil -hashfile "%%a" MD5 ^| find /v "hash" ^| find /v "\n"`) do (
					IF !asize!==0 (
						echo|set /p="NULL, ">>%outputFile%
					) ELSE (
						echo|set /p=%%g, >>%outputFile%
					)
				)

				::os
				echo|set /p=%OS%,>>%outputFile%
				
				::system_id
				set AUUID=!UUID: =!
				echo|set /p=!AUUID!,>>%outputFile%
				
				::system_user
				echo %USERNAME%>>%outputFile%
				
				endlocal
    )
echo Ending time %TIME%