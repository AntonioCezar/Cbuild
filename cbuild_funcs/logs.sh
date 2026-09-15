#!/bin/bash

# aqui jaz a função de criação de logs

mkdir -p ./logs

logdir=./logs

if [[ ! -r "$logdir" || ! -x "$logdir" || ! -w "$logdir" ]]; then # checa se tem permissão para o caso da pasta já existir anteriormente
  echo "Sem Permissão Para Acessar o Conteúdo Da Pasta '$logdir'." >> "$out_text"
  echo "Erro: permissão negada ao acessar '$logdir'."
  return 1
fi

if [[ $debug_mode == true ]]; then 
    echo "Debug: Programa checou se tem permissões para acessar a pasta '$logdir'"
fi

data_atual=$(date '+%d-%m-%Y')
hora_atual=$(date '+%H-%M-%S')
hora_atual_format=$(date '+%H:%M:%S')

if [[ $debug_mode == true ]]; then 
    echo "Debug: Programa guardou a data e hora da operação"
fi

logfile=cbuild_"$1"_${data_atual}_${hora_atual}.log
touch "$logdir/$logfile"

if [[ $debug_mode == true ]]; then 
    echo "Debug: Programa criou o arquivo .log para a operação."
fi


if [[ $2 -eq 0 ]]; then
    status="Operação Bem-Sucedida"
else
    status="Operação Mal-Sucedida"
fi

if [[ $debug_mode == true ]]; then 
    echo "Debug: Programa checou se a operação foi bem ou mal-sucedida."
fi

if [[ $verbose_mode == true ]]; then 
    echo "Verboso: Programa criou o arquivo .log e começou a preenchê-lo"
fi

{
echo "" 
echo "============================================================="
echo "Data de criação deste log: ${data_atual}"
echo "Hora de criação deste log: ${hora_atual_format}"
echo "============================================================="
echo ""
echo "*************************************************************"
echo ""
echo "Comando executado: '$1'"
echo ""
echo "Resultado da Operação: '$status'"
echo ""
echo "Comando Digitado pelo Usuário: '$3'"
echo ""
echo "Tempo de Execução do Comando $1: '$4'"
echo ""
echo "*************************************************************"
echo ""
} >> $logdir/$logfile

if [[ $debug_mode == true ]]; then 
    echo "Debug: Programa terminou de preencher as informações básicas utilizando os parâmetros enviados pelo usuário e o run_time obtido no arquivo principal 'cbuild.sh'."
fi

{
echo "Retorno do Comando $1:"
echo ""
shopt -s nullglob # evita que o cat envie a path como texto para o log
cat "$command_log_dir"/* < /dev/null # lê e armazena no log todos os textos dos erros nos comandos
echo ""
} >> $logdir/$logfile

if [[ $debug_mode == true ]]; then 
    echo "Debug: Programa terminou de preencher as informações adicionais com o comando cat que recebe o arquivo 'out_text'."
fi

if [[ $verbose_mode == true ]]; then 
    echo "Verboso: Programa preencheu todas as informações necessárias para o arquivo .log"
fi