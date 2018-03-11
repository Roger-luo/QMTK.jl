using Documenter, QMTK

makedocs(
    format = :html,
    clean = false,
    sitename = "Quantum Many-body Toolkit",
    pages = [
        "Home" => "index.md",
        "Manual" => [
            "Introduction" => "man/Introduction.md",
        ]
    ]
)

deploydocs(
    repo = "github.com/Roger-luo/QMTK.jl.git",
    target = "build",
    deps = nothing,
    make = nothing,
)
