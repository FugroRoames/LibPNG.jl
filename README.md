# LibPNG

[![Build Status](https://travis-ci.org/FugroRoames/LibPNG.jl.svg?branch=master)](https://travis-ci.org/FugroRoames/LibPNG.jl)
[![Coverage Status](https://coveralls.io/repos/github/FugroRoames/LibPNG.jl/badge.svg?branch=master)](https://coveralls.io/github/FugroRoames/LibPNG.jl?branch=master)

LibPNG bindings for reading and writing png files in Julia.

## Installation

```julia
Pkg.clone("https://github.com/FugroRoames/LibPNG.jl.git")
```

## Usage

```julia
using LibPNG
using ColorTypes

# Write RGB image
pixels = rand(RGB, 10, 10)
writeimage("pixels.png", pixels)
pixels_in = readimage("pixels.png")

# Convert to nchannel × height × width matrix
using ImageCore
pixels_matrix = channelview(pixels_in)
writeimage("pixels_channel.png", pixels_matrix)
```

The supported png image types are `RGB`, `RGBA`, `Gray` and `GrayA` as defined in `ColorTypes.jl`.
The expected memory structure for images are nchannel × height × width.
