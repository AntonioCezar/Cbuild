#!/bin/bash

# aqui jaz a função run que roda o programa que foi compilado pelo build

out_text=$(mktemp -p "$command_log_dir" 03_run.XXXXXX)

build_dir=$(find "./" -type d -name "build")

if [[ -z $build_dir ]]; then
  echo "Nenhum Arquivo Presente Na Pasta './build'!" >> $out_text
  echo "A pasta './build' está vazia! - Use './cbuild.sh build <dir> <output_name>' para compilar seu programa"
  exit 1
fi

#Guarda o caminho do executável mais recente
run_file=$(find "$build_dir" -maxdepth 1 -type f -executable -printf '%T+ %p\n' | sort -r | head -1 | cut -d' ' -f2-)

if [[ -z "$run_file" ]]; then

  #verificando se existe um arquivo recente, mas sem permissão ou com formato inválido
  #apenas tirei o filtro -executable nessa segunda busca

  likely_file=$(find "$build_dir" -maxdepth 1 -type f -printf '%T+ %p\n' | sort -r | head -1 | cut -d' ' -f2-)

  if [[ -n "$likely_file" ]]; then
    echo "Erro Ao Executar '$likely_file' (Falta De Permissão Ou Formato Inválido) '$run_file'" >> "$out_text"
    echo "Erro ao executar '$likely_file' (Falta de permissão ou formato inválido)"
    exit 1

  else
    echo "Arquivo de Execução Não Encontrado Na Pasta './build'!" >> $out_text
    echo "Nenhum arquivo de execução encontrado!"
    exit 1
  fi

fi

#Executa o arquivo, se houver erro, manda para o $out_text
./"$run_file" 2>> "$out_text"
exit_code=$?

if [[ $exit_code -eq 0 ]]; then
  echo "Programa Executado Com Sucesso!" >> $out_text
  echo "Execução bem-sucedida."
  exit 0

elif [[ $exit_code -gt 128 ]]; then
  sinal=$((exit_code - 128))
  echo "Programa Encerrado Pelo Sinal $sinal ($(kill -l $sinal))" >> "$out_text"
  echo "Erro em tempo de execução! Acesse o log para mais informações"
  exit 1

else
  echo "Erro ao executar '$run_file'! Acesse o log para mais informações"
  exit 1
fi