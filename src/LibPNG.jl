module LibPNG

using ColorTypes,
      ImageCore,
      FixedPointNumbers

export readimage, writeimage

if VERSION < v"1.3"
    const depsfile = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
    if isfile(depsfile)
        include(depsfile)
        check_deps()
    end
else
    using libpng_jll
end

include("functions.jl")
include("io.jl")

end # module
