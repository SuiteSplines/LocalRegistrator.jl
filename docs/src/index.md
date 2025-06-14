```@meta
CurrentModule = LocalRegistrator
```

# LocalRegistrator

The [LocalRegistrator](https://github.com/SuiteSplines/LocalRegistrator.jl) package can be used to
register packages in local registries like [SuiteSplinesRegistry](https://github.com/SuiteSplines/SuiteSplinesRegistry).

`LocalRegistrator` not only adds an entry to the local registry but does so
in such a way that the `RegistryCI.jl` workflows can be triggered. In particular,
it pushes new branches with specific commits including the required metadata.

```
commit 63f80182919aee9c11bfbee921cf82cfb3e1f7c3 (HEAD -> registrator-pkgrjafoyj-0b413700-v0.1.0-201387a467)
Author: John Smith <john@smith.com>
Date:   Sat Jun 14 18:10:40 2025 +0200

    #New package: PkgRjAfOyj v0.1.0
    
    - UUID: 0b413700-5fdb-4858-b8d2-f50f66534dc9
    - Repository: /tmp/jl_kCBk2I/PkgRjAfOyj
    - Tree: be22417d679128c823d779bdf18ce9ab2da3ca6f
    - Commit: b03f9009f34745b657652b7e475ec23ece457fb2
    - Version: v0.1.0
    - Labels: new package
```

## Workflow

1. Make sure your remote repository and the default branch are up to date. This includes merging any local changes and bumping the version in `Project.toml`. Use [semantic versioning](https://semver.org/).

2. Use `LocalRegistrator` to register the package. You will need the remote URL of the package in question as well as the remote URL of the target registry.

```
register(; project_url="https://github.com/SuiteSplines/SuiteSplinesExamplePkg.jl.git",\
           registry_url="https://github.com/SuiteSplines/SuiteSplinesRegistry.git")
```

3. At the end, you will see the included commit message and be prompted to confirm pushing the new branch to the remote registry.


## Index
```@index
```

```@autodocs
Modules = [LocalRegistrator]
Order   = [:function, :type]
```