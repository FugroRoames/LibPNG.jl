# # color_type masks
# const PNG_COLOR_MASK_PALETTE = 1
# const PNG_COLOR_MASK_COLOR   = 2
# const PNG_COLOR_MASK_ALPHA   = 4
#
# # color types
# const PNG_COLOR_TYPE_GRAY       = 0
# const PNG_COLOR_TYPE_PALETTE    = PNG_COLOR_MASK_COLOR | PNG_COLOR_MASK_PALETTE
# const PNG_COLOR_TYPE_RGB        = PNG_COLOR_MASK_COLOR
# const PNG_COLOR_TYPE_RGB_ALPHA  = PNG_COLOR_MASK_COLOR | PNG_COLOR_MASK_ALPHA
# const PNG_COLOR_TYPE_GRAY_ALPHA = PNG_COLOR_MASK_ALPHA
#
# # color type aliases
# const PNG_COLOR_TYPE_RGBA = PNG_COLOR_TYPE_RGB_ALPHA
# const PNG_COLOR_TYPE_GA   = PNG_COLOR_TYPE_GRAY_ALPHA

# @enum ColorMask MPalette=1 MColor=2 MAlpha=4
# @enum ColorType Gray=0 Palette=3 RGB=2 RGBA=6 GRAYA=4


# TODO interlace, compression_type, filter_type

get_color_type(::Type{Gray})  = 0
get_color_type(::Type{RGB})   = 2
get_color_type(::Type{AGray}) = 4
get_color_type(::Type{ARGB})  = 6
