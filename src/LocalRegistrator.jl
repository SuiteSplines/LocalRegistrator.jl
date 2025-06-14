module LocalRegistrator

    using Git
    using RegistryTools

    include("git.jl")
    include("registering.jl")

    export register
end
