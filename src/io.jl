
function readimage(filename::String, transforms::Int = 0)
    fp = open_png(filename)

    png_ptr = create_read_struct()
    info_ptr = create_info_struct(png_ptr)
    png_init_io(png_ptr, fp)
    png_set_sig_bytes(png_ptr)

    png_read_png(png_ptr, info_ptr, transforms)

    width = ccall((:png_get_image_width, "libpng"), UInt32, (Ptr{Void}, Ptr{Void}), png_ptr, info_ptr)
    height = ccall((:png_get_image_height, "libpng"), UInt32, (Ptr{Void}, Ptr{Void}), png_ptr, info_ptr)
    num_channels = ccall((:png_get_channels, "libpng"), UInt8, (Ptr{Void}, Ptr{Void}), png_ptr, info_ptr)

    rows = ccall((:png_get_rows, "libpng"), Ptr{Ptr{UInt8}}, (Ptr{Void}, Ptr{Void}), png_ptr, info_ptr)

    image = zeros(UInt8, height, width, num_channels)
    for i = 1:height
        row = unsafe_load(rows, i)
        for j = 1:width
            for c = 1:num_channels
                image[i, j, c] = unsafe_load(row, num_channels * (j - 1) + c)
            end
        end
    end

    png_destroy_read_struct(png_ptr, info_ptr)

    close_png(fp)

    return image
end

function writeimage(filename::String, image::AbstractArray)
    fp = ccall((:fopen, "libc"), Ptr{Void}, (Cstring, Cstring), filename, "wb")
    fp == C_NULL && error("Could not open $(filename) for writing")

    png_ptr = png_create_write_struct(png_error_fn, png_warn_fn)
    info_ptr = png_create_info_struct(png_ptr)
    png_init_io(png_ptr, fp)

    height = size(image, 1)
    width = size(image, 2)
    bit_depth = 8
    PNG_COLOR_TYPE_RGB = 2
    PNG_INTERLACE_NONE = 0
    PNG_COMPRESSION_TYPE_BASE = 0
    PNG_FILTER_TYPE_BASE = 0

    ccall((:png_set_IHDR, :libpng), Void,
          (Ptr{Void}, Ptr{Void}, Cuint, Cuint, Cint, Cint, Cint, Cint, Cint),
          png_ptr, info_ptr, width, height, bit_depth, PNG_COLOR_TYPE_RGB, PNG_INTERLACE_NONE,
          PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE)

    png_write_info(png_ptr, info_ptr)

    row_buf = Array{UInt8}(size(image, 3), size(image,  2))
    for row = 1:size(image, 1)
        row_buf[:] = image[row, :, :].'
        ccall((:png_write_row, :libpng), Void, (Ptr{Void}, Ptr{UInt8}), png_ptr, row_buf)
    end

    ccall((:png_write_end, :libpng), Void, (Ptr{Void}, Ptr{Void}), png_ptr, info_ptr)

    png_destroy_read_struct(png_ptr, info_ptr)

    close_png(fp)

    return nothing
end
