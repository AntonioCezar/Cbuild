#!/bin/bash

# aqui jaz a função info que mostra informações importantes sobre o cbuild e o programa do usuário

out_text=$(mktemp -p "$command_log_dir" 04_info.XXXXXX)
program_folder="$program_path" # aqui vai o diretório que o user vai passar ./cbuild b <dir>

if [[ -z "$program_folder" ]]; then
    echo "Diretório '$program_folder' Que Foi Indicado Pelo Usuário Não Existe! (Argumento Vazio)" >> $out_text
    echo "Erro na execução do comando info - Forneça o diretório do seu programa como argumento!"
    exit 1
fi

if [[ ! -d $program_folder ]]; then # checagem para ver se o dir passado pelo usuario existe
    echo "Diretório '$program_folder' Não Existe!" >> $out_text
    echo "Erro na execução do comando info - Diretório '$program_folder' não existe!"
    exit 1
fi

if [[ $debug_mode == true ]]; then
    echo "Debug: Programa testou se a pasta '$program_folder' existe." 
fi

echo ""
echo "================================================================"
echo "               CBUILD - PAINEL DE INFORMAÇÕES                   "
echo "================================================================"
echo ""
echo "    Este painel exibe o status atual do seu projeto em C."
echo ""
echo ""

# encontra e calcula a quatidade de arquivos do projeto 

echo "------------------- MÉTRICAS DO CÓDIGO ------------------------"
echo ""

if [[ $verbose_mode == true ]]; then 
    echo "Verboso: Encontrando a quantidade de arquivos do projeto com o comando externo - find \"$1\" -type f \( -name "*.c" -o -name "*.h" \) | wc -l"
    echo ""
fi

qtd_arquivos_proj=$(find "$1" -type f \( -name "*.c" -o -name "*.h" \) | wc -l)
echo "Quantidade de arquivos do projeto: $qtd_arquivos_proj"

if [[ $debug_mode == true ]]; then 
    echo "Debug: Programa preencheu a variável 'qtd_arquivos_proj' com o valor '$qtd_arquivos_proj'."
    echo ""
fi

if [[ $verbose_mode == true ]]; then 
    echo "Verboso: Encontrando a quantidade de linhas absoluta de código com o comando externo - find \"$1\" -type f \( -name \"*.c\" -o -name \"*.h\" \) | xargs wc -l | tail -n 1 | awk '{print \$1}'"
    echo ""
fi

# encontra todos os arquivos que terminam em .c e .h e calcula a soma de todas as linhas de código presentes nesses arquivos, sem exceção
qtd_linhas=$(find "$1" -type f \( -name "*.c" -o -name "*.h" \) | xargs wc -l | tail -n 1 | awk '{print $1}')
echo "Quantidade absoluta de linhas de código: $qtd_linhas"

if [[ $debug_mode == true ]]; then 
    echo "Debug: Programa preencheu a variável 'qtd_linhas' com o valor '$qtd_linhas'."
    echo ""
fi

# geração do status de compilação

echo ""
echo ""
echo "------------------- STATUS DE COMPILAÇÃO ----------------------"
echo ""

if [[ $verbose_mode == true ]]; then 
    echo "Verboso: Utilizando comandos externos - 'find, stat, date' em conjunto com flags para localizar arquivos executáveis"
    echo ""
fi

# verifica se existe uma pasta build 
if [[ ! -d "$program_folder/build" ]]; then
    echo "Nenhum arquivo foi compilado"

# verifica se a pasta build possui algum arquivo executável compilado
elif [[ -z "$(find $program_folder/build -mindepth 1 -maxdepth 1 -type f -executable -print -quit)" ]]; then
    echo "Não há arquivo executável compilado"

else 
    # encontra o arquivo executavel na pasta build 
    executavel=$(find $program_folder/build -maxdepth 1 -type f -executable | head -n 1)
    tamanho_executavel=$(stat -c %s "$executavel")
    data_compilacao=$(date -r "$executavel" "+%d/%m/%Y às %H:%M:%S")

    echo "Tamanho do executável: $tamanho_executavel bytes"
    echo "Data de compilação: $data_compilacao"
    
fi

if [[ $debug_mode == true ]]; then 
    echo "Debug: Programa testou se a pasta $program_folder/build existe, se ela contém arquivos e se existe um arquivo executável."
    echo ""
fi

# data de execução do arquivo presente no projeto 

echo ""
echo ""
echo "----------------- HISTÓRICO DE EXECUÇÃO ---------------------"
echo ""

if [[ $verbose_mode == true ]]; then 
    echo "Verboso: Utilizando comandos externos - 'find, grep, date' em conjunto com flags para descobrir último comando executado"
    echo ""
fi

# verifica se a pasta logs existe no diretório
if [[ ! -d "$program_folder/logs" ]]; then 
    echo "Nenhum comando foi executado"

# verifica se a pasta logs possui algum arquivo
elif [[ -z "$(find $program_folder/logs -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
    echo "Não há registro de comandos executados"

else 
    # o arquivo log run mais recente que teve a operação bem-sucedida
    log_run=$(grep -l -i "run" $(ls -t $program_folder/logs/* 2>/dev/null) | xargs -r grep -L "Operação Mal-Sucedida" | head -n 1)

    if [[ -z "$log_run" ]]; then
        echo "Não há registro de execução"
    
    else 
        data_exec=$(date -r "$log_run" "+%d/%m/%Y às %H:%M:%S")
        echo "Última data de execução: $data_exec"
    fi
fi

echo ""
echo "================================================================"
echo ""

if [[ $debug_mode == true ]]; then
    echo "Debug: Programa conseguiu retornar todas as informações com sucesso." 
fi

echo "Comando Executado com Sucesso!" >> $out_text