
set BUILD_DIR=build
mkdir %BUILD_DIR%

REM  Code Build
call tsc
copy src\index.html %BUILD_DIR%
mkdir %BUILD_DIR%\lib
copy lib\*.js %BUILD_DIR%\lib

REM  Art Assets
mkdir %BUILD_DIR%\atlases
copy assets\atlases\*.png %BUILD_DIR%\atlases
copy assets\atlases\*.json %BUILD_DIR%\atlases
