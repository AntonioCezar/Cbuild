#!/bin/bash

# aqui jaz a função run que roda o programa que foi compilado pelo build

out_text=$(mktemp -p "$command_log_dir" 03_run.XXXXXX)

if [[ $verbose_mode == true ]]; then 
    echo "Programa inicou a execução do comando run"
    echo ""
    echo "======== Run em Andamento ========"
    echo ""
fi

build_dir="./build"

if [[ ! -d "$build_dir" ]]; then
  echo "A Pasta './build' Não Existe, O Programa Não Foi Compilado Anteriormente E Não Contém Executável." >> "$out_text"
  echo "Pasta de arquivos de execução não encontrada! - Use './cbuild.sh build <dir> <output_name>' para compilar seu programa e criar a pasta"
  exit 1
fi

if [[ $debug_mode == true ]]; then 
  echo "Debug: Programa verificou se o diretório '$build_dir' está vazio." 
fi

#verifico se não tenho permissões para acessar o diretório build
if [[ ! -r "$build_dir" || ! -x "$build_dir" || ! -w "$build_dir" ]]; then
  echo "Sem Permissão Para Acessar o Conteúdo Da Pasta '$build_dir'." >> "$out_text"
  echo "Erro: permissão negada ao acessar '$build_dir'."
  return 1
fi

if [[ $debug_mode == true ]]; then 
  echo "Debug: Programa verificou se existe permissão para acessar '$build_dir'." 
fi

#Guarda o caminho do executável mais recente
run_file=$(find "$build_dir" -maxdepth 1 -type f -executable -printf '%T+ %p\n' | sort -r | head -1 | cut -d' ' -f2-)

if [[ -z "$run_file" ]]; then

  #verificando se existe um arquivo recente, mas sem permissão ou com formato inválido
  #apenas tirei o filtro -executable nessa segunda busca

  likely_file=$(find "$build_dir" -maxdepth 1 -type f -printf '%T+ %p\n' | sort -r | head -1 | cut -d' ' -f2-)

  if [[ -n "$likely_file" ]]; then

    if [[ $debug_mode == true ]]; then 
      echo "Debug: Programa concluiu que há um arquivo recente em $build_dir, mas ele não é um executável válido." 
    fi

    echo "Erro Ao Executar '$likely_file' (Falta De Permissão Ou Formato Inválido) '$run_file'" >> "$out_text"
    echo "Erro ao executar '$likely_file' (Falta de permissão ou formato inválido)"
    exit 1

  else
    echo "Arquivo de Execução Não Encontrado Na Pasta './build'!" >> $out_text
    echo "Nenhum arquivo de execução encontrado! - Use './cbuild.sh build <dir> <output_name>' para compilar seu programa"
    exit 1
  fi

fi

if [[ $verbose_mode == true ]]; then 
  echo "Programa armazenou o caminho do executável na variável '$run_file'."
fi

if [[ $debug_mode == true ]]; then 
  echo "Debug: Programa concluiu que existe um arquivo executável válido." 
fi

#Executa o arquivo, se houver erro, manda para o $out_text
./"$run_file" 2>> "$out_text"
exit_code=$?

if [[ $verbose_mode == true ]]; then 
  echo "Programa executou o arquivo '$run_file'."
fi

if [[ $exit_code -eq 0 ]]; then
  echo "Programa Executado Com Sucesso!" >> $out_text
  echo "Execução bem-sucedida."

  if [[ $verbose_mode == true ]]; then 
    echo "Programa terminou a execução de $run_file"
    echo ""
    echo "======== Run Finalizado ========="
    echo ""
  fi

  exit 0

elif [[ $exit_code -gt 128 ]]; then
  sinal=$((exit_code - 128))
  echo "Programa Encerrado Pelo Sinal $sinal ($(kill -l $sinal))" >> "$out_text"
  echo "Erro em tempo de execução! Acesse o log para mais informações."
  exit 1

else
  echo "Erro ao executar '$run_file'! Acesse o log para mais informações."
  exit 1
fi