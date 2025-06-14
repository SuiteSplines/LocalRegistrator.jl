"""
    istoplevel(path::String)

Returns `true` if a top-level repository is located at `path` and `false` otherwise.
It does not throw an exception if the `git` process fails.
"""
function istoplevel(path::String)
    path = expanduser(realpath(path))
    buf = IOBuffer()

    try
        run(pipeline(`$(git()) -C $path rev-parse --show-toplevel`, stdout=buf, stderr=buf))
    catch e
        if !isa(e, ProcessFailedException)
            throw(e)
        end
    end

    return chomp(String(take!(buf))) == path
end