@testset "Check if is a toplevel repository" begin
    withtempdir() do tmp_dir
        # tmp dir is not yet a git repo
        @test istoplevel(tmp_dir) == false

        # initialize empty git repo in tmp_dir
        run(pipeline(`$(git()) init`, stdout=devnull))

        # test discovery
        @test istoplevel(tmp_dir) == true

        # test discovery with trailing slash
        @test istoplevel(joinpath(tmp_dir,"")) == true

        # test discovery with not existing directory
        @test istoplevel(randstring(42)) == false
    end
end

@testset "Get last commit hashes" begin
    withtempdir() do tmp_dir
        # create some file in tmp_dir
        write(joinpath(tmp_dir, "README.md"), "# Temporary Repo")

        # initialize empty git repo in tmp_dir
        run(pipeline(`$(git()) init`, stdout=devnull))

        # add README.md
        run(pipeline(`$(git()) add README.md`, stdout=devnull))

        # add a commit and capture output
        buf = IOBuffer()
        run(pipeline(`$(git()) commit -m "add README.md"`, stdout=buf))
        output = chomp(String(take!(buf)))

        # parse output for short hash
        short_hash = match(r"\[.* (\w+)\]", output).captures[1]

        # test
        hash = head_commit_hash(tmp_dir)
        @test (length(hash) == 40 || length(hash) == 64) == true
        @test hash[1:7] == short_hash
    end
end

@testset "Get tree hashes" begin
    withtempdir() do tmp_dir
        # create some file in tmp_dir
        write(joinpath(tmp_dir, "README.md"), "# Temporary Repo")

        # initialize empty git repo in tmp_dir
        run(pipeline(`$(git()) init`, stdout=devnull))

        # add README.md
        run(pipeline(`$(git()) add README.md`, stdout=devnull))

        # add a commit and capture output
        buf = IOBuffer()
        run(pipeline(`$(git()) commit -m "add README.md"`, stdout=buf))
        output = chomp(String(take!(buf)))

        # parse output for short hash
        short_commit_hash = match(r"\[.* (\w+)\]", output).captures[1]

        # test
        commit_hash = head_commit_hash(tmp_dir)
        head_tree_hash = tree_hash(tmp_dir)
        commit_tree_hash = tree_hash(tmp_dir; commit=commit_hash)
        @test (length(head_tree_hash) == 40 || length(head_tree_hash) == 64) == true
        @test (length(commit_tree_hash) == 40 || length(commit_tree_hash) == 64) == true
        @test head_tree_hash == commit_tree_hash

        # test (for short commit hash)
        commit_tree_hash = tree_hash(tmp_dir; commit=short_commit_hash)
        @test (length(commit_tree_hash) == 40 || length(commit_tree_hash) == 64) == true
        @test head_tree_hash == commit_tree_hash
    end
end