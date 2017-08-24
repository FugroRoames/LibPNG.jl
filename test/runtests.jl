using Base.Test
using LibPNG
using Colors
using FixedPointNumbers
using ImageCore

include("images.jl")

tmpdir = joinpath(tempdir(), "LibPNG")
try
    # rm(tmpdir, recursive = true)
end
