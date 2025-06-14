module LocalRegistrator

    using Git, TOML, Random
    import RegistryTools

    include("base.jl")
    include("git.jl")
    include("registering.jl")

    export register
end
