using Compat

if isa(Pkg.installed("IJulia"), VersionNumber)
    using IJulia
    python = strip(readline(IJulia.jupyter), ['\n',' ', '#','!'])
    ipywver = readstring(`$python -c 'import ipywidgets; print ipywidgets.__version__'`) |> strip |> VersionNumber
    if ipywver < v"5.0.0"
        warn("""This version of Interact requires ipywidgets > 5.0 to work correctly.
                If you have ipywidgets version 4.x, run Pkg.checkout("Interact", "ipywidgets-4").""")
    else
        info("A compatible version of ipywidgets was found. All good.")
    end
else
    warn("""IJulia is not installed. run Pkg.build("Interact")
            once you install IJulia to use Interact inside IJulia""")
end
