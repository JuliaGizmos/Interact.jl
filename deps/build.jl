using Compat

const ipywidgets_version = joinpath(dirname(@__FILE__), "ipywidgets_version")

function main()
    info("Enabling widgetsnbextension")
    try
        if IJulia.notebook_cmd[1] == IJulia.jupyter
            nbextension_cmd = [IJulia.jupyter, "nbextension"]
        else
            if endswith(IJulia.notebook_cmd[1], "python.exe")
                nbextension_cmd = IJulia.notebook_cmd[1:2]
            else
                nbextension_cmd = IJulia.notebook_cmd[1:1]
            end
            n = nbextension_cmd[end]
            ni = rsearch(n, "notebook")
            nbextension_cmd[end] = n[1:prevind(n,first(ni))] * "nbextension" * n[nextind(n,last(ni)):end]
        end
        run(`$nbextension_cmd enable --py widgetsnbextension`)
    catch
        warn("Could not enable widgetsnbextension.")
    end

    if is_linux() || is_apple()
        python = strip(readline(readstring(`which $(IJulia.jupyter)`)|>strip), ['\n',' ', '#','!'])
    elseif is_windows()
        if endswith(IJulia.notebook_cmd[1], "python.exe")
            python = IJulia.notebook_cmd[1]
        elseif startswith(IJulia.jupyter, Pkg.dir("Conda")) # using the Conda Python
            python = joinpath(eval(Main, :(using Conda; Conda.PYTHONDIR)), "python.exe")
        elseif haskey(ENV,"PYTHON") && !isempty(ENV["PYTHON"])
            python = ENV["PYTHON"]
        else
            vers = isfile(ipywidgets_version) ? readline(ipywidgets_version) : "6.0"
            warn("""Cannot determine Jupyter's python.exe, will guess that you have ipywidgets $vers.
                    Otherwise, set ENV["PYTHON"] to the path of your python.exe, or manually edit
                    $ipywidgets_version to the value of ipywidgets.__version__.""")
            return
        end
    end

    try
        rm(ipywidgets_version, force=true) # remove old version, if any
        ipywver = readstring(`$python -c 'import ipywidgets; print(ipywidgets.__version__)'`) |> strip |> VersionNumber
        write(ipywidgets_version, string(ipywver))

        info("ipywidgets version found: $ipywver")
        if ipywver < v"5.0.0"
            warn("""This version of Interact requires ipywidgets > 5.0 to work correctly.
                    If you have ipywidgets version 4.x, run Pkg.checkout("Interact", "ipywidgets-4").""")
        else
            info("A compatible version of ipywidgets was found. All good.")
        end
    catch
        warn("Could not determine ipywidgets version from $python, will guess that you have ≥ 6.0.")
    end
end

if isa(Pkg.installed("IJulia"), VersionNumber)
    if Pkg.installed("IJulia") < v"1.3.3"
        warn("This version of Interact requires IJulia version >= v1.3.3. Run Pkg.update(\"IJulia\") to get it.")
    end
    using IJulia
    main()
else
    warn("""IJulia is not installed. run Pkg.build("Interact")
            once you install IJulia to use Interact inside IJulia""")
end
