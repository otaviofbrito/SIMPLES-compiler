# SIMPLES Language Documentation

## Introduction

SIMPLES is a custom programming language designed for educational purposes and simple computational tasks. This documentation provides an overview of the language's syntax, keywords, data types, and control structures.

## Lexical Elements

### Identifiers

- **Definition**: Identifiers in SIMPLES start with a letter followed by any combination of letters and digits.
- **Example**: `myVar`, `counter1`

### Keywords

SIMPLES has a set of reserved keywords used to define the structure and control flow of the programs:

- `programa`
- `inicio`
- `fimprograma`
- `leia`
- `escreva`
- `se`
- `entao`
- `senao`
- `fimse`
- `enquanto`
- `faca`
- `fimenquanto`
- `inteiro`
- `logico`
- `def`
- `fimdef`
- `registro`

### Constants

- **Integer Constants**: A sequence of digits.
  - **Example**: `123`
- **Boolean Constants**: Represented by `V` (true) and `F` (false).

### Operators

- **Arithmetic Operators**: `+`, `-`, `*`, `div` (division)
- **Relational Operators**: `>`, `<`, `=`
- **Logical Operators**: `e` (and), `ou` (or), `nao` (not)
- **Assignment Operator**: `<-`

### Delimiters

- **Parentheses**: `(`, `)`
- **Comments**: 
  - Single-line comments start with `//`.
  - Multi-line comments are enclosed within `/*` and `*/`.

## Data Types

### Inteiro (Integer)

Represents integer numbers.

### Logico (Boolean)

Represents boolean values, either `V` (true) or `F` (false).

## Syntax and Semantics

### Program Structure

A SIMPLES program starts with the `programa` keyword and ends with the `fimprograma` keyword. The main body of the program is enclosed between `inicio` and `fim`.

```simples
programa
inicio
    // Program statements
fimprograma
```

### Variable Declaration

Variables must be declared before use.

```simples
inteiro x
logico flag
```

### Input and Output

- **Input**: The `leia` keyword is used to read values from the user.
- **Output**: The `escreva` keyword is used to print values to the screen.

```simples
leia x
escreva x
```

### Control Structures

#### If Statement

The `se` keyword is used for conditional execution. The `entao` keyword introduces the block of code to execute if the condition is true, and the `senao` keyword introduces the block of code to execute if the condition is false.

```simples
se x > 0 entao
    escreva "Positive"
senao
    escreva "Non-positive"
fimse
```

#### While Loop

The `enquanto` keyword is used for looping as long as the condition is true. The `faca` keyword introduces the block of code to repeat, and the loop ends with `fimenquanto`.

```simples
enquanto x < 10 faca
    escreva x
    x <- x + 1
fimenquanto
```

### Procedures

Procedures are defined using the `def` and `fimdef` keywords. They allow for code reuse and modularity.

```simples
def myProcedure
inicio
    // Procedure statements
fimdef
```

### Records

The `registro` keyword is used to define a structured data type similar to structs in C.

```simples
registro Person
inteiro age
logico isEmployed
fimdef
```

## Example Program

Here is a complete example of a SIMPLES program that demonstrates variable declaration, input/output, and control structures.

```simples
programa
inicio
    inteiro x
    logico flag

    escreva "Enter an integer: "
    leia x

    se x > 0 entao
        escreva "Positive"
    senao
        escreva "Non-positive"
    fimse

    enquanto x < 10 faca
        escreva x
        x <- x + 1
    fimenquanto
fimprograma
```

## Error Handling

Lexical errors are handled by the `erro` function, which prints an error message and terminates the program. Syntax errors are reported by Bison during parsing.

