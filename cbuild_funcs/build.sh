#!/bin/bash

# aqui jaz a função build completa

# --- logs ---

out_text=$(mktemp -p "$command_log_dir" 02_build.XXXXXX) # reserva espaço para uma variavel temporaria de erro dentro do diretório command_log_dir com o nome build e um padrão alfanumérico aleatório 

# --- função para procurar os arquivos modificados ---

deep_compiler() {

    local file
    local arq_mod=0
    local file_detec=0

    mkdir -p ./build/build_parts

    if [[ $verbose_mode == true ]]; then 
        echo "Verboso: Programa começou a compilar os arquivos"
        echo ""
        echo "======== Compilação em Andamento ========"
        echo ""
    fi

    while IFS= read -r file; do # o IFS junto com o read -r deixam o texto passado para file da exata forma que ele foi passado para evitar erros

        if [[ ! -z $file ]]; then # se existe um file .c adiciona no contador
            file_detec=$((file_detec + 1))
        fi

        local formated_file=$(basename "$file" .c) # formata o nome do arquivo para procurar o correspondente .o

        if [[ "$file" -nt "./build/build_parts/${formated_file}.o" ]]; then # vê se o arquivo de compilação já existe e, se sim, se o arquivo .c é mais novo que o arquivo de compilação para só compilar o que foi modificado.

            if [[ $debug_mode == true ]]; then 
                echo "Debug: Programa concluiu que $file é mais novo que seu arquivo de compilação." 
            fi

            gcc -c "$file" -o "./build/build_parts/${formated_file}.o" 2>> "$out_text" || return 2 # compila cada file em um arquivo.o, se der erro retorna 2
            arq_mod=$((arq_mod + 1))

            if [[ $verbose_mode == true ]]; then 
                echo "Verboso: Programa compilou $file com o comando 'gcc -c $file -o ./build/build_parts/${formated_file}.o'"
            fi
        else
            if [[ $debug_mode == true ]]; then 
                echo "Debug: Programa concluiu que $file já está atualizado e pulou sua compilação." 
            fi
        fi

    done
    

    if [[ $file_detec -eq 0 ]]; then # detecta se existem ou não files .c
        return 4
    fi

    if [[ $arq_mod -eq 0 && -f "./build/$out_name" ]]; then # detecta se não houve mudanças e se existe um arquivo de execução atual para o programa
        return 3
    fi

    if [[ $debug_mode == true ]]; then 
        echo "Debug: Programa testou se existem arquivos .c e se houveram mudanças neles."
    fi

    out_files=$(find "./build/build_parts" -type f -iname "*.o" | xargs -n 1 | tr '\n' ' ') # procura todos os arquivos .o que acabou de compilar no while

    gcc $out_files -o "./build/$out_name" 2>> "$out_text" || return 2 # compila todos em um só output com o nome escolhido pelo usuário, se der erro retorna 2

    if [[ $verbose_mode == true ]]; then 
        echo "Verboso: Programa compilou $file com o comando 'gcc $out_files -o ./build/$out_name'"
    fi

    if [[ $verbose_mode == true ]]; then 
        echo "Verboso: Programa terminou de compilar os arquivos .c"
        echo ""
        echo "======== Compilação Finalizada ========="
        echo ""
    fi

}

# --- checando se o user passou as infos corretas para o funcionamento do cbuild (e se tem tudo que precisa) ---

program_folder="$1"; # aqui vai o diretório que o user vai passar ./cbuild b <dir>
out_name="$2" # vai ser o nome que o user passar para o comando ./cbuild b <dir> <nome>

if ! command -v gcc >/dev/null 2>&1 ; then # checa se o gcc está instalado na root do sistema (se estiver não retorna nada, para isso que serve o dev/null)
    echo "GCC (GNU Compiler Collection) Não Instalado! Instale O Compilador Para Utilizar o Comando Build" >> "$out_text"
    echo "Erro na execução do comando build - gcc não instalado!"
    exit 1
fi

if [[ $debug_mode == true ]]; then 
    echo "Debug: Programa testou se o usuário tem o gcc instalado."
fi

if [[ ! -d $program_folder ]]; then # checagem para ver se o dir passado pelo usuario existe
    echo "Diretório '$program_folder' Que Foi Indicado Pelo Usuário Não Existe!" >> $out_text
    echo "Erro na execução do comando build - Diretório '$program_folder' não existe!"
    exit 1
fi

if [[ $debug_mode == true ]]; then 
    echo "Debug: Programa testou se o diretório "$program_folder" existe."
fi

if [[ ! -r "$program_folder" || ! -x "$program_folder" || ! -w "$program_folder" ]]; then # verifica se tem permissão para pasta passada
    echo "Sem Permissão Para Acessar o Conteúdo Da Pasta '$program_folder'." >> "$out_text"
    echo "Erro: permissão negada ao acessar '$program_folder'."
    exit 1
fi

if [[ $debug_mode == true ]]; then 
    echo "Debug: Programa testou se tem permissão para acessar "$program_folder"."
fi

if [[ -z $out_name ]]; then # checagem para ver se o user passou o nome do executável
    echo "Nome Do Executável Não Especificado!" >> $out_text
    echo "Erro na execução do comando build - Nome do executável não especificado!"
    exit 1

elif [[ "$out_name" == *.* ]]; then # checagem para ver se nome que o user passou é válido
    echo "Nome Do Executável Não Pode Conter '.'" >> $out_text
    echo "Erro na execução do comando build - Nome do executável não pode conter '.'"
    exit 1
fi

if [[ $debug_mode == true ]]; then
    echo "Debug: Programa testou se o nome do executável é válido." 
fi

if find "$program_folder" -type f -iname "*.c" | deep_compiler; then # procura todos os arquivos .c na pasta do projeto informada pelo usuário e executa o compilador avançado caso encontre arquivos
    echo "O executável '$out_name' foi criado com sucesso!" >> $out_text # caso tudo funcione manda para o log o sucesso
    echo "Comando build executado com sucesso"
    exit 0
else

# ---- Error Handling da Função Deep Compiler ----

    func_status="$?" # guarda o erro da função (se houver)

    if [[ "$func_status" -eq 2 ]]; then # erro na compilação do gcc
        echo "Erro na execução do comando build - Erro na compilação usando comando gcc, veja o log para mais informações"
        exit 1

    elif [[ "$func_status" -eq 3 ]]; then # checagem para ver se houve mudanças nos arquivos .c desde a ultima compilação
        echo "Nenhuma Mudança Detectada Nos Arquivos .c" >> $out_text
        echo "Erro na execução do comando build - Nenhuma mudança detectada nos arquivos .c"
        exit 1

    elif [[ "$func_status" -eq 4 ]]; then # checagem para ver se encontrou algum arquivo .c
        echo "Ausência de Arquivos Fonte Para A Compilação Do Programa .c Na Pasta '$program_folder'" >> $out_text
        echo "Erro na execução do comando build - Nenhum arquivo .c encontrado!"
        exit 1

    else
        echo "Erro desconhecido na execução do comando build, veja o log para mais informações" # caso contrário é um erro desconhecido que vai estar catalogado nos logs
        exit 1
    fi
fi

# -----------------------------