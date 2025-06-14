using Git

function withtempdir(f::Function)
    mktempdir() do tmp_dir
        cd(tmp_dir) do
            f(tmp_dir)
        end
    end
    return nothing
end

@testset "Check if is a toplevel repository" begin
    withtempdir() do tmp_dir
        # tmp dir is not yet a git repo
        @test LocalRegistrator.istoplevel(tmp_dir) == false

        # initialize empty git repo in tmp_dir
        run(`$(git()) init`)

        # test discovery
        @test LocalRegistrator.istoplevel(tmp_dir) == true

        # test discovery with trailing slash
        @test LocalRegistrator.istoplevel(joinpath(tmp_dir,"")) == true
    end
end