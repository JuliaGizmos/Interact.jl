using Compat

const widgver_file = joinpath(dirname(@__FILE__), "widgets_version")

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
        run(`$nbextension_cmd install --py widgetsnbextension`)
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
            vers = isfile(widgver_file) ? readline(widgver_file)*" (found in $widgver_file)" : ">= 3.0.0"
            warn("""Cannot determine Jupyter's python.exe, will guess that you have
widgetsnbextension $vers. Otherwise, set ENV["PYTHON"] to the path of your
python.exe and re-run Pkg.build("Interact"), or manually edit $widgver_file to
the value of widgetsnbextension.__version__, or set e.g.
ENV["WIDGETS_VERSION"]="2.0.0" before you run `using Interact` """)
            return
        end
    end

    try
        rm(widgver_file, force=true) # remove old version, if any
        widgver = readstring(`$python -c 'import widgetsnbextension; print(widgetsnbextension.__version__)'`) |> strip |> VersionNumber
        write(widgver_file, string(widgver))

        info("widgetsnbextension version found: $widgver")
        if widgver < v"1.0.0"
            warn("""This version of Interact requires widgetsnbextension >= 1.0.0 to work correctly.
                    If you have widgetsnbextension version 0.x, run Pkg.checkout("Interact", "ipywidgets-4").""")
        else
            info("A compatible version of widgetsnbextension was found. All good.")
        end
    catch
        warn("""Could not determine widgetsnbextension version from $python, will guess that you
have ≥ 3.0. If widgets do not display, manually edit $widgver_file to 2.0.0 (or
the value of widgetsnbextension.__version__ ), or set
ENV["WIDGETS_VERSION"]="2.0.0" before you run `using Interact`""")
        write(widgver_file, "3.0.0")
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
