function withtempdir(f::Function)
    mktempdir() do tmp_dir
        cd(tmp_dir) do
            f(tmp_dir)
        end
    end
    return nothing
end

function confirm(prompt="\nDo you confirm? (y/n): ")
    print(prompt)
    answer = readline()
    return lowercase(strip(answer)) in ["y", "yes"]
end