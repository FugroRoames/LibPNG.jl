# LibPNG

[![Build Status](https://travis-ci.org/FugroRoames/LibPNG.jl.svg?branch=master)](https://travis-ci.org/FugroRoames/LibPNG.jl)
[![Coverage Status](https://coveralls.io/repos/github/FugroRoames/LibPNG.jl/badge.svg?branch=master)](https://coveralls.io/github/FugroRoames/LibPNG.jl?branch=master)

Minimal LibPNG bindings for reading/writing png files. This package is
currently a work in progress.

# TODO

* Get image type info before loading the data
* Store data with the corresponding ColorType.jl
* Flip image array so that its a channels×N×M matrix similar to Colors.jl
* Fix up the writing rows stuff
