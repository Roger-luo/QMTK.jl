# Some universal physical constant in
# https://en.wikipedia.org/wiki/Physical_constant

DATA["NIST"] = parse(NISTConst, DATAFILES["NIST"])

# Universal constants
export c, c0, G, g, ħ, h
"""
speed of light in vacuum
"""
const c = DATA["NIST"]["speed of light in vacuum"]
"""
speed of light in vacuum
"""
const c0 = DATA["NIST"]["speed of light in vacuum"]
"""
Newtonian constant of gravitation
"""
const G = DATA["NIST"]["Newtonian constant of gravitation"]
"""
standard acceleration of gravity
"""
const g = DATA["NIST"]["standard acceleration of gravity"]
"""
Planck constant
"""
const h = DATA["NIST"]["Planck constant"]
"""
Planck constant over 2 pi
"""
const ħ = DATA["NIST"]["Planck constant over 2 pi"]

# Electromagnetic constants
export e

"""
atomic unit of charge
"""
const e = DATA["NIST"]["atomic unit of charge"]

# Atomic and nuclear constants
export a0, α

"""
Bohr radius
"""
const a0 = DATA["NIST"]["Bohr radius"]

"""
fine-structure constant
"""
const α = DATA["NIST"]["fine-structure constant"]

# Physico-chemical constants
export k, NA, atm

"""
Boltzmann constant
"""
const k = DATA["NIST"]["Boltzmann constant"]

"""
Avogadro constant
"""
const NA = DATA["NIST"]["Avogadro constant"]

"""
standard atmosphere
"""
const atm = DATA["NIST"]["standard atmosphere"]


export μ0, ε0

"""
magnetic constant (vacuum permeability)
"""
const μ0 = DefConst("magnetic constant (vacuum permeability)", 4pi*1e-7, "N A^{-2}")

"""
electric constant (vacuum permittivity)
"""
const ε0 = DefConst("electric constant (vacuum permittivity)", 1/(value(μ0)*value(c)^2), "F m^{-1}")
