const PNG_BYTES_TO_CHECK = 8

const PNG_LIBPNG_VER_STRING = "1.2.50"

function png_error_handler(::Ptr{Void}, msg::String)
    error("Png error: $msg")
end

function png_warn_handler(::Ptr{Void}, msg::String)
    warn("Png warn: $msg")
end
const png_error_fn = cfunction(png_error_handler, Void, (Ptr{Void}, Cstring))
const png_warn_fn = cfunction(png_warn_handler, Void, (Ptr{Void}, Cstring))

function readimage(filename::String)
    fp = ccall((:fopen, "libc"), Ptr{Void}, (Cstring, Cstring), filename, "rb")
    fp == C_NULL && error("Failed to open $filename")

    header = zeros(UInt8, PNG_BYTES_TO_CHECK)
    header_size = ccall((:fread, "libc"), Csize_t, (Ptr{UInt8}, Cint, Cint, Ptr{Void}), header, 1, PNG_BYTES_TO_CHECK, fp)
    header_size != 8 && error("Failed to read header from $filename")

    is_png = ccall((:png_sig_cmp, "libpng"), Cint, (Ptr{UInt8}, Csize_t, Csize_t), header, 0, PNG_BYTES_TO_CHECK)
    is_png != 0 && error("File $filename is not a png file")

    png_ptr = ccall((:png_create_read_struct, "libpng"), Ptr{Void}, (Cstring, Ptr{Void}, Ptr{Void}, Ptr{Void}),
                    PNG_LIBPNG_VER_STRING, C_NULL, png_error_fn, png_warn_fn)
    png_ptr == C_NULL && error("Failed to create png read struct")

    info_ptr = ccall((:png_create_info_struct, "libpng"), Ptr{Void}, (Ptr{Void},), png_ptr)
    info_ptr == C_NULL && error("Failed to create png info struct")

    ccall((:png_init_io, "libpng"), Void, (Ptr{Void}, Ptr{Void}), png_ptr, fp)

    ccall((:png_set_sig_bytes, "libpng"), Void, (Ptr{Void}, Cint), png_ptr, PNG_BYTES_TO_CHECK)

    transforms = 0
    # (PNG_TRANSFORM_EXPAND | PNG_TRANSFORM_STRIP_16 | PNG_TRANSFORM_PACKING | PNG_TRANSFORM_STRIP_ALPHA | PNG_TRANSFORM_GRAY_TO_RGB)
    ccall((:png_read_png, "libpng"), Void, (Ptr{Void}, Ptr{Void}, Cint, Ptr{Void}), png_ptr, info_ptr, transforms, C_NULL)

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

    png_ptr_ptr = Ref{Ptr{Void}}(png_ptr)
    info_ptr_ptr = Ref{Ptr{Void}}(info_ptr)
    ccall((:png_destroy_read_struct, "libpng"), Void, (Ref{Ptr{Void}}, Ref{Ptr{Void}}, Ptr{Ptr{Void}}), png_ptr_ptr, info_ptr_ptr, C_NULL)
    ccall((:fclose, "libc"), Cint, (Ptr{Void},), fp)

    return image
end

function writeimage(filename::String, image::AbstractArray)
    fp = ccall((:fopen, "libc"), Ptr{Void}, (Cstring, Cstring), filename, "wb")
    fp == C_NULL && error("Could not open $(filename) for writing")

    png_ptr = ccall((:png_create_write_struct, :libpng), Ptr{Void}, (Cstring, Ptr{Void}, Ptr{Void}, Ptr{Void}),
                    PNG_LIBPNG_VER_STRING, C_NULL, png_error_fn, png_warn_fn)
    png_ptr == C_NULL && error("Failed to create png write struct")

    info_ptr = ccall((:png_create_info_struct, :libpng), Ptr{Void}, (Ptr{Void},), png_ptr)
    info_ptr == C_NULL && error("Failed to create png info struct")

    ccall((:png_init_io, :libpng), Void, (Ptr{Void}, Ptr{Void}), png_ptr, fp)

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

    ccall((:png_write_info, :libpng), Void, (Ptr{Void}, Ptr{Void}), png_ptr, info_ptr)

    row_buf = Array{UInt8}(size(image, 3), size(image,  2))
    for row = 1:size(image, 1)
        row_buf[:] = image[row, :, :].'
        ccall((:png_write_row, :libpng), Void, (Ptr{Void}, Ptr{UInt8}), png_ptr, row_buf)
    end

    ccall((:png_write_end, :libpng), Void, (Ptr{Void}, Ptr{Void}), png_ptr, info_ptr)

    png_ptr_ptr = Ref{Ptr{Void}}(png_ptr)
    info_ptr_ptr = Ref{Ptr{Void}}(info_ptr)
    ccall((:png_destroy_write_struct, :libpng), Void, (Ref{Ptr{Void}}, Ref{Ptr{Void}}), png_ptr_ptr, info_ptr_ptr)

    ccall((:fclose, "libc"), Cint, (Ptr{Void},), fp)

    return nothing
end
