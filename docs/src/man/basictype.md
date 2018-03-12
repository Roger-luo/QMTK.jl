# [Basic Types](@id man-basic-type)

## Basis

Basis is a useful object when describing a Hilbert space. In quantum physics, there are many kind of basis in different problems, including qubits, lattice site, infinity basis, etc.

The basis we mention here and implemented in this package is the tagged part. If you need to use Dirac ket operations, you can simply do it by hands with `dot` function in Julia's linear algebra stdlib. To be specific, the basis here means what is inside you ket expression.

``|basis\rangle`` or ``\langle basis|``

## Label

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

`Sites` is implemented to support most of Julia array interface, but since Julia do not have inherit of interface,
not all operations is overloaded, please use method `data`, when you need to access its content in calculatoin.

```@docs
data
```

## SubSites

For small sites, it usually contains only a few configuration, and when we try to use a subset of `Sites`, it would be a waste to create a new `Sites`, `SubSites` offer a way to do this efficiently by telling the compiler how large it is in compile time (by `Tuple`).

Or to be simple, you can just interpret `SubSites` to be a `Tuple` with certain `SiteLabel`.
