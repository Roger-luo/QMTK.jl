# [Physics Constants](@id man-constants)

```@setup constants
using QMTK.Consts
```

The physics constants module `QMTK.Consts` uses
[NIST CODATA Project](https://physics.nist.gov/cuu/Constants/)'s definitions of physics constants as default. You can access all NIST data in `QMTK.Consts.DATA["NIST"]` by use certain names of the constant, e.g

```@repl constants
a = Consts.DATA["NIST"]["Bohr radius"]
```

You will receive a `Consts.NISTConst` type, which contains information of the constants `quantity`, `uncertainty`, `unit` and `value`, but don't panic we have overload this type and just use it like normal native Julia numbers, it will automatically use its `value` to do the operation.

You can access all these property by

```@repl constants
a.quantity
a.uncertainty
a.unit
a.value
```

You can bring defined Physics Constants' name by calling

```julia-repl
juila> using QMTK.Consts
```

This will bring the following physics constatns into your current scope. Be careful, this may cause name conflict to your current variables. If you do not want to cause this conflict you can just use

```julia-repl
julia> import QMTK.Consts
```

## Defined Physics Constant

The following physics constants whose value is defined are provided by `QMTK.Consts`:

```@docs
Consts.μ0
Consts.ε0
```

## Universal constants

The following physics constants are provided by `QMTK.Consts` with data download from NIST:

```@docs
Consts.c
Consts.c0
Consts.G
Consts.g
Consts.ħ
Consts.h
```

## Electromagnetic constants

This constant will cause conflict with default constant `e` for mathematical constant `e`, you can use another binding `eu` for `2.718...` after `using QMTK.Consts` instead.

```@docs
Consts.e
```

## Atomic and nuclear constants

```@docs
Consts.a0
Consts.α
```

## Physico-chemical constants

```@docs
Consts.k
Consts.NA
Consts.atm
```

## Pauli matrix

We provide some sugar for pauli matrix with Julia `stdlib` in `QMTK.Consts.Pauli`

You can use the following command to bring `sigmax`, `sigmay`, `sigmaz`, `sigmai` (for the 2x2 identity) and `σ`, `σ₀`, `σ₁`, `σ₂`, `σ₃`

```@setup pauli
using QMTK.Consts.Pauli
```

where `σ` is the Pauli Group

```@repl pauli
σ[1] # sigmai
σ[2] # sigmax
σ[3] # sigmay
σ[4] # sigmaz
```

and `S` is the `PauliVector`: ``(\sigma_x, \sigma_y, \sigma_z)``

you can use it when you need operations like

```@repl pauli
S * S # σ₁⊗σ₁ + σ₂⊗σ₂ + σ₃⊗σ₃
```
