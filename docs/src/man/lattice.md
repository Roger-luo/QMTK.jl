# [Lattice](@id man-lattice)

Lattices are very common in both condensed matter physics and
statistic physics. We offer a general tiny framework for lattices here.

All lattice types are subtype of `AbstractLattice{N}`

```@docs
AbstractLattice
```

We also offers some property tags for lattices. All possible property types are subtype of `LatticeProperty`.

```@docs
QMTK.LatticeProperty
```

Currently we only offer one property: `Boundary`

```@docs
QMTK.Boundary
```

There are two kinds of boundary conditions for a lattice

```@docs
Fixed
Periodic
```

## Lattice with Boundary Condition

All lattices with a boundary condition is the subtype of

```@docs
BCLattice
```

The `BCLattice` has the following interface

```@docs
isperiodic
shape
length
sites
bonds
```

To traverse all sites of a certain lattice, you can use it as an iterator.

```julia
for each_site in sites(lattice)
    println(each_site)
end
```

To traverse all bonds of a certain lattice, you can use `bonds`, the following example traverse 2nd nearest bond on the lattice.

```julia
for each_bond in bonds(lattice, 2)
    println(each_bond)
end
```

## Chain Lattice

```@docs
Chain
```

## Square Lattice

```@docs
Square
```
