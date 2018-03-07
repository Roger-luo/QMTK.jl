################
# NIST Constant
################

struct NISTConst{F} <: AbstractPhysicsConst{F}
    quantity::String
    value::F
    uncertainty::F
    unit::String
end

value(x::NISTConst) = x.value
eltype(::Type{NISTConst{F}}) where F = F

function NISTConst(d::Dict{String})
    value = replace(d["Value"], " ", "")
    uncertainty = 0.0

    m = match(r"([0-9]+\.[0-9]+)(\.{3})(.*)", value)
    if m != nothing
        value = parse(m[1] * m[3])
    elseif d["Uncertainty"] == "(exact)"
        value = parse(value)
    else
        value = parse(value)
        uncertainty = parse(replace(d["Uncertainty"], " ", ""))
    end

    NISTConst(d["Quantity "], promote(value, uncertainty)..., d["Unit"])
end

json(c::NISTConst) = throw(ErrorException("NISTConst should not be serialized"))

function parse(::Type{NISTConst}, file::DataFile{JSONFormat})
    raw = parse(file)["constant"]
    
    data = Dict{String, Any}()

    for each in raw
        data[each["Quantity "]] = NISTConst(each)
    end
    return data
end


DATAFILES["NIST"] = DataFile(
    "https://nist.gov/srd/srd_data//srd121_allascii_2014.json",
    @__DATA__,
    "srd121_allascii_2014.json"
)
obtain(DATAFILES["NIST"])

DATA["NIST"] = parse(NISTConst, DATAFILES["NIST"])

# Alias
# NOTE: https://en.wikipedia.org/wiki/Physical_constant

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