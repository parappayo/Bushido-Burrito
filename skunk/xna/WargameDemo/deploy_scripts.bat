REM  There's a post-build step in Visual Studio to take care of this, but
REM  since it can sometimes be stupid, you can try running this bat file.

xcopy "scripts" "bin\x86\Debug\scripts" /s /i /y
xcopy "scripts" "bin\x86\Release\scripts" /s /i /y
pause

