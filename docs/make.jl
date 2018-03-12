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
    ],
    html_prettyurls = !("local" in ARGS),
    html_canonical = "https://rogerluo.me/QMTK.jl/latest/",
)

deploydocs(
    repo = "github.com/Roger-luo/QMTK.jl.git",
    target = "build",
    julia = "0.6",
    deps = nothing,
    make = nothing,
)
