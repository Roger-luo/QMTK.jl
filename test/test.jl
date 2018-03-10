function df(x::Int)
    return :(-(sin(x)))
end

print(eval(df(2)))