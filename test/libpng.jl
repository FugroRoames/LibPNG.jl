@testset "Read / Write" begin
    tmp_dir = tempname()
    mkdir(tmp_dir)
    try
        srand(123)
        orig_image = rand(UInt8, 1000, 2000, 3)
        test_file1 = joinpath(tmp_dir, "test1.png")
        test_file2 = joinpath(tmp_dir, "test2.png")
        writeimage(test_file1, orig_image)

        image_in = readimage(test_file1)
        @test orig_image == image_in

        writeimage(test_file2, image_in)
        image_out = readimage(test_file2)
        @test image_out == image_in
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
