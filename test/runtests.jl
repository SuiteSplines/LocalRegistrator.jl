using LocalRegistrator
using Test

tests = [
    "git",
    "registering"
]

@testset "LocalRegistrator.jl" begin

    # run all unit-tests
    for t in tests
        fp = joinpath(dirname(@__FILE__), "$t.jl")
        println("$fp ...")
        include(fp)
    end

end # @testset
