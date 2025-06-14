using Test
using Pkg, Git, Random

using LocalRegistrator
import LocalRegistrator: confirm, istoplevel, isdirty, head_commit_hash, tree_hash, withtempdir


tests = [
    "base",
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
