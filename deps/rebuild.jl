
rm(joinpath(dirname(@__FILE__), "deps.jl"); force=true)
rm(joinpath(dirname(@__FILE__), "usr"); force=true, recursive=true)
rm(joinpath(dirname(@__FILE__), "src"); force=true, recursive=true)

include("build.jl")
