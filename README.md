# SIMPLES Compiler

*SIMPLES* Compiler is a basic compiler developed using **Flex** and **Bison**. It performs lexical analysis and syntax parsing for a custom programming language called *SIMPLES*.

## Prerequisites

Ensure you have the following software installed on your system:

- [Flex](https://github.com/westes/flex) - Fast Lexical Analyzer
- [Bison](https://www.gnu.org/software/bison/) - GNU Parser Generator
- [GCC](https://gcc.gnu.org/) - GNU Compiler Collection

Alternatively, you can use the provided Docker container for a fully supported environment. See the [Docker](#docker) section for details.

## Usage

To build and run the Simples Compiler, follow these steps:

1. **Navigate to the project directory**:
    ```sh
    cd ./projects/simples
    ```

2. **Clean the environment**:
    ```sh
    make clean
    ```

3. **Build the compiler**:
    ```sh
    make simples
    ```

4. **Compile your SIMPLES source file**:
    ```sh
    ./simples program.simples
    ```

Replace `program.simples` with the path to your SIMPLES source code file.

## Docker

You can use Docker to set up a fully supported environment for building and running the Simples Compiler. Follow these steps:

1. **Start the Docker container**:
    ```sh
    docker compose up -d
    ```

2. **Access the running container**:
    ```sh
    docker exec -ti <CONTAINER_ID> bash
    ```

Replace `<CONTAINER_ID>` with the actual ID of the running container.

## :page_facing_up: Docs

[SIMPLES Language Documentation](./projects/simples/DOC.md).


---