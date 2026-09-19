# Cbuild
Repositório que contém o software requisitado no primeiro projeto em equipe do curso regular do IME USP - MAC0216 oferecido para os alunos do Bacharelado em Ciência da Computação;


## O que é o Cbuild e o que ele faz?

O Cbuild é uma ferramenta que facilita o processo de compilação de projetos em C.

Para isso, ele compila normalmente na primeira vez e, nas próximas execuções, detecta alterações e recompila apenas o que for necessário. Além disso, gerencia os artefatos e os logs de compilação.

---

# Requisitos

- GCC
- Terminal que interprete Bash scripts

---

# Comandos

```
"./cbuild"
```

Apresenta a interface do programa listando os comandos disponíveis para o usuário.


```
./cbuild build <Diretório> [Nome do Executável]
```

Compila todas as mudanças detectadas no seu programa ".c".

O diretório é obrigatório, enquanto o nome do executável é opcional. Caso não seja informado, será utilizado um nome padrão.


```
./cbuild clean
```

Limpa os artefatos da compilação.


```
./cbuild clean all
```

Limpa os artefatos da compilação e todos os logs.


```
./cbuild run
```

Executa seu programa ".c" a partir do arquivo compilado pelo comando "build".


```
./cbuild rebuild <Diretório> [Nome do Executável]
```

Recompila seu programa, limpando todos os arquivos temporários e criando um novo arquivo de execução.

Assim como no "build", o diretório é obrigatório e o nome do executável é opcional.


```
./cbuild info <Diretório>
```

Exibe algumas informações importantes sobre o seu programa.

O diretório é obrigatório.


```
./cbuild verbose T
```

ou

```
./cbuild verbose F
```

Ativa ou desativa o modo verboso.

- "T" — ativa
- "F" — desativa


```
./cbuild debug T
```

ou

```
./cbuild debug F
```

Ativa ou desativa o modo debug.

- "T" — ativa
- "F" — desativa

«Obs.: Os modos verboso e debug não podem estar ativos ao mesmo tempo.»

### Os comandos também podem ser chamados a partir de suas siglas:

- "build" / "b"

- "run" / "r"

- "clean" / "c"

- "clean all" / "c all"

- "rebuild" / "rb"

- "info" / "i"

- "verbose" / "v"

- "debug" / "d"

---

# Exemplos de uso

- Build

```
./cbuild b /home/programa programa
```

O Cbuild encontra todos os arquivos ".c" na pasta "/home/programa" e os compila de forma incremental.

Cada compilação individual é colocada na pasta:

```
/build/build_parts
```

Essa pasta estará localizada na pasta principal do programa junto com o arquivo principal cbuild.sh.

Após isso, o executável gerado, com o nome passado pelo usuário, será colocado na pasta:

```
/build
```

O executável já estará pronto para rodar o programa. Ele pode ser executado diretamente pelo terminal ou através do comando "run", que fará a execução automaticamente.

---

- Clean

```
./cbuild c
```

Exclui todos os arquivos ".o" guardados na pasta "/build" e o executável que foram gerados anteriormente pelos comandos "build" e "rebuild".

---

- Clean All

```
./cbuild c all
```

Além de excluir todos os arquivos ".o" e o executável guardados na pasta "/build", que foram gerados anteriormente pelos comandos "build" e "rebuild", também exclui os arquivos de logs localizados na pasta "/logs".

---

- Run

```
./cbuild r
```

Executa o arquivo executável "main.o", pertencente à pasta "/build", que guarda os arquivos executáveis criados após o usuário utilizar os comandos "build" ou "rebuild".

---

- Rebuild

```
./cbuild rb /home/programa programa
```

Exclui todos os executáveis guardados na pasta "/build", que foram gerados anteriormente pelos comandos "build" e "rebuild".

Após isso, procura os arquivos ".c" no diretório fornecido e os compila de forma incremental, colocando cada compilação individual na pasta:

/build/build_parts

Após a compilação, o executável gerado será colocado na pasta "/build", utilizando o nome passado pelo usuário.

Assim, já será possível rodar o programa diretamente pelo terminal ou através do comando "run", que irá executá-lo automaticamente.

---

- Info

```
./cbuild i /home/programa
```

O programa fornece um painel de informações sobre o projeto em C contido no diretório fornecido.

Esse painel contém informações úteis sobre o estado de compilação do projeto, mostrando:

- Métricas do código;
- Status de compilação;
- Histórico de compilação.

---

 - Verbose

```
./cbuild v T
```

O programa ativa o modo verboso.

Ao utilizar qualquer comando posteriormente, ele fornecerá informações úteis para entender como o programa funciona e o que ele está fazendo durante sua execução.

---

- Debug

```
./cbuild d T
```

O programa ativa o modo debug.

Ao utilizar qualquer comando posteriormente, ele fornecerá informações sobre os códigos que o programa executou de forma mais técnica, com o objetivo adicional de auxiliar na identificação de falhas e bugs no programa.

---

# Logs

Para acessar os logs do programa, basta abrir a pasta "logs" do CBuild:

```
cd logs/
```

Os logs são criados após a execução de um comando e armazenam informações sobre a execução, como:

- Comando executado;
- Comando digitado pelo usuário;
- Tempo de execução;
- Resultado;
- Mensagem de erro, caso ocorra;
- Entre outras informações.

---

# Configurações

O programa conta com o arquivo:

```
cbuild_config
```

Nesse arquivo, o usuário pode alterar o nome padrão do executável de compilação.

Também é possível ativar manualmente os modos verboso e debug.

Para ativá-los manualmente, basta alterar:

```
false
```

para:

```
true
```

Para desativá-los novamente, basta substituir "true" por "false".

«Importante: Os modos verboso e debug não podem estar ativos ao mesmo tempo.»
