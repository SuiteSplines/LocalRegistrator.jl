"""
    istoplevel(path::String)

Returns `true` if a top-level repository is located at `path` and `false` otherwise.
It does not throw an exception if the `git` process fails.
"""
function istoplevel(path::String)
    !isdir(path) && return false
    path = expanduser(realpath(path))
    stdout = IOBuffer()
    stderr = IOBuffer()

    try
        run(pipeline(`$(git()) -C $path rev-parse --show-toplevel`, stdout=stdout, stderr=stderr))
    catch e
        if !isa(e, ProcessFailedException)
            throw(e)
        end
    end

    return chomp(String(take!(stdout))) == path
end

"""
    isdirty(path::String)

Returns `true` if the repository located at `path` is dirty and `false` otherwise.
It does not throw an exception if the `git` process fails.
"""
function isdirty(path::String)
    @assert istoplevel(path)
    path = expanduser(realpath(path))
    cmd = pipeline(`$(git()) -C $path diff --quiet`)
    !success(run(cmd; wait=false))
end


"""
    head_commit_hash(path::String)

Returns commit hash of `HEAD` in repository located at `path`. The repository
must exist and be a top-level repository, see [istoplevel](@ref).
"""
function head_commit_hash(path::String)
    @assert istoplevel(path)
    return readchomp(`$(git()) -C $path rev-parse HEAD`)
end


"""
    tree_hash(path::String; commit::String = "HEAD")

Returns tree hash of `commit` in repository located at `path`. The repository
must exist and be a top-level repository, see [istoplevel](@ref).
"""
function tree_hash(path::String; commit::S="HEAD") where {S<:AbstractString}
    @assert istoplevel(path)
    return readchomp(`$(git()) -C $path rev-parse $commit^\{tree\}`)
end
