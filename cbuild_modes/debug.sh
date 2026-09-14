#!/bin/bash

# aqui jaz o script para ativar/desativar o modo debug.

out_text=$(mktemp -p "$command_log_dir" 06_debug.XXXXXX)

parametro="$1" # lê $1
ativou=false
case "$parametro" in
    "T" | "true" | "t" | "True")
        ativou=true 
        ;;
    "F" | "false" | "f" | "False")
        echo "Modo Debug Foi Desativado" >> $out_text
        echo "Modo debug foi desaticado"
        {
        echo "export verbose_mode=$verbose_mode"
        echo "export debug_mode=false"
        } > "$config_file"
        exit 0
        ;;
    "")
        echo "Nenhum Argumento Digitado No Comando" >> $out_text
        echo "Digite ./cbuild debug T para ativar o modo debug e ./cbuild debug F para desativar" #verifica se $1 não existe
        exit 1
        ;;
    *)
        echo "O Comando Digitado Não Existe" >> $out_text
        echo "Esse comando não existe, digite um comando válido" #verifica se $1 é algo aleatório 
        exit 1
        ;;
esac



#ver se o modo verboso esté ativado e está tentando ativar o modo debug
if [[ $verbose_mode == "true" && $ativou == "true" ]]; then
    read -p "Você deseja desativar o modo verboso para ativar o modo debug? (s/n)" resposta
        case "$resposta" in
            "s" | "S" | "y" | "Y" | "sim" | "Sim" | "yes" | "Yes" )
                echo "Modo Verboso Desativado, Modo Debug Ativado" >> $out_text
                echo "Modo verboso desativado e modo debug ativado"
                {
                echo "export verbose_mode=false"
                echo "export debug_mode=true"
                } > "$config_file"
                exit 0
                ;;
            "n" | "N" | "no" | "No" | "não" | "Não" | "nao" | "Nao" )
                echo "Operação Cancelada: O Modo Debug Não Pode Ser Ativado Junto Com o Verboso" >> $out_text
                echo "Operação cancelada: você não pode ativar o modo debug com o modo verboso ativado"
                exit 1
                ;;
            "")
                echo "Não Foi Digitado Nenhum Argumento, Operação Cancelada" >> $out_text
                echo "Não foi digitado nenhum argumento, operação cancelada"
                exit 1
                ;;
            *)
                echo "O Comando Digitado '$resposta' Não Existe" >> $out_text
                echo "O argumento '$resposta' não existe, operação cancelada" 
                exit 1
                ;;
    esac
elif [[ $ativou = "true" ]]; then
    echo "Modo Debug Ativado Com Sucesso!" >> $out_text
    {
    echo "export verbose_mode=$verbose_mode"
    echo "export debug_mode=true"
    } > "$config_file"
    echo "Modo debug ativado com sucesso!"
    exit 0
fi
