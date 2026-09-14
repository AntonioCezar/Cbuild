#!/bin/bash

# aqui jaz o script para ativar/desativar o modo verboso.

out_text=$(mktemp -p "$command_log_dir" 07_verbose.XXXXXX)

parametro="$1" # lê $1
ativou=false
case "$parametro" in
    "T" | "true" | "t" | "True")
        ativou=true 
        ;;
    "F" | "false" | "f" | "False")
        echo "Modo Verboso Desativado" >> $out_text
        {
        echo "export verbose_mode=false"
        echo "export debug_mode=$debug_mode"
        } > "$config_file"
        exit 0
        ;;
    "")
        echo "Nenhum Argumento Digitado No Comando" >> $out_text
        echo "Digite ./cbuild verboso T para ativar o modo debug e ./cbuild verboso F para desativar" #verifica se $1 não existe
        exit 1
        ;;
    *)
        echo "O Comando Digitado Não Existe" >> $out_text
        echo "Esse comando não existe, digite um comando válido" #verifica se $1 é algo aleatório 
        exit 1
        ;;
esac



#ver se o modo debug esté ativado e está tentando ativar o modo verboso
if [[ $debug_mode == "true" && $ativou == "true" ]]; then
    read -p "Você deseja desativar o modo debug para ativar o modo verboso? (s/n)" resposta
        case "$resposta" in
            "s" | "S" | "y" | "Y" | "sim" | "Sim" | "yes" | "Yes" )
                echo "Modo Debug Desativado, Modo Verboso Ativado" >> $out_text
                echo "Modo debug desativado e modo verboso ativado"
                {
                echo "export verbose_mode=true"
                echo "export debug_mode=false"
                } > "$config_file"
                ;;
            "n" | "N" | "no" | "No" | "não" | "Não" | "nao" | "Nao" )
                echo "Operação Cancelada: O Modo Verboso Não Pode Ser Ativado Junto Com o Debug" >> $out_text
                echo "Operação cancelada: você não pode ativar o modo verboso com o modo debug ativado"
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
    echo "Modo Verboso Ativado Com Sucesso!" >> $out_text
    {
    echo "export verbose_mode=true"
    echo "export debug_mode=$debug_mode"
    } > "$config_file"
    echo "Modo verboso ativado com sucesso!"
    exit 0
fi
