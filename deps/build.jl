using Compat

function main()

    @static if is_linux() || is_apple()
        python = strip(readline(readstring(`which $(IJulia.jupyter)`)|>strip), ['\n',' ', '#','!'])
    elseif is_windows()
        warn("cannot determine jupyter's python path in Windows, bailing.")
        return
    end
    ipywver = readstring(`$python -c 'import ipywidgets; print ipywidgets.__version__'`) |> strip |> VersionNumber

    info("ipywidgets version found: $ipywver")
    if ipywver < v"5.0.0"
        warn("""This version of Interact requires ipywidgets > 5.0 to work correctly.
                If you have ipywidgets version 4.x, run Pkg.checkout("Interact", "ipywidgets-4").""")
    else
        info("A compatible version of ipywidgets was found. All good.")
    end
end

if isa(Pkg.installed("IJulia"), VersionNumber)
    using IJulia
    main()
else
    warn("""IJulia is not installed. run Pkg.build("Interact")
            once you install IJulia to use Interact inside IJulia""")
end
