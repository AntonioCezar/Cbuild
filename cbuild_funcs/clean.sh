#!/bin/bash

#aqui jaz a função clean que limpa os arquivos temp criados e o arquivo de compilação
#clean() apaga os arquivos de build
#cleanAll() apaga os arquivos de build e apaga os logs

#deixa o parâmetro do usuário em caixa baixa
clean_mode="${1,,}"

#cria arquivo temp de erro
out_text=$(mktemp -p "$command_log_dir" 01_clean.XXXXXX)

build_dir="./build"
logs_dir="./logs"

clean() {

    if [[ $verbose_mode == true ]]; then 
        echo "Programa inicou a limpeza dos arquivos temporários"
        echo ""
        echo "======== Limpeza em Andamento ========"
        echo ""
    fi

    if [[ $verbose_mode == true ]]; then 
        echo "Programa iniciou a limpeza em'$build_dir'"
    fi

    #verifico se o diretório build existe
    if [[ ! -d "$build_dir" ]]; then
        echo "Diretório '$build_dir'  Não Existe." >> "$out_text"
        echo "Diretório '$build_dir' não existe."
        return 1
    fi

    if [[ $debug_mode == true ]]; then 
        echo "Debug: Programa verificou se o diretório '$build_dir' existe." 
    fi

    #verifico se tenho permissões para acessar o diretório build
    if [[ ! -r "$build_dir" || ! -x "$build_dir" ]]; then
        echo "Sem Permissão Para Acessar o Conteúdo Da Pasta '$build_dir'." >> "$out_text"
        echo "Erro: permissão negada ao acessar '$build_dir'"
        return 1
    fi

    if [[ $debug_mode == true ]]; then 
        echo "Debug: Programa verificou se existe permissão para acessar '$build_dir'." 
    fi

    #verifica se o diretório build não está vazio
    if [[ -n "$(find "$build_dir" -mindepth 1 -print -quit)" ]]; then 

        if [[ $debug_mode == true ]]; then 
            echo "Debug: Programa concluiu que o diretório '$build_dir' não está vazio." 
        fi

        find "$build_dir" -mindepth 1 -delete 2>> "$out_text"

        #verifica se a pasta build ficou vazia mesmo
        if [[ -z "$(find "$build_dir" -mindepth 1 -print -quit)" ]]; then 

            if [[ $verbose_mode == true ]]; then 
                echo "Programa apagou os arquivos da pasta '$build_dir'"
            fi

            echo "Os Arquivos Da Pasta '$build_dir' Foram Apagados Com Sucesso" >> $out_text
            echo "Os arquivos build foram apagados com sucesso"
            return 0
        else
            echo "Não foi possível apagar os arquivos de '$build_dir'. Acesse o log para mais informações." 
            return 1
        fi

    else 

        if [[ $debug_mode == true ]]; then 
            echo "Debug: Programa concluiu que o diretório '$build_dir' está vazio." 
        fi

        echo "Não Há Nenhum Arquivo Na Pasta '$build_dir' Para Apagar!" >> $out_text
        echo "Não há arquivos na pasta '$build_dir' para apagar"
        return 0
    fi
}

cleanAll() {
    #apaga os arquivos de build
    clean

    exit_code=$?

    if [[ $verbose_mode == true ]]; then 
        echo "Programa iniciou a limpeza em'$logs_dir'"
    fi

    #só apaga os logs se foi possível apagar os arguivos de build
    if [[ $exit_code -eq 0 ]]; then

        if [[ $debug_mode == true ]]; then 
            echo "Debug: Programa verificou se a limpeza do diretório '$build_dir' foi bem-sucedida." 
        fi

        #verifico se o diretório logs existe
        if [[ ! -d "$logs_dir" ]]; then
            echo "Diretório '$logs_dir'  Não Existe." >> "$out_text"
            echo "Diretório '$logs_dir' não existe."
            return 1
        fi

        if [[ $debug_mode == true ]]; then 
            echo "Debug: Programa verificou se o diretório '$logs_dir' existe." 
        fi

        #verifico se tenho permissões para acessar o diretório logs
        if [[ ! -r "$logs_dir" || ! -x "$logs_dir" ]]; then
            echo "Sem Permissão Para Acessar o Conteúdo Da Pasta '$logs_dir'." >> "$out_text"
            echo "Erro: permissão negada ao acessar '$logs_dir'"
            return 1
        fi

        if [[ $debug_mode == true ]]; then 
            echo "Debug: Programa verificou se existe permissão para acessar '$build_dir'." 
        fi

        #verifica se o diretório não está vazio
        if [[ -n "$(find "$logs_dir" -mindepth 1 -print -quit)" ]]; then

            if [[ $debug_mode == true ]]; then 
                echo "Debug: Programa concluiu que o diretório '$logs_dir' não está vazio." 
            fi

            #apaga os logs, se houver erro, manda para o $out_text
            find "$logs_dir" -mindepth 1 -delete 2>> "$out_text"

            if [[ $verbose_mode == true ]]; then 
                echo "Programa apagou os logs da pasta '$logs_dir'"
            fi

            #verifica se a pasta logs ficou vazia mesmo
            if [[ -z "$(find "$logs_dir" -mindepth 1 -print -quit)" ]]; then
                echo "Os Arquivos Da Pasta '$logs_dir' Foram Apagados Com Sucesso" >> $out_text
                echo "Os logs foram apagados com sucesso"
                return 0
            else
                echo "Não foi possível apagar os arquivos de '$logs_dir'. Acesse o log para mais informações."
                return 1
            fi


        else 
            if [[ $debug_mode == true ]]; then 
                echo "Debug: Programa concluiu que o diretório '$logs_dir' está vazio." 
            fi

            echo "Não Há Nenhum Arquivo Na Pasta '$logs_dir' Para Apagar!" >> $out_text
            echo "Não há arquivos na pasta '$logs_dir' para apagar"
            return 0
        fi
    
    else 
        echo "Falha Ao Limpar '$build_dir'. Os Logs Foram Preservados" >> $out_text
        echo "Falha ao limpar '$build_dir'. Os logs foram preservados"
        return 1
    fi

}

case "$clean_mode" in
    "all" )
        cleanAll
        ;;
    "" )
        clean
        ;;
    *)
        echo "O parâmetro -$clean_mode- não existe."
        ;;
esac

if [[ $verbose_mode == true ]]; then 
    echo "Programa terminou a limpeza dos arquivos temporários"
    echo ""
    echo "======== Limpeza Finalizada ========="
    echo ""
fi