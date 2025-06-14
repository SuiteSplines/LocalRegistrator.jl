@testset "Dry run registering" begin
    withtempdir() do tmp_dir
        # generate some random package name
        pkg_name = "PkgR$(randstring(6))"

        # generate that package
        Pkg.generate(pkg_name)

        # initialize git
        cd(pkg_name) do
            run(pipeline(`$(git()) init`, stdout=devnull))
            run(pipeline(`$(git()) add .`, stdout=devnull))
            run(pipeline(`$(git()) commit -m "init"`, stdout=devnull))
        end
        
        # get pkg path (url)
        pkg_path = expanduser(realpath(pkg_name))

        # dry run
        register(;
            project_url = pkg_path,
            registry_url = "https://github.com/SuiteSplines/SuiteSplinesRegistry.git",
            dry_run=true
        )
    end
end