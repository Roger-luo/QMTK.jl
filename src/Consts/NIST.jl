"""
    NISTConst{T} <: AbstractPhysicsConst{T}

NIST CODATA Physics Constants (2014).
"""
struct NISTConst{T} <: AbstractPhysicsConst{T}
    quantity::String
    value::T
    uncertainty::T
    unit::String
end

value(x::NISTConst) = x.value
eltype(::Type{NISTConst{T}}) where T = T

function NISTConst(d::Dict{String})
    value = Compat.replace(d["Value"], " " => "")
    uncertainty = 0.0

    m = match(r"([0-9]+\.[0-9]+)(\.{3})(.*)", value)
    if m != nothing
        value = Meta.parse(m[1] * m[3])
    elseif d["Uncertainty"] == "(exact)"
        value = Meta.parse(value)
    else
        value = Meta.parse(value)
        uncertainty = Meta.parse(Compat.replace(d["Uncertainty"], " " => ""))
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
