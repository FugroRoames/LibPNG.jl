

@testset "IO" begin
    tmpdir = joinpath(tempdir(), "LibPNG")
    isdir(tmpdir) && rm(tmpdir, recursive = true)
    mkdir(tmpdir)

    img = rand(Bool, 5, 5, 5, 5)
    fn = joinpath(tmpdir, "5x5x5x5.png")
    @test_throws ErrorException writeimage(fn, img)

    @testset "Binary Image" begin
        a = rand(Bool, 10, 10)
        fn = joinpath(tmpdir, "binary1.png")
        writeimage(fn, a)
        b1 = readimage(fn)
        @test b1 == convert(Array{Gray{N0f8}}, a)

        a = bitrand(5,5)
        fn = joinpath(tmpdir, "binary2.png")
        writeimage(fn, a)
        b2 = readimage(fn)
        @test b2 == convert(Array{Gray{N0f8}}, a)

        a = colorview(Gray, a)
        fn = joinpath(tmpdir, "binary3.png")
        writeimage(fn, a)
        b3 = readimage(fn)
        @test b3 == convert(Array{Gray{N0f8}}, a)
    end

    @testset "Gray image" begin
        gray = vcat(fill(Gray(1.0), 10, 10), fill(Gray(0.5), 10, 10), fill(Gray(0.0), 10, 10))
        fn = joinpath(tmpdir, "gray1.png")
        writeimage(fn, gray)
        g1 = readimage(fn)
        @test g1 == convert(Array{Gray{N0f8}}, gray)

        gray = rand(Gray{N0f8}, 5, 5)
        fn = joinpath(tmpdir, "gray2.png")
        writeimage(fn, gray)
        g2 = readimage(fn)
        @test g2 == gray
    end

    @testset "Color - RGB" begin
        rgb8 = rand(RGB{N0f8}, 5, 5)
        fn = joinpath(tmpdir, "rgb_n0f8.png")
        writeimage(fn, rgb8)
        r1 = readimage(fn)
        @test r1 == rgb8

        rgb16 = rand(RGB{N0f16}, 5, 5)
        fn = joinpath(tmpdir, "rgb_n0f16.png")
        writeimage(fn, rgb16)
        r1 = readimage(fn)
        @test r1 ==  rgb16
    end

    @testset "Alpha" begin
        # RGBA
        r = RGBA(1.0,0.0,0.0, 0.2)
        g = RGBA(0.0,1.0,0.0, 0.8)
        b = RGBA(0.0,0.0,1.0, 1.0)
        rgba1 = vcat(fill(r, 50,100), fill(g, 50,100), fill(b, 50,100))
        fn = joinpath(tmpdir, "rgba1.png")
        writeimage(fn, rgba1)
        r1 = readimage(fn)
        @test r1 == rgba1

        # GrayA
        r = GrayA(1.0, 0.25)
        g = GrayA(0.5, 0.5)
        b = GrayA(0.0, 0.75)
        graya = vcat(fill(r, 50,100), fill(g, 50,100), fill(b, 50,100))
        fn = joinpath(tmpdir, "graya1.png")
        writeimage(fn, graya)
        g1 = readimage(fn)
        @test g1 == convert(Array{GrayA{N0f8}}, graya)
    end
    # TODO implement palette
end
