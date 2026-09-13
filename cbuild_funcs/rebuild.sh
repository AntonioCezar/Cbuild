#!/bin/bash

# aqui jaz a função rebuild que chama a func clean e dps chama a func build

out_text=$(mktemp -p "$command_log_dir" 05_rebuild.XXXXXX)

clean_command=$(find "./" -type f -iname "clean.sh")

build_command=$(find "./" -type f -iname "build.sh")


if [[ -z "$clean_command" ]]; then
  echo "Arquivo 'clean.sh' Não Encontrado Para a Execução do Comando 'Clean'" >> "$out_text"
  echo "Falha em encontrar o arquivo executável clean.sh"
  exit 1
fi

if [[ -z "$build_command" ]]; then
  echo "Arquivo 'build.sh' Não Encontrado Para a Execução do Comando 'Build'" >> "$out_text"
  echo "Falha em encontrar o arquivo executável build.sh"
  exit 1
fi

./"$clean_command" "all" || {
  {
  echo "" 
  echo "Comando Clean Falhou Em Sua Execução"
  echo ""
  } >> "$out_text" 
  exit 1 
  }

./"$build_command" "$1" "$2" || {
  {
  echo "" 
  echo "Comando Build Falhou Em Sua Execução"
  echo ""
  } >> "$out_text"
  exit 1 
  }