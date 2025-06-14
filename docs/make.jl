using LocalRegistrator
using Documenter

DocMeta.setdocmeta!(LocalRegistrator, :DocTestSetup, :(using LocalRegistrator); recursive=true)

makedocs(;
    modules=[LocalRegistrator],
    authors="Michał Mika <michal@mika.sh> and contributors",
    sitename="LocalRegistrator.jl",
    format=Documenter.HTML(;
        canonical="https://SuiteSplines.github.io/LocalRegistrator.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/SuiteSplines/LocalRegistrator.jl",
    devbranch="main",
)
