function withtempdir(f::Function)
    mktempdir() do tmp_dir
        cd(tmp_dir) do
            f(tmp_dir)
        end
    end
    return nothing
end

function confirm(prompt="\nDo you confirm? (y/n): "; input_function::Function=readline)
    print(prompt)
    answer = input_function()
    return lowercase(strip(answer)) in ["y", "yes"]
end