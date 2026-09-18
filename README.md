# Tec_Prog-EP-1
Repositório que contém o software requisitado no primeiro projeto em equipe do curso regular do IME USP - MAC0216 oferecido para os alunos do Bacharelado em Ciência da Computação;


CBuild

O que é o CBuild e o que ele faz?

O CBuild é uma ferramenta que facilita o processo de compilação de projetos em C.

Para isso, ele compila normalmente na primeira vez e, nas próximas execuções, detecta alterações e recompila apenas o que for necessário. Além disso, gerencia os artefatos e os logs de compilação.

---

Requisitos

- GCC

---

Comandos

```
"./cbuild"
```

Apresenta o programa.

"build" / "b"

```
./cbuild build <Diretório> [Nome do Executável]
```

Compila todas as mudanças detectadas no seu programa ".c".

O diretório é obrigatório, enquanto o nome do executável é opcional. Caso não seja informado, será utilizado um nome padrão.

"clean" / "c"

```
./cbuild clean
```

Limpa os artefatos da compilação.

"clean all"

```
./cbuild clean all
```

Limpa os artefatos da compilação e todos os logs.

"run" / "r"

```
./cbuild run
```

Executa seu programa ".c" a partir do arquivo compilado pelo comando "build".

"rebuild" / "rb"

```
./cbuild rebuild <Diretório> [Nome do Executável]
```

Recompila seu programa, limpando todos os arquivos temporários e criando um novo arquivo de execução.

Assim como no "build", o diretório é obrigatório e o nome do executável é opcional.

"info" / "i"

```
./cbuild info <Diretório>
```

Exibe algumas informações importantes sobre o seu programa.

O diretório é obrigatório.

"verbose" / "v"

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

"debug" / "d"

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

---

Exemplos de uso

Build

```
./cbuild build /home/programa programa
```

O CBuild encontra todos os arquivos ".c" na pasta "/home/programa" e os compila de forma incremental.

Cada compilação individual é colocada na pasta:

/build/build_parts

Essa pasta estará localizada na pasta principal do programa.

Após isso, o executável gerado, com o nome passado pelo usuário, será colocado na pasta:

/build

O executável já estará pronto para rodar o programa. Ele pode ser executado diretamente pelo terminal ou através do comando "run", que fará a execução automaticamente.

---

Clean

```
./cbuild clean
```

Exclui todos os arquivos ".o" guardados na pasta "/build" e o executável que foram gerados anteriormente pelos comandos "build" e "rebuild".

---

Clean All

```
./cbuild clean all
```

Além de excluir todos os arquivos ".o" e o executável guardados na pasta "/build", que foram gerados anteriormente pelos comandos "build" e "rebuild", também exclui os arquivos de logs localizados na pasta "/logs".

---

Run

```
./cbuild run
```

Executa o arquivo executável "main.o", pertencente à pasta "/build", que guarda os arquivos executáveis criados após o usuário utilizar os comandos "build" ou "rebuild".

---

Rebuild

```
./cbuild rebuild /home/programa programa
```

Exclui todos os executáveis guardados na pasta "/build", que foram gerados anteriormente pelos comandos "build" e "rebuild".

Após isso, procura os arquivos ".c" no diretório fornecido e os compila de forma incremental, colocando cada compilação individual na pasta:

/build/build_parts

Após a compilação, o executável gerado será colocado na pasta "/build", utilizando o nome passado pelo usuário.

Assim, já será possível rodar o programa diretamente pelo terminal ou através do comando "run", que irá executá-lo automaticamente.

---

Info

```
./cbuild info /home/programa
```

O programa fornece um painel de informações sobre o projeto em C contido no diretório fornecido.

Esse painel contém informações úteis sobre o estado de compilação do projeto, mostrando:

- Métricas do código;
- Status de compilação;
- Histórico de compilação.

---

Verbose

```
./cbuild verbose T
```

O programa ativa o modo verboso.

Ao utilizar qualquer comando posteriormente, ele fornecerá informações úteis para entender como o programa funciona e o que ele está fazendo durante sua execução.

---

Debug

```
./cbuild debug T
```

O programa ativa o modo debug.

Ao utilizar qualquer comando posteriormente, ele fornecerá informações sobre os códigos que o programa executou de forma mais técnica, com o objetivo adicional de auxiliar na identificação de falhas e bugs no programa.

---

Logs

Para acessar os logs do programa, basta abrir a pasta "logs" do CBuild:

cd logs/

Os logs são criados após a execução de um comando e armazenam informações sobre a execução, como:

- Comando executado;
- Comando digitado pelo usuário;
- Tempo de execução;
- Resultado;
- Mensagem de erro, caso ocorra;
- Entre outras informações.

---

Configurações

O programa conta com o arquivo:

.cbuild_config

Nesse arquivo, o usuário pode alterar o nome padrão do executável de compilação.

Também é possível ativar manualmente os modos verboso e debug.

Para ativá-los manualmente, basta alterar:

false

para:

true

Para desativá-los novamente, basta substituir "true" por "false".

«Importante: Os modos verboso e debug não podem estar ativos ao mesmo tempo.»
