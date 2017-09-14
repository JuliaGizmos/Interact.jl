using Compat

function main()
    info("Enabling widgetsnbextension")
    try
        run(`$(IJulia.jupyter) nbextension enable --py widgetsnbextension`)
    catch err
        warn("Could not enable widgetsnbextension")
    end

    if is_linux() || is_apple()
        python = strip(readline(readstring(`which $(IJulia.jupyter)`)|>strip), ['\n',' ', '#','!'])
    elseif is_windows()
        warn("cannot determine jupyter's python path in Windows, bailing.")
        return
    end

    try
        ipywver = readstring(`$python -c 'import ipywidgets; print(ipywidgets.__version__)'`) |> strip |> VersionNumber
        write("ipywidget_version", string(ipywver))

        info("ipywidgets version found: $ipywver")
        if ipywver < v"5.0.0"
            warn("""This version of Interact requires ipywidgets > 5.0 to work correctly.
                    If you have ipywidgets version 4.x, run Pkg.checkout("Interact", "ipywidgets-4").""")
        else
            info("A compatible version of ipywidgets was found. All good.")
        end
    catch err
        warn("Could not determine ipywidgets version.")
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
