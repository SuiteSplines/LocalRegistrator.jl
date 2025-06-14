"""
    register(; project_url::S, registry_url::S, registry_deps::Vector{S}=["https://github.com/JuliaRegistries/General.git"], dry_run::Bool=false) where {S<:AbstractString}

Register lastest version of a package located at `project_url` (in best case a remote repository) in a local registry located at `registry_url`, e.g.

```julia-repl
register(; project_url="https://github.com/SuiteSplines/SuiteSplinesExamplePkg.jl.git", registry_url="https://github.com/SuiteSplines/SuiteSplinesRegistry.git")
```

If your package depends on some other local repositories, include these in `registry_deps`. The General repository is included by default.
"""
function register(; project_url::S, registry_url::S, registry_deps::Vector{S}=["https://github.com/JuliaRegistries/General.git"], dry_run::Bool=false) where {S<:AbstractString}
    # work in temporary directory
    withtempdir() do tmp_dir
        @info "Temporary work directory '$tmp_dir'"

        # get random path for repository clone
        project_path = randstring(8)

        # clone repository
        run(`$(git()) clone --depth 1 $project_url $project_path`)

        # define project toml path
        project_toml_path = joinpath(project_path, "Project.toml")

        # parse Project.toml
        project = TOML.parsefile(project_toml_path)

        # get head tree hash
        project_tree_hash = tree_hash(project_path)

        # get head commit hash
        project_commit_hash = head_commit_hash(project_path)

        # register using RegistryTools.jl
        reg = RegistryTools.register(project_url, project_toml_path, project_tree_hash;
            registry = registry_url,
            registry_deps = registry_deps,
            push = false
        )

        # check status of reg for errors
        haskey(reg.metadata, "error") && error(reg.metadata["error"])
        
        # get all registries used by RegistryTools.jl
        registries = readdir("registries")

        # traverse registries directory by directory
        for dir in registries
            # look for target registry
            data = TOML.parsefile(joinpath("registries", dir, "Registry.toml"))
            data["repo"] !== registry_url && continue

            # change to target registry
            cd(joinpath("registries", dir)) do
                # new commit message with required metadata
                new_commit_message = """
                #$(reg.metadata["kind"]): $(project["name"]) v$(project["version"])

                - UUID: $(project["uuid"])
                - Repository: $project_url
                - Tree: $project_tree_hash
                - Commit: $project_commit_hash
                - Version: v$(project["version"])
                - Labels: $(join(reg.metadata["labels"], ", "))
                """

                # amend last commit to conform with RegistryCI.TagBot
                run(`$(git()) commit --amend -m "$new_commit_message"`)

                # print last log entry
                println("")
                run(`$(git()) --no-pager log -1`)

                if !dry_run && confirm()
                    @info "Pushing branch '$(reg.branch)' to $registry_url..."
                    run(`$(git()) push -u origin $(reg.branch)`)
                end
            end
        end
    end

end