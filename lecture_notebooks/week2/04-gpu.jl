### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ a9fbe424-5bae-11eb-39fc-614d047ec480
using Pkg

# ╔═╡ 7caf8746-5bae-11eb-1ed8-eb6b32e6a7e6
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

# ╔═╡ 52d6a726-5e27-11eb-03a9-410141811719
md"
# Cartesian Indices
"

# ╔═╡ 5296590a-5e27-11eb-28c9-157900df4637
begin
  f = ind -> ind.I
  f.(CartesianIndices( (-2:2, -1:1) ))
end

# ╔═╡ f79c53b0-5e26-11eb-32fc-457b50f30471
md"# Code Portability
Julia can run on the CPU or GPU. Such portability is the holy grail of HPC computer science.

The user decides where the data lives and the computation follows!
"

# ╔═╡ f730aa02-5e26-11eb-1d0a-19ed64679ea2
#convolve2D.(    range,   ((padded_img),), (filter,));
#convolve2D.(cu(range), (cu(padded_img),), (filter,));

# ╔═╡ f6aa7824-5e26-11eb-0da9-b97c615448d1
# CPU
#@elapsed(bench(blurred, padded_img, range, filter)

# ╔═╡ fff0ca24-5e27-11eb-2a2c-f75b443f7197
# GPU
#@elapsed(CUDA.@sync bench(gpu_blurred, gpu_img, gpu_range, filter)

# ╔═╡ ffcfc534-5e27-11eb-0454-a7d6879ca011


# ╔═╡ ffae8810-5e27-11eb-1ecd-edef45377856


# ╔═╡ 38869270-5baa-11eb-25eb-83cddddac6dc
md"## Gaussian filter
We are going to apply a Gaussian filter to the image.
"

# ╔═╡ 84fd13a6-5baa-11eb-3dca-fddfcc6f03d9
σ = 4

# ╔═╡ 32e9445e-5bad-11eb-0d67-d1798bb221ce
begin
  img = load(download("https://raw.githubusercontent.com/JuliaLang/julia-logo-graphics/master/images/julia-logo-color.png"))
end

# ╔═╡ 5c5d695a-5e28-11eb-24a8-6bb3c012ec2d
md"The user decides where the data lives and the computation follows!
We are girst going to define a gaussian filter as a \"window\" and then convolve that filter with the image, by first padding the image and then broadcasting
the convolution operation.
"

# ╔═╡ aae9636c-5e28-11eb-00fb-17900f53bf4e
begin
  G(x, y, σ=0.5) = 1/sqrt(2*π*σ^2) * e^(-(x^2+y^2)/(2*σ^2))
  G(I::CartesianIndices{2}, σ=0.5) = G(I.I..., σ)
end

# ╔═╡ 0adb8318-5e29-11eb-25a2-c5a439acb115
function gaussian_filter(σ, l=4*ceil(Int,σ)+1)
  w = l ÷ 2
  # SMatrix: A performance hack here.
  gauss = SMatrix{1,1}(map(i->G(i, σ), CartesianIndices((-w:w, -w:w))))
  gauss ./ sum(gauss)
end

# ╔═╡ 0abbec60-5e29-11eb-3872-112430e3f0d3
@inline function neighbors(I::CartesianIndex{N}, L::Int) where N
  w = L ÷ 2
  ntuple(i->(I.I[i]-w):(I.I[i]+w), Val(N))
end

# ╔═╡ 5249af92-5e27-11eb-316d-7dc0bbc6b8f5
neighbors(CartesianIndex((0,0)), 3)

# ╔═╡ 0aa584fc-5e29-11eb-1036-73bfd7ab888d
function convolve2D(I, A, filter)  # one convolution at I
  neighborhood = neighbors(I, size(filter, 1))  # assume square filters
  data = @inbounds SMatrix{size(filter)...}(view(A, neighborhood...))
  sum(data .* filter)  # here's the math
end

# ╔═╡ 0a890912-5e29-11eb-0a7a-4ba3e9ff6da1


# ╔═╡ 0a69da56-5e29-11eb-1983-15df52de477e


# ╔═╡ 56088d28-5bb5-11eb-00ce-2170b0c6ecc0
function pad(data, border=1)
  padded_size = map(s->s+2*border, size(data))
  padded_range = map(s->(1-border):(s+border), size(data))
  range = CartesianIndices(map(s->1:s, size(data)))

  odata = OffsetArray(zeros(eltype(data), padded_size), padded_range...)
  odata[range] = data
  odata, collect(range)
end

# ╔═╡ 5eb5e576-5bb5-11eb-265c-c339f547c12b
padded_img, range = pad(img, size(filter, 1) ÷ 2);

# ╔═╡ 5ef67d3e-5bb5-11eb-29ff-556cdba4b5b0
gpu_range = cu(range);

# ╔═╡ Cell order:
# ╟─52d6a726-5e27-11eb-03a9-410141811719
# ╠═5296590a-5e27-11eb-28c9-157900df4637
# ╠═5249af92-5e27-11eb-316d-7dc0bbc6b8f5
# ╠═f79c53b0-5e26-11eb-32fc-457b50f30471
# ╠═f730aa02-5e26-11eb-1d0a-19ed64679ea2
# ╠═f6aa7824-5e26-11eb-0da9-b97c615448d1
# ╠═fff0ca24-5e27-11eb-2a2c-f75b443f7197
# ╠═ffcfc534-5e27-11eb-0454-a7d6879ca011
# ╠═ffae8810-5e27-11eb-1ecd-edef45377856
# ╠═38869270-5baa-11eb-25eb-83cddddac6dc
# ╠═84fd13a6-5baa-11eb-3dca-fddfcc6f03d9
# ╠═32e9445e-5bad-11eb-0d67-d1798bb221ce
# ╟─5c5d695a-5e28-11eb-24a8-6bb3c012ec2d
# ╠═aae9636c-5e28-11eb-00fb-17900f53bf4e
# ╠═0adb8318-5e29-11eb-25a2-c5a439acb115
# ╠═0abbec60-5e29-11eb-3872-112430e3f0d3
# ╠═0aa584fc-5e29-11eb-1036-73bfd7ab888d
# ╠═0a890912-5e29-11eb-0a7a-4ba3e9ff6da1
# ╠═0a69da56-5e29-11eb-1983-15df52de477e
# ╠═a9fbe424-5bae-11eb-39fc-614d047ec480
# ╠═7caf8746-5bae-11eb-1ed8-eb6b32e6a7e6
# ╠═56088d28-5bb5-11eb-00ce-2170b0c6ecc0
# ╠═5ef67d3e-5bb5-11eb-29ff-556cdba4b5b0
# ╠═5eb5e576-5bb5-11eb-265c-c339f547c12b
