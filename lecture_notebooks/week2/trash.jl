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








function pad(data, border=1)
  padded_size = map(s->s+2*border, size(data))
  padded_range = map(s->(1-border):(s+border), size(data))
  range = CartesianIndices(map(s->1:s, size(data)))

  odata = OffsetArray(zeros(eltype(data), padded_size), padded_range...)
  odata[range] = data
  odata, collect(range)
end

gpu_range = cu(range);

padded_img, range = pad(img, size(filter, 1) ÷ 2);

begin
  blurred = similar(img)
  blurred .= convolve2D.(range, (padded_img,), (filter,))
end

begin
  # Really need to finish https://github.com/JuliaArrays/OffsetArrays.jl/pull/57
  import CUDA.Adapt
  Adapt.adapt_structure(to, x::OffsetArray) = OffsetArray(Adapt.adapt(to, parent(x)), x.offsets)
  Base.Broadcast.BroadcastStyle(::Type{<:OffsetArray{<:Any, <:Any, AA}}) where AA = Base.Broadcast.BroadcastStyle(AA)
  forcerun = nothing
end
