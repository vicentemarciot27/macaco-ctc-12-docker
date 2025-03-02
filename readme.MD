# Bizuário de Docker para CTC-12 com Docker Compose

Este guia explica como criar um ambiente isolado para compilar e testar seu projeto em C, utilizando Docker Compose. Com essa abordagem, você evita usar caminhos absolutos e garante que o ambiente de desenvolvimento seja consistente em diferentes máquinas.

O que o prof chama de lab1hash, eu chamo de LabX.

## 1. Instale o Docker Desktop

Acesse [Docker Desktop](https://www.docker.com/products/docker-desktop/) e faça a instalação. Sempre que for usar o Docker, inicie o Docker Desktop.

## 2. Organize os Arquivos do Projeto

Crie uma estrutura de diretórios semelhante a esta (a pasta base pode ter o nome que você preferir, por exemplo, **LabX**):

```	
LabX/
├── docker-compose.yaml
├── Dockerfile
├── src/
│ ├── main.c
│ ├── Makefile
```

### Exemplo de Dockerfile

O arquivo `Dockerfile` deve estar na raiz do projeto e definir o ambiente de compilação. Exemplo:

```dockerfile
# Use a imagem do Ubuntu 18.04 como base
FROM ubuntu:18.04

# Atualize o repositório e instale os pacotes necessários
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    zip \
 && rm -rf /var/lib/apt/lists/*

# Defina o diretório de trabalho como /src
WORKDIR /src

# Inicia um terminal bash
CMD ["bash"]
```

# Exemplo de docker-compose.yml
O arquivo docker-compose.yml permite orquestrar seu container e utilizar caminhos relativos para montar o volume. Exemplo:

```docker-compose.yml
version: '3.8'
services:
  labx:  # Nome do serviço
    build: .
    volumes:
      - ./:/src
    command: bash
```

# 3. Construa a imagem Docker

Para construir a imagem Docker, você deve rodar o comando:

```bash
docker-compose build
```

Lembrando que você deve estar na pasta onde está o docker-compose.yml. Para fazer isso no VSCode, aperte ctrl + ' e digite

```bash
cd caminho/relativo/para/a/pasta/LabX
```

Para "subir" uma pasta, aperte ctrl + ' e digite

```bash
cd ..
```

Uma imagem docker é uma camada de software que contém todos os pacotes necessários para executar o projeto de acordo com o Dockerfile.

# 4. Execute o container
Após a construção da imagem, inicie o container com:

```bash
docker-compose up -d
```
Isso iniciará o container em segundo plano.

Para acessar um terminal interativo do container, rode, em outro terminal:

```bash
docker-compose exec labx bash
```

# 5. Desenvolvimento e compilação
Dentro do container, você estará no diretório /src, que corresponde ao diretório do projeto no seu host. Faça suas compilações, testes e outras operações normalmente. Toda alteração no diretório src será refletida no container, permitindo um fluxo de trabalho integrado.


# 6. Parar o container
Para stoppar o container, você pode apertar ctrl + c.
Você também pode pausar o container com o seguinte comando em outro terminal:

```bash
docker-compose pause labx
```

A diferença entre pause e stop é que pause suspende a execução do container, mantendo seu estado, enquanto stop encerra o container, liberando os recursos e não preservando o estado.

Para parar o container, você deve rodar o comando:

```bash
docker-compose down
```

# Codigo em C

## 1. Estrutura do Projeto

O professor espera que a estrutura do diretório seja exatamente como a seguir:


```
LabX/
├── CMakeLists.txt         # Instruções de compilação
├── CMakeLists.txt.in      # Instruções para baixar o gtest
├── data/                 # Dados de entrada ou saída (quando fornecidos)
├── test/                 # Código de testes (fornecido pelo professor)
└── src/                  # Diretório onde você deve implementar o seu código
```

**Importante:**

-   O CMake está configurado para compilar _todos_ os arquivos com extensão `.cpp` que estiverem em `src`.
-   **Não altere a estrutura dos diretórios.**
* * *

## 2 Compilação “Off the Source”

A ideia é que a compilação ocorra fora dos diretórios de código-fonte (src, test, data). Dessa forma, para “resetar” a compilação, basta apagar o diretório de build.

### Passos para Compilar

1.  **Extraia o arquivo `LabX.zip`:**

    Extraia e coloque-os na pasta LabX, assim como estão no exemplo

    Em outro terminal, rode o seguinte comando para acessar o terminal do container (esse terminal é Linux, então os comandos são diferentes do Windows):


    ```bash
    docker-compose exec labx bash
    ```

2.  **Crie um diretório para a compilação (build):**


    ```bash
    mkdir build
    cd build
    ```

3.  **Gere os Makefiles com o CMake:**

    Execute o comando:

    ```bash
    cmake ..
    ```

    -   Aqui, o `..` indica que o CMake procurará o arquivo `CMakeLists.txt` no diretório pai (ou seja, na raiz do projeto).
    -   Na primeira execução, pode haver uma demora devido ao download do gtest.
    -   Se algum pacote (como o g++ ou git) não estiver instalado, erros serão exibidos.
4.  **Compile o Projeto:**

    No mesmo diretório `build`, execute:

    ```bash
    make
    ```

    -   Na primeira vez, a compilação pode demorar um pouco, pois o gtest também será compilado.
    -   Ao final, você verá a criação do executável (geralmente chamado `lab1tests`).
* * *

## 3. Execução dos Testes

Após a compilação, execute os testes com:

```bash
./lab1tests
```

-   O executável inclui a `main()` fornecida pelo gtest, que chama todos os testes e imprime o resultado.
-   Você deverá ver uma saída semelhante a:
    -   Várias linhas informando o início e fim dos testes, com mensagens como `[ OK ] LabX.AddOneElement` e, no final, `[ PASSED ] 5 tests.`
**Observação:**
Não inclua uma função `main()` no seu código, pois a presença de duas funções `main()` (a sua e a do gtest) impedirá a compilação.

* * *

## 4. Limpeza e Recompilação

Se precisar reiniciar a compilação (por exemplo, após criar novos arquivos `.cpp`), basta apagar o diretório `build`:

```bash
rm -fr build
```

Depois, repita os passos 2 a 4 para gerar uma compilação limpa.

* * *

## 5. Submissão

O professor fornece um script chamado `zipaParaEntregar` para empacotar sua submissão. Esse script cria um arquivo ZIP contendo **apenas** o diretório `src`.

### Como Usar o Script

1.  **Certifique-se de estar no diretório raiz do lab** (pai do diretório `src`):

    ```bash
    cd LabX
    ```

2.  **Execute o script, passando seu nome (sem acentos e espaços) como argumento:**

    ```bash
    `./zipaParaEntregar SeuNomeSemAcentos`

    Exemplo:

    ```bash
    ./zipaParaEntregar ZeJoaoSilva
    ```

-   O script gerará um arquivo `ZeJoaoSilva.zip` que deve conter o diretório `src` com seu código e o seu relatório em PDF (se for exigido).
-   **Atenção:** Não altere a estrutura; o script de correção espera um diretório `src` dentro do arquivo ZIP.
* * *

## 6. Dicas sobre a STL e Uso Correto dos Containers

O professor também enfatiza o uso correto dos containers da STL:

-   **std::vector:**
    -   Quando um vetor precisa crescer, a política é dobrar o tamanho. Isso implica realocações e cópias dos elementos.
    -   **Exemplo:** Ao fazer push\_back repetidamente sem pré-alocar, podem ocorrer múltiplas realocações.
    -   Para evitar isso em loops internos críticos, é preferível reservar ou redimensionar o vetor no construtor.
-   **std::forward\_list:**
    -   É uma lista ligada simples, onde a busca é linear (O(n)).
    -   Lembre-se: Não há necessidade de criar um “nó cabeça” – a própria lista já trata o caso de estar vazia.
-   **Importante:**
    -   Sempre use _include guards_ nos seus cabeçalhos para evitar problemas com inclusões recursivas.
    -   Se um novo arquivo `.cpp` for adicionado à pasta `src`, chame novamente o CMake para atualizar os Makefiles.
* * *

## FAQ Rápido

-   **Cmake x Make:**
    -   Sempre que criar novos arquivos fonte (.cpp), execute `cmake ..` para atualizar os Makefiles.
    -   Se apenas alterar o conteúdo de um arquivo já conhecido, basta chamar `make`.
-   **Uso da IDE:**
    -   Você pode usar sua IDE favorita para editar os arquivos na pasta `src`.
    -   No entanto, a compilação e os testes devem ser realizados usando o CMake e o make, conforme as instruções.
-   **Não submeta um main():**
    -   Utilize o main() do gtest para rodar os testes. Se precisar de uma main() para testes locais, crie um projeto separado e remova-a antes da submissão.
#   m a c a c o - c t c - 1 2 - d o c k e r  
 