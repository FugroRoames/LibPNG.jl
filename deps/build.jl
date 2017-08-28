using BinDeps

@BinDeps.setup

deps = [
    libpng = library_dependency("libpng", aliases = ["libpng","libpng-1.5.14","libpng15","libpng12.so.0","libpng12"])
]

@BinDeps.install Dict(:libpng => :libpng)
