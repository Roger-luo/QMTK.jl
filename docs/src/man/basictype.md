# [Basic Types](@id man-basic-type)

## Basis

Basis is a useful object when describing a Hilbert space. In quantum physics, there are many kind of basis in different problems, including qubits, lattice site, infinity basis, etc.

The basis we mention here and implemented in this package is the tagged part. If you need to use Dirac ket expression, you can simply do it by hands with `dot` function in Julia's linear algebra stdlib. We will not be able to help you to figure out which one is left ket and which one is the right at the moment. To be specific, the basis here means what is inside you ket expression.

``|basis\rangle`` or ``\langle basis|``

## Label

All the labels are subtype of `SiteLabel`, label type is used to provide information about the content in a `AbstractSites` instance.

QMTK offers three kind of labels: Bit, Spin, Half for binary configurations.

```@docs
Bit
Spin
Half
```

## Sites

The abstract hierachy for site is defined as any subtype of `AbstractArray` with label.

```@docs
AbstractSites
```

`Sites` is a Julia native array with certain label that tells the program which kind of site it is.

```@docs
Sites
```

And naive example of `Sites` could be the `Bit` configuration on a Chain lattice (a 1-D Array of Bits on the memory)

``
0\quad 1\quad 0\quad 1\quad 1\quad 0
``

You can declare it by

```@setup basics
using QMTK
```

```@repl basics
Sites(Bit, [0, 1, 0, 1, 1, 0])
```

`Sites` is implemented to support most of Julia array interface, but since Julia do not have inherit of interface,
not all operations is overloaded, please use method `data`, when you need to access its content in calculatoin.

```@docs
data
```

## SubSites

For small sites, it usually contains only a few configuration, and when we try to use a subset of `Sites`, it would be a waste to create a new `Sites`, `SubSites` offer a way to do this efficiently by telling the compiler how large it is in compile time (by `Tuple`).

```@docs
SubSites
```

Or to be simple, you can just interpret `SubSites` to be a `Tuple` with certain `SiteLabel`. Use it like a native `Tuple`.

```@repl basics
SubSites(Bit, 1, 0)
```

and just like tuple

```@repl basics
a, b = SubSites(Bit, 1, 0);
a
b
```

## Space

Space are math objects contains a set of objects with certain structure. In `QMTK` we present it as `AbstractSpace`.

```@docs
AbstractSpace
```

There are currently two kinds of state for a space.

```@docs
SpaceState
Randomized
Initialized
```

There are two kind of space currently

```@docs
RealSpace
SiteSpace
```

### Interface

A space object has the following interface

|    method    |    description     |
| ------------ | ------------------ |
| `data`       | property, required |
| `reset!`     | required           |
| `copy`       | required           |
| `acquire`    | required           |
| `shake!`     | required           |
| `randomized` | required           |
| `traverse`   | optional           |

```@docs
data(x::AbstractSpace)
reset!
copy
acquire
shake!
randomize!
traverse
```
