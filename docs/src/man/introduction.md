# [Introduction](@id man-introduction)

The [QMTK](@ref homepage) library is developed for physics system involves quantum many-body system, including condensed matter physics, quantum computing, quantum information and etc.

## Motivation

In most numerical and theoretical works, programs related to quantum physics and quantum many-body system could have a lot similar functionality, methods, and objects. We aims to offer a collection of algorithms, object abstractions for quantum many-body system, which will ease your daily work. QMTK aims to provide physicist with a powerful toolkit in Julia language as its frontend interface. Although, Julia language is a promising language for scientific computing, we are not limited to Julia.

## About this Project

This project also aims to start an active developers community, we accept any feature request related to the following topic:

- quantum many-body system
- quantum information (including quantum computing)
- condensed matter physics

## Philosophy

The QMTK package will try to provide a collection of objects that make use of Julia native interface, which will make your learning curve as smooth as possible.

In the meantime, we will try any possible and aggressive methods to improve our performance.

For the models part, we will not provide a general framework to construct quantum circuit, tensor network and neural network. All of our models are designed to be coarse-grained, which means there is only building blocks and there is no tensor (although currently we heavily rely on Julia's native array/tensor interface).

## How to contribute

If you wish to have a new feature, or you wish to contribute to this project, please open an issue [here](https://github.com/Roger-luo/QMTK.jl/issues) to discuss the details and then start your pull request or your pull request may not be merged.

Once your pull request is made, we will apoint a former contributor to review your code. The contributor will approve your pull request if there is no futher suggestions.

## Why choose Julia?

Though, Julia is not perfect, there is some disadvantage for this language at the moment, but we choose this language as frontend for the following reason:

**Julia is fast** For most many-body system related computation, performance is vital. Not only because Julia has JIT (Just-in-time) compiler. The language itself is designed to help the programmer provide as many information as they want to the compiler, which will allow us to optimize this package in the long run.

**Amazing Meta Programming**  Julia itself provide a lisp like macro, and we are able to use the language itself to edit AST. This is extremely useful when we need to arrange the computation task according to your math expression, and we will not need to use techs like expression template in C++ to lazy evaluate some expression, in most cases, we can just use Julia's native generated functions, and the Lazy.jl package for more complex use. And we can use code generation to provide more efficient functions.

**Awesome FFI** The Foreign Function Interface (FFI) of Julia is awesome, no extra glue code is needed. We can always provide highly optimized C/C++/Fortran/CUDA backend for our package. And we can even just use pyjulia to call this package in Python if you like python.
