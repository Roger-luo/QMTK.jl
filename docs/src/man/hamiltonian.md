# [Hamiltonian](@id man-hamiltonian)

Hamiltonian of many-body system usually has the form of
so called ``k``-local Hamiltonian, which means each local
hamiltonian only involves k bodies (bits).

for example, the Hamiltonian of Traverse Field Ising Model

```math
H = \sum_i \sigma_x^i + \sum_{<i,j>}\sigma_z^i\sigma_z^j
```

More generally, a local Hamiltonian has the form

```math
H = \sum_{l_1,l_2,\dots,l_{m_1} \in region(1)} H_{l_1, l_2, \dots, l_{m_1}} + \sum_{l_1, l_2, \dots, l_{m_2} \in region(2)} H_{l_1, l_2, \dots, l_{m_2}} + \dots + \sum_{l_1, l_2, \dots, l_{m_k} \in region(k)} H_{l_1, l_2, \dots, l_{m_k}}
```

where ``l_i`` denotes the ``i``th body/site/bit/... of the system, ``region(k)`` denotes the ``k``th region of the system, ``m_k`` denotes the number of body/site/bit/... involves in this region (e.g for nearest neighbor m_k is 2).

Thus the form of hamiltonian can be define in a program without knowing the exact form of lattice/geometry.

we offer a macro `@ham` to accomplish this, e.g

We can define a J1J2 hamiltonian on arbitrary lattice by

```@setup hamiltonian
using QMTK
using QMTK.Consts.Pauli
```

```@repl hamiltonian
h = @ham sum(:nearest, S * S) + sum(:nextnearest, S * S)
```

The region is described by the type `Region`

```@docs
Region
Nearest
NextNearest
```

we provide two shorthands for regions in `@ham` macro, one is
`:nearest` denotes `Region{1}` and `:nextnearest` denotes `Region{2}`.

TODO:

- allow use `Region{N}` in `@ham`
- allow to parse `Region{0}` to traverse sites

## Access the Hamiltonian

Only when the lattice is defined, the matrix form of a certain Hamiltonian is determined. Then we could access it.

We offer two ways to access the matrix form of a Hamiltonian.

The recommended way is to use iterators, all the instance of hamiltonian is callable with input of lattice and left-hands basis (site/bit/...).

```@repl hamiltonian
lattice = Chain(Fixed, 4)
lhs = Sites(Bit, 4)
for (val, rhs) in h(lattice, lhs)
    println(val, ", ",rhs)
end
```

It will return an iterator that traverse all non-zeros values of left-hands basis.

If you just want to use its matrix form rather than access part of its value, you can directly use `mat`

```@repl hamiltonian
mat(h, lattice)
```
