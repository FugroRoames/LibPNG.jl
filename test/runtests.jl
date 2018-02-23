using Base.Test
using LibPNG
using ColorTypes
using FixedPointNumbers
using ImageCore
using MicroLogging

configure_logging(min_level=MicroLogging.Debug)

include("images.jl")

tmpdir = joinpath(tempdir(), "LibPNG")
try
    rm(tmpdir, recursive = true)
end