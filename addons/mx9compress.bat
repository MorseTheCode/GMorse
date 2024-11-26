@echo off
setlocal enabledelayedexpansion

:: Tamanho de cada parte em bytes (exemplo: 100MB por parte)
set "PART_SIZE=90m"

:: Caminho do diretório atual (onde o script está)
set "BASE_DIR=%~dp0"

:: Navega pelas pastas no mesmo diretório do script
for /d %%D in ("%BASE_DIR%\*") do (
    echo Processando pasta: %%D
    pushd "%%D"

    :: Para cada arquivo na pasta
    for %%F in (*) do (
        :: Nome do arquivo sem extensão
        set "FILE_NAME=%%~nF"
        set "EXTENSION=%%~xF"

        echo Comprimindo arquivo: %%F
        7z.exe a -t7z -mx=9 -v%PART_SIZE% "!FILE_NAME!!EXTENSION!.bz2" "%%F"

        :: Remove o arquivo original
        if exist "!FILE_NAME!!EXTENSION!.bz2" (
            del "%%F"
            echo Arquivo original %%F removido após compressão.
        )
    )
    popd
)
echo [COMPLETO] Todos os arquivos foram processados.
pause
