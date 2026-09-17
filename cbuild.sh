#!/bin/bash

# Aqui jaz o código principal para o funcionamento do programa.

# ainda tem que adicionar uma procura profunda no cbuild, por enquanto ele assume que o usuário está na pasta que o cbuild está localizado, mas pode ser que não esteja, nesse caso devemos achar os comandos de forma recursiva.

#Deixa o runtime mais legível
get_runtime() 
{
    local runtime_ns=$1

    local all_sec=$(( runtime_ns / 1000000000 ))
    local milisec=$(( runtime_ns / 1000000 % 1000 ))

    local min=$(( all_sec / 60  ))
    local sec=$(( all_sec % 60 ))

    if [[ $min -gt 0 ]]; then
        printf "%dm%ds%03dms" "$min" "$sec" "$milisec"
    else
        printf "%ds%03dms" "$sec" "$milisec"
fi
}

#Executa os comandos e registra o runtime
run_with_timing()
{
    local log_label="$1"                                #Armazena o primeiro parâmetro. Exemplo: "Build", "Clean"
    shift                                               #"Pula apenas o primeiro parâmetro", por exemplo:                                   

    local start=$(date +%s%N)                           #Registra o início da execução
    "$@"                                                #Executa o parâmetro que sobrou como se fosse um comando

    local exit_code=$?
    local end=$(date +%s%N)                             #Registra o fim da execução

    local runtime_ns=$(( (end - start) ))               #Armazena o runtime
    local runtime=$(get_runtime "$runtime_ns")          #Formata o runtime

    "$caminho_cbuild"/cbuild_funcs/logs.sh "$log_label" "$exit_code" "$comando_user" "$runtime"

    return "$exit_code"
}

export config_file="./.cbuild_config"

if [[ -f "$config_file" ]]; then
    source "$config_file"
else
    {
    echo "export verbose_mode=false"
    echo "export debug_mode=false"
    echo 'export default_name="main"'
    } > "$config_file"
    source "$config_file"
fi

export command_log_dir=$(mktemp -d) # cria uma pasta temporaria global para o resultado das execuções dos comandos

trap 'rm -rf "$command_log_dir"' EXIT # deleta a pasta temporaria de resultados dos comandos

if [[ "$#" -eq 0 ]]; then
    echo ""
    echo "#------------------------------------------------#"
    echo "  Seja bem-vindo ao cbuild, seu compilador de c!"
    echo "#------------------------------------------------#"
    echo ""
    echo "Para utilizar o cbuild selecione um dos nossos comandos:"
    echo ""
    echo "build [b] <Diretório> <Escolha um Nome para o Executável> - Compila todas as mudanças detectadas do seu programa .c"s
    echo "clean [c] - Limpa os artefatos da compilação"
    echo "clean [c] all - Limpa os artefatos da compilação e todos os logs"
    echo "run [r] - Roda seu programa .c a partir do arquivo compilado no comando build"
    echo "rebuild [rb] <Diretório> <Escolha um Nome para o Executável> - re-compila seu programa limpando todos os arquivos temp e cria um novo arquivo de execução"
    echo "info [i] <Diretório> - Exibe algumas informações importantes sobre o seu programa"
    echo ""
    echo "Escreva: cbuild (comando) [opções] para executar os comandos desejados"
    echo ""
fi

# acima está a interface principal do programa que aparece quando ./cbuild é rodado

comando_executado="$1" # parâmetro colocado pelo usuário

comando_user="$0 $*"

caminho_cbuild="${0%/*}"

case "$comando_executado" in
    "build" | "Build" | "b" | "B")
        run_with_timing "Build" "$caminho_cbuild"/cbuild_funcs/build.sh "$2" "$3" 
        ;;
    "clean" | "Clean" | "c" | "C" )
        run_with_timing "Clean" "$caminho_cbuild"/cbuild_funcs/clean.sh "$2"
        ;; 
    "run" | "Run" | "r" | "R")
        run_with_timing "Run" "$caminho_cbuild"/cbuild_funcs/run.sh
        ;;
    "rb" | "rebuild" | "Rebuild" | "ReBuild" | "RB")
        run_with_timing "Rebuild" "$caminho_cbuild"/cbuild_funcs/rebuild.sh "$2" "$3"
        ;;
    "info" | "Info" | "i" | "I")
        run_with_timing "Info" "$caminho_cbuild"/cbuild_funcs/info.sh "$2"
        ;;
    "verboso" | "Verboso" | "v" | "V" | "verbose" | "Verbose")
        run_with_timing "Verboso" "$caminho_cbuild"/cbuild_modes/verbose.sh "$2"
        ;;
    "debug" | "Debug" | "d" | "D")
        run_with_timing "Debug" "$caminho_cbuild"/cbuild_modes/debug.sh "$2"
        ;;
    "")
        ;;
    *)
        echo "O Comando "$comando_executado" Não Faz Parte Dos Comandos Incluidos No Cbuild"
        ;;
esac

# acima temos os cases para cada parâmetro colocado pelo usuário, por exemplo, ./cbuild b entra na case de build do programa
