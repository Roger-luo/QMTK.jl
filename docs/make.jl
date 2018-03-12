using Documenter, QMTK

makedocs(
    modules = [QMTK],
    clean = false,
    format = :html,
    sitename = "Quantum Many-body Toolkit",
    linkcheck = !("skiplinks" in ARGS),
    analytics = "UA-89508993-1",
    pages = [
        "Home" => "index.md",
        "Manual" => Any[
            "Introduction" => "man/introduction.md",
            "man/basictype.md",
            "man/constants.md",
            "man/lattice.md",
            "man/hamiltonian.md",
            "man/statistics.md",
            "man/model.md",
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
