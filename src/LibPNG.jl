__precompile__()

module LibPNG

using libpng_jll,
      ColorTypes,
      ImageCore,
      FixedPointNumbers

export readimage, writeimage


include("functions.jl")
include("io.jl")

end # module
