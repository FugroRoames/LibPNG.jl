using Test
using LibPNG
using ColorTypes
using FixedPointNumbers
using ImageCore
using Logging
using Random

logger = ConsoleLogger(stdout, Logging.Debug)
global_logger(logger)

include("images.jl")

tmpdir = joinpath(tempdir(), "LibPNG")
try
    rm(tmpdir, recursive = true)
catch
    @error "Unable to remove temp directory at: $(tmpdir)"
end