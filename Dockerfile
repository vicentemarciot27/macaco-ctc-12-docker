# Um dockerfile é um arquivo que define como o container deve ser construído. Ele é usado para criar uma imagem do container, instalar pacotes, definir o diretório de trabalho, etc.

# Use a imagem do Ubuntu 18.04 como base
FROM ubuntu:18.04

# Atualize o repositório e instale os pacotes necessários
RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential git libssl-dev wget

# Instale uma versão que funciona do cmake (a padrão pro ubuntu 18.04 é a 3.10, que vai dar erro e o prof não avisou :O)
RUN wget https://github.com/Kitware/CMake/releases/download/v3.31.5/cmake-3.31.5-linux-x86_64.sh -q -O /tmp/cmake-install.sh \
    && chmod u+x /tmp/cmake-install.sh \
    && mkdir -p /opt/cmake \
    && /tmp/cmake-install.sh --skip-license --prefix=/opt/cmake \
    && ln -s /opt/cmake/bin/* /usr/local/bin/ \
    && rm /tmp/cmake-install.sh

# Defina o diretório de trabalho como a raiz
WORKDIR /Lab1_Volume

# Inicia um terminal bash
CMD ["bash"]
