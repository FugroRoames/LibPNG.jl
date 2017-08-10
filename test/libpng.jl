@testset "Read / Write" begin
    tmp_dir = tempname()
    mkdir(tmp_dir)
    try
        srand(123)
        test_file1 = joinpath(tmp_dir, "test1.png")
        rgb_image = rand(RGB{Float64}, 500, 2000)

        r = RGB(1.0,0.0,0.0)
        g = RGB(0.0,1.0,0.0)
        b = RGB(0.0,0.0,1.0)
        rgb_image1 = vcat(fill(r, 50,100), fill(g, 50,100), fill(b, 50,100))
        writeimage(test_file1, rgb_image1, 8, Colors.RGB, 0, 0, 0)
        img_in1 = readimage(test_file1)

        test_file2 = joinpath(tmp_dir, "test2.png")
        r = zeros(UInt8, 50, 100, 3)
        r[:,:,1] = 255
        r[:,:,2] = 0
        r[:,:,3] = 0
        g = zeros(UInt8, 50, 100, 3)
        g[:,:,1] = 0
        g[:,:,2] = 255
        g[:,:,3] = 0
        b = zeros(UInt8, 50, 100, 3)
        b[:,:,1] = 0
        b[:,:,2] = 0
        b[:,:,3] = 255

        rgb_image2 = vcat(r,g,b)
        writeimage(test_file2, rgb_image2, 8, Colors.RGB, 0, 0, 0)
        img_in2 = readimage(test_file2)

        @test img_in1 == img_in2
    finally
        rm(tmp_dir; force = true, recursive = true)
    end
end

# image = readimage(joinpath(Pkg.dir("RoamesVegGrowth"), "test", "pole.png"))
# @time image = readimage(joinpath(Pkg.dir("RoamesVegGrowth"), "test", "pole.png"))
#
# println("Read pole.png success")
#
# im_path = Pkg.dir("RoamesVegGrowth")*"/test/"*"out.png"
#
# writeimage("out.png", image)
# @time writeimage("out.png", image)
# println("Write out.png success")
#
# im_out = readimage(im_path)
# println("Read out.png success")

#-----------------------------------
# Benchmarks

# Libpng
# julia> @time image = readimage(joinpath(Pkg.dir("RoamesVegGrowth"), "test", "pole.png"));
#   0.058403 seconds (134 allocations: 4.566 MiB)
#
#   julia> @time writeimage("out.png", image)
#   0.116268 seconds (4.78 k allocations: 9.455 MiB, 4.50% gc time)
#
# Images.jl
#   julia> @time load("pole.png");
#   0.587984 seconds (267 allocations: 9.131 MiB, 1.59% gc time)
#
#   julia> @time save("out.png", im)
#   0.097268 seconds (297 allocations: 9.132 MiB, 7.05% gc time)
