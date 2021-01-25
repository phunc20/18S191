md"## Gaussian filter"
The user decides where the data lives and the computation follows!






σ = 4
begin
  img = load(download("https://raw.githubusercontent.com/JuliaLang/julia-logo-graphics/master/images/julia-logo-color.png"))
end


begin
  Pkg.activate(mktempdir())
  
  #Pkg.add("Colors")
  Pkg.add("Images")
  #Pkg.add("ImageMagick")
  #Pkg.add("ImageFiltering")
  
  using Images
  #using PlutoUI
  #using ImageMagick
  #using ImageFiltering
end

md"
# Cartesian Indices
"





Pkg.add("AbstractArray")



gpu_range = cu(range);

padded_img, range = pad(img, size(filter, 1) ÷ 2);
SparseMatrixCSC
