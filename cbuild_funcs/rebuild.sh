#!/bin/bash

# aqui jaz a função rebuild que chama a func clean e dps chama a func build

out_text=$(mktemp -p "$command_log_dir" 05_rebuild.XXXXXX)

if [[ $verbose_mode == true ]]; then 
  echo "Verboso: Programa inicou a execução de rebuild"
  echo ""
  echo "======== Rebuild em Andamento ========"
  echo ""
fi

clean_command=$(find "${0%/*}" -type f -iname "clean.sh" 2>/dev/null)

build_command=$(find "${0%/*}" -type f -iname "build.sh" 2>/dev/null)

if [[ -z "$clean_command" ]]; then
  echo "Arquivo 'clean.sh' Não Encontrado Para a Execução do Comando 'Clean'." >> "$out_text"
  echo "Falha em encontrar o arquivo executável clean.sh."
  exit 1
fi

if [[ -z "$build_command" ]]; then
  echo "Arquivo 'build.sh' Não Encontrado Para a Execução do Comando 'Build'." >> "$out_text"
  echo "Falha em encontrar o arquivo executável build.sh"
  exit 1
fi

if [[ $debug_mode == true ]]; then 
  echo "Debug: Programa verificou se os scripts clean.sh e build.sh existem." 
fi

"$clean_command"

#saída 0 ou 1 da execução de clean
exit_clean=$?

if [[ $exit_clean -eq 0 ]]; then
  "$build_command" "$1" "$2"
  exit_build=$?

else
  echo "" 
  echo "Rebuild falhou: a etapa de limpeza foi mal-sucedida"
  echo ""
  echo "Comando Clean Falhou Em Sua Execução." >> "$out_text" 
  exit 1
fi
  
if [[ $exit_build -eq 0 ]]; then
  echo "Comando Rebuild executado com sucesso"
  echo "Comando Rebuild executado com sucesso" >> "$out_text" 
  exit 0

else
  echo "" 
  echo "Rebuild falhou: a etapa de compilação foi mal-sucedida"
  echo ""
  echo "Comando Build Falhou Em Sua Execução." >> "$out_text" 
  exit 1
fi

if [[ $verbose_mode == true ]]; then 
    echo "Verboso: Programa terminou a execução de Rebuild"
    echo ""
    echo "======== Rebuild Finalizado ========="
    echo ""
fi