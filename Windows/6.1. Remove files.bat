CD /D %WINDIR%

:: "C:\Windows\SysWOW64\WerFault.exe"
:: "C:\Windows\System32\WerFault.exe"
:: "C:\Windows\System32\CompatTelRunner.exe"

FOR %%F IN (SysWOW64\WerFault.exe,System32\WerFault.exe,System32\CompatTelRunner.exe) DO (
	TAKEOWN /F %%F
	ICACLS %%F /grant %USERNAME%:F
	DEL /A %%F.bak
	REN %%F %%~nxF.bak
)

PAUSE
