using Ventilador
using Documenter

DocMeta.setdocmeta!(Ventilador, :DocTestSetup, :(using Ventilador); recursive=true)

makedocs(;
    modules=[Ventilador],
    authors="glrme-arauo <glrme_araujo@hotmail.com> and contributors",
    sitename="Ventilador.jl",
    format=Documenter.HTML(;
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
