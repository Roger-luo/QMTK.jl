abstract type Animal end

name(x::Animal) = x.name

abstract type Monkey <: Animal end
abstract type Bird <: Animal end

struct HugeMonkey <: Monkey
    name::String
    age::Int
    size::Int
end

struct SmallMonkey <: Monkey
    name::String
end

struct BigBird <: Bird
    name::String
    flyable::Bool
end

struct Swoole <: Bird
end

name(x::Swoole) = "Swoole"

eatable(a::Monkey, b::Bird) = true
eatable(a::Bird, b::Monkey) = false
