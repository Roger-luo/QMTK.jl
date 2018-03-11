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

if "deploy" in ARGS

    # Only deploy docs from 64bit Linux to avoid committing multiple versions of the same
    # docs from different workers.
    (Sys.ARCH === :x86_64 && Sys.KERNEL === :Linux) || return

    deploydocs(
        repo = "github.com/Roger-luo/QMTK.jl.git",
        target = "build",
        deps = nothing,
        make = nothing,
    )
end
