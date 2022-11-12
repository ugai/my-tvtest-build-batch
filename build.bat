git submodule update --init --recursive

set BAT_DIR=%~dp0

:: VS2022 Community
::   - MSVC v142 - VS 2019 C++ x64/x86 ビルドツール
::   - Spectre の軽減策を含む v142 ビルドツール用 C++ v14.29 (16.11) MFC (x86およびx64)

call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
pushd "%BAT_DIR%"
mkdir build
pushd src

:: TVTest
msbuild .\TVTest\src\LibISDB\Projects\LibISDB.sln /p:Configuration=Release /p:Platform=x64
msbuild .\TVTest\src\TVTest.sln /p:Configuration=Release /p:Platform=x64
copy /Y .\TVTest\src\x64\Release\TVTest.exe ..\build
copy /Y .\TVTest\src\x64\Release\TVTest_Image.dll ..\build
copy /Y .\TVTest\src\x64\Release\TVTest.chm ..\build

:: TVTest Plugins
msbuild .\TVTest\sdk\Samples\Samples.sln /p:Configuration=Release /p:Platform=x64
mkdir ..\build\Plugins
copy /Y .\TVTest\sdk\Samples\x64\Release\*.tvtp ..\build\Plugins
copy /Y .\TVTest\sdk\Samples\x64\Release\HDUSRemocon_KeyHook.dll ..\build\Plugins
copy /Y .\TVTest\sdk\TVTestSDK.txt ..\build\Plugins
copy /Y .\TVTest\data\* ..\build
copy /Y .\TVTest\doc\* ..\build

:: TVTestVideoDecoder
msbuild .\TVTestVideoDecoder\src\TVTestVideoDecoder.sln /p:Configuration=Release /p:Platform=x64
copy /Y .\TVTestVideoDecoder\src\x64\Release\TVTestVideoDecoder.ax ..\build

:: CasProcessor
msbuild .\CasProcessor\CasProcessor.sln /p:Configuration=Release /p:Platform=x64
copy /Y .\CasProcessor\x64\Release\*.tvtp ..\build\Plugins

:: TVCas
msbuild .\TvCas\TvCas.sln /p:Configuration=Release /p:Platform=x64
copy /Y .\TvCas\x64\Release\*.tvcas ..\build

:: BonDriver (PT3)
msbuild .\BonDriver_PT3-ST\BonDriver_PT3.sln /p:Configuration=Release /p:Platform=x64
copy /Y .\BonDriver_PT3-ST\Release\x64\BonDriver_PT3.dll ..\build\BonDriver_PT3-S0.dll
copy /Y .\BonDriver_PT3-ST\Release\x64\BonDriver_PT3.dll ..\build\BonDriver_PT3-S1.dll
copy /Y .\BonDriver_PT3-ST\Release\x64\BonDriver_PT3.dll ..\build\BonDriver_PT3-T0.dll
copy /Y .\BonDriver_PT3-ST\Release\x64\BonDriver_PT3.dll ..\build\BonDriver_PT3-T1.dll
copy /Y .\BonDriver_PT3-ST\Release\x64\PT3Ctrl.exe ..\build
copy /Y .\BonDriver_PT3-ST\BonDriver_PT3-T.ChSet.txt ..\build
copy /Y .\BonDriver_PT3-ST\BonDriver_PT3-S.ChSet.txt ..\build
copy /Y .\BonDriver_PT3-ST\BonDriver_PT3-ST.ini ..\build

:: NicoJK
msbuild .\NicoJK\NicoJK.sln /p:Configuration=Release /p:Platform=x64 /p:PlatformToolset=v142
copy /Y .\NicoJK\x64\Release\jkimlog.exe ..\build\Plugins
copy /Y .\NicoJK\x64\Release\NicoJK.tvtp ..\build\Plugins
copy /Y .\NicoJK\NicoJK.ini ..\build\Plugins

:: NicoJK jkcnsl
pushd jkcnsl
dotnet publish -c Release -r win10-x86 /p:PublishSingleFile=true /p:PublishTrimmed=true
popd
timeout /T 5
copy /Y .\jkcnsl\bin\Release\netcoreapp3.1\win10-x86\publish\jkcnsl.exe ..\build

popd
echo END
pause
