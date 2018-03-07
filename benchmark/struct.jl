using BenchmarkTools


mutable struct Foo
    data::Int
end

function foo()
    f = Foo(2)
    r = 0
    for i = 1:1000_000_000
        r += i + f.data
    end
    return r
end

function foo2()
    r = 0
    for i = 1:1000_000_000
        r += i + 2
    end
    return r
end


baseline = @benchmark foo2()
bench = @benchmark foo()

display(baseline)
println()
display(bench)
