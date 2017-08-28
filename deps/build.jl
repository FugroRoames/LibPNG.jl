using BinDeps

@BinDeps.setup

deps = [
    libpng = library_dependency("libpng", aliases = ["libpng","libpng-1.5.14","libpng15","libpng12.so.0","libpng12"])
    zlib = library_dependency("zlib", aliases = ["libzlib","zlib1"], os = :Windows)
]

provides(AptGet, "libpng12-0", libpng)

if is_windows()
    using WinRPM
    provides(WinRPM.RPM, "zlib-devel", zlib, os = :Windows)
    provides(WinRPM.RPM, "libpng-dev", libpng, os = :Windows)
end

@BinDeps.install Dict(:libpng => :libpng)
