#!/bin/bash

#aqui jaz a função clean que limpa os arquivos temp criados e o arquivo de compilação
#clean() apaga os arquivos de build
#cleanAll() apaga os arquivos de build e apaga os logs


#cria arquivo temp de erro
out_text=$(mktemp -p "$command_log_dir" 01_clean.XXXXXX)

build_dir="./build"
logs_dir="./logs"

clean() {

    #verifico se o diretório build existe
    if [[ ! -d "$build_dir" ]]; then
        echo "Diretório '$build_dir'  Não Existe." >> "$out_text"
        echo "Diretório '$build_dir' não existe."
        return 1
    fi

    #verifico se tenho permissões para acessar o diretório build
    if [[ ! -r "$build_dir" || ! -x "$build_dir" ]]; then
        echo "Sem Permissão Para Acessar o Conteúdo Da Pasta '$build_dir'." >> "$out_text"
        echo "Erro: permissão negada ao acessar '$build_dir'"
        return 1
    fi

    #verifica se o diretório build não está vazio
    if [[ -n "$(find "$build_dir" -mindepth 1 -print -quit)" ]]; then 

        #apaga os arquivos de build, se houver erro, manda para o $out_text
        if find "$build_dir" -mindepth 1 -delete 2>> "$out_text"; then
            echo "Os Arquivos Da Pasta '$build_dir' Foram Apagados Com Sucesso" >> $out_text
            echo "Os arquivos build foram apagados com sucesso"
            return 0
        else
            echo "Não foi possível apagar os arquivos de '$build_dir'. Acesse o log para mais informações." 
            return 1
        fi

    else 
        echo "Não Há Nenhum Arquivo Na Pasta '$build_dir' Para Apagar!" >> $out_text
        echo "Não há arquivos na pasta '$build_dir' para apagar"
        return 0
    fi
}

cleanAll() {
    #apaga os arquivos de build
    clean

    exit_code=$?

    #só apaga os logs se foi possível apagar os arguivos de build
    if [[ $exit_code -eq 0 ]]; then

        #verifico se o diretório logs existe
        if [[ ! -d "$logs_dir" ]]; then
            echo "Diretório '$logs_dir'  Não Existe." >> "$out_text"
            echo "Diretório '$logs_dir' não existe."
            return 1
        fi

        #verifico se tenho permissões para acessar o diretório logs
        if [[ ! -r "$logs_dir" || ! -x "$logs_dir" ]]; then
            echo "Sem Permissão Para Acessar o Conteúdo Da Pasta '$logs_dir'." >> "$out_text"
            echo "Erro: permissão negada ao acessar '$logs_dir'"
            return 1
        fi

        #verifica se o diretório não está vazio
        if [[ -n "$(find "$logs_dir" -mindepth 1 -print -quit)" ]]; then

            #apaga os logs, se houver erro, manda para o $out_text
            if find "$logs_dir" -mindepth 1 -delete 2>> "$out_text"; then
                echo "Os Arquivos Da Pasta '$logs_dir' Foram Apagados Com Sucesso" >> $out_text
                echo "Os logs foram apagados com sucesso"
                return 0
            else
                echo "Não foi possível apagar os arquivos de '$logs_dir'. Acesse o log para mais informações."
                return 1
            fi

        else 
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

#deixa o parâmetro em caixa baixa
clean_mode="${1,,}"

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