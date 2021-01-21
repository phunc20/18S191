md"## Gaussian filter"
The user decides where the data lives and the computation follows!

convolve2D.(range, ((padded_img),), (filter,));
convolve2D.(cu(range), (cu(padded_img),), (filter,));

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


begin
  f = ind -> ind.I
  f.(CartesianIndices( (-2:2, -1:1) ))
end

neighbors(CartesianIndices((0,0)), 3)

begin
  G(x, y, σ=0.5) = 1/sqrt(2*π*σ^2) * e^(-(x^2+y^2)/(2*σ^2))
  G(I::CartesianIndices{2}, σ=0.5) = G(I.I..., σ)
end

function gaussian_filter(σ, l=4*ceil(Int,σ)+1)
  w = l ÷ 2
  # SMatrix: A performance hack here.
  gauss = SMatrix{1,1}(map(i->G(i, σ), CartesianIndices((-w:w, -w:w))))
  gauss ./ sum(gauss)
end

@inline function neighbors(I::CartesianIndices{N}, L::Int) where N
  w = L ÷ 2
  ntuple(i->(I.I[i]-w):(I.I[i]+w), Val(N))
end

function convolve2D(I, A, filter)  # one convolution at I
  neighborhood = neighbors(I, size(filter, 1))  # assume square filters
  data = @inbounds SMatrix{size(filter)...}(view(A, neighborhood...))
  sum(data .* filter)  # here's the math
end
