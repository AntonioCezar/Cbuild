#!/bin/bash

#aqui jaz a função clean que limpa os arquivos temp criados e o arquivo de compilação
#clean() apaga os arquivos de build
#cleanAll() apaga os arquivos de build e apaga os logs

clean() {
    #recebe o parâmetro diretório
    dir=$1

    #verifico se o diretório  existe
    if [[ ! -d "$dir" ]]; then
        echo "Diretório '$dir'  Não Existe." >> "$out_text"
        echo "Diretório '$dir' não existe."
        return 1
    fi

    #verifico se tenho permissões para acessar o diretório
    if [[ ! -r "$dir" || ! -x "$dir" || ! -w "$dir" ]]; then
        echo "Sem Permissão Para Acessar o Conteúdo Da Pasta '$dir'." >> "$out_text"
        echo "Erro: permissão negada ao acessar '$dir'."
        return 1
    fi

    if [[ $debug_mode == true ]]; then 
        echo "Debug: Programa verificou se o diretório '$dir' existe." 
    fi

    if [[ $debug_mode == true ]]; then 
        echo "Debug: Programa verificou se existe permissão para acessar '$dir'." 
    fi

    #verifica se o diretório não está vazio
    if [[ -n "$(find "$dir" -mindepth 1 -print -quit)" ]]; then

        if [[ $debug_mode == true ]]; then 
            echo "Debug: Programa concluiu que o diretório '$dir' não está vazio." 
        fi

        #apaga os arquivos, se houver erro, manda para o $out_text
        find "$dir" -mindepth 1 -delete 2>> "$out_text"

        if [[ $verbose_mode == true ]]; then 
            echo "Verboso: Programa apagou os arquivos da pasta '$dir'."
        fi

        #verifica se a pasta ficou vazia mesmo
        if [[ -z "$(find "$dir" -mindepth 1 -print -quit)" ]]; then
            echo "Os Arquivos Da Pasta '$dir' Foram Apagados Com Sucesso." >> $out_text
            echo "Os arquivos da pasta '$dir' foram apagados com sucesso."
            return 0
        else
            echo "Não foi possível apagar os arquivos de '$dir'. Acesse o log para mais informações."
            return 1
        fi


    else 
        if [[ $debug_mode == true ]]; then 
            echo "Debug: Programa concluiu que o diretório '$dir' está vazio." 
        fi

        echo "Não Há Nenhum Arquivo Na Pasta '$dir' Para Apagar!" >> $out_text
        echo "Não há arquivos na pasta '$dir' para apagar."
        return 0
    fi
}


cleanAll() {
    #apaga os arquivos de build
    clean "$build_dir"

    #status 0 ou 1 da execução de clean
    exit_code=$?

    if [[ $verbose_mode == true ]]; then 
        echo "Verboso: Programa iniciou a limpeza em '$logs_dir'."
    fi

    #só apaga os logs se foi possível apagar os arguivos de build
    if [[ $exit_code -eq 0 ]]; then
        clean "$logs_dir"
    else 
        echo "Falha Ao Limpar '$build_dir'. Os Logs Foram Preservados." >> $out_text
        echo "Falha ao limpar '$build_dir'. Os logs foram preservados."
        return 1
    fi
}

#deixa o parâmetro do usuário em caixa baixa
clean_mode="${1,,}"

#cria arquivo temp de erro
out_text=$(mktemp -p "$command_log_dir" 01_clean.XXXXXX)

build_dir="./build"
logs_dir="./logs"

if [[ $verbose_mode == true ]]; then 
    echo "Verboso: Programa inicou a limpeza dos arquivos temporários"
    echo ""
    echo "======== Limpeza em Andamento ========"
    echo ""
fi

case "$clean_mode" in
    "all" )
        #limpa build e logs
        cleanAll
        exit $? #propaga a saída do return
        ;;
    "" )
        #limpa build
        clean "$build_dir"
        exit $? #propaga a saída do return
        ;;
    *)
        echo "O parâmetro -$clean_mode- não existe."
        ;;
esac

if [[ $verbose_mode == true ]]; then 
    echo "Verboso: Programa terminou a limpeza dos arquivos temporários"
    echo ""
    echo "======== Limpeza Finalizada ========="
    echo ""
fi