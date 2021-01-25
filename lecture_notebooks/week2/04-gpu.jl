### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ a9fbe424-5bae-11eb-39fc-614d047ec480
using Pkg

# ╔═╡ 7caf8746-5bae-11eb-1ed8-eb6b32e6a7e6
begin
  Pkg.activate(mktempdir())
  
  #Pkg.add("Colors")
  Pkg.add("Images")
  Pkg.add("ImageIO")
  #Pkg.add("ImageMagick")
  #Pkg.add("ImageFiltering")
  Pkg.add("StaticArrays")
  Pkg.add("CUDA")
  Pkg.add("OffsetArrays")
  
  using Images
  #using PlutoUI
  #using ImageMagick
  #using ImageFiltering
  using SparseArrays
  using CUDA
  using StaticArrays
  using OffsetArrays
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
  G(x, y, σ=0.5) = 1/sqrt(2*π*σ^2) * ℯ^(-(x^2+y^2)/(2*σ^2))
  G(I::CartesianIndex{2}, σ=0.5) = G(I.I..., σ)
end

# ╔═╡ 9fe43544-5e37-11eb-2d54-814a6dc8dcf9
4*ceil(Int,σ)+1

# ╔═╡ 0adb8318-5e29-11eb-25a2-c5a439acb115
function gaussian_filter(σ, l=4*ceil(Int,σ)+1)
  w = l ÷ 2
  # SMatrix: A performance hack here.
  gauss = SMatrix{l,l}(map(i->G(i, σ), CartesianIndices((-w:w, -w:w))))
  #gauss = SparseMatrix{1,1}(map(i->G(i, σ), CartesianIndices((-w:w, -w:w))))
  #gauss = sparse(Matrix{1,1}(map(i->G(i, σ), CartesianIndices((-w:w, -w:w)))))
  #gauss = AbstractSparseMatrix{1,1}(map(i->G(i, σ), CartesianIndices((-w:w, -w:w))))
  #gauss = SparseMatrixCSC{1,1}(map(i->G(i, σ), CartesianIndices((-w:w, -w:w))))
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

# ╔═╡ 13fb75d8-5e2f-11eb-1365-b3f0988ebd36
md"
Note that we don't want to copy (That's why we use `view`) because copying data is very, very expensive.
"

# ╔═╡ d0169b0a-5e32-11eb-12b6-e1f04007c3e8
filter = gaussian_filter(σ)

# ╔═╡ 0a890912-5e29-11eb-0a7a-4ba3e9ff6da1
md"## Padding the data"

# ╔═╡ 0a69da56-5e29-11eb-1983-15df52de477e
function pad(data, border=1)
  padded_size = map(s->s+2*border, size(data))
  padded_range = map(s->(1-border):(s+border), size(data))
  range = CartesianIndices(map(s->1:s, size(data)))

  odata = OffsetArray(zeros(eltype(data), padded_size), padded_range...)
  odata[range] = data
  odata, collect(range)
end

# ╔═╡ 1a9706d6-5e30-11eb-2da1-f9ef48542a18
padded_img, range = pad(img, size(filter, 1) ÷ 2);

# ╔═╡ f730aa02-5e26-11eb-1d0a-19ed64679ea2
#convolve2D.(    range,   ((padded_img),), (filter,));
convolve2D.(cu(range), (cu(padded_img),), (filter,));

# ╔═╡ 1ac7ef1c-5e30-11eb-315f-b3b95d978c45
gpu_range = cu(range);

# ╔═╡ 1a6a7a62-5e30-11eb-0ad9-95f4618449c3


# ╔═╡ bea222de-5e34-11eb-0af7-f50199286b50


# ╔═╡ be6af5a4-5e34-11eb-1d9d-ed275b86eb73
begin
  blurred = similar(img)
  blurred .= convolve2D.(range, (padded_img,), (filter,))
end

# ╔═╡ be34d2f6-5e34-11eb-11d7-91dacc81ae0c
begin
  # Really need to finish https://github.com/JuliaArrays/OffsetArrays.jl/pull/57
  import CUDA.Adapt
  Adapt.adapt_structure(to, x::OffsetArray) = OffsetArray(Adapt.adapt(to, parent(x)), x.offsets)
  Base.Broadcast.BroadcastStyle(::Type{<:OffsetArray{<:Any, <:Any, AA}}) where AA = Base.Broadcast.BroadcastStyle(AA)
  forcerun = nothing
end

# ╔═╡ be002efc-5e34-11eb-28fc-9f90f4adee4b
md"
## Executing the code on the GPU
First we need to move the data using the `cu` function to the GPU.
"

# ╔═╡ bdc5c71c-5e34-11eb-0ae8-cfd65b7739c2
begin
  forcerun  # ignore
  gpu_img = cu(padded_img)
end

# ╔═╡ 5266e61c-5e35-11eb-2a6d-6ff64279f604
typeof(gpu_img)

# ╔═╡ 5236a330-5e35-11eb-0706-412d909cd8be
gpu_blurred = cu(similar(img, RGBA{Float64}));  # allocate output

# ╔═╡ 5201822c-5e35-11eb-2f0c-996d4886e708
gpu_blurred .= convolve2D.(gpu_range, (gpu_img,), (filter,));

# ╔═╡ 9434bdee-5e35-11eb-38a7-077e382f5360
Array(gpu_blurred)

# ╔═╡ 9402dee6-5e35-11eb-0f75-1d91e0f91e3a
function bench(out, img, range, filter)
  out .= convolve2D.(range, (img,), (filter,))
end

# ╔═╡ f6aa7824-5e26-11eb-0da9-b97c615448d1
# CPU
@elapsed(bench(blurred, padded_img, range, filter))

# ╔═╡ fff0ca24-5e27-11eb-2a2c-f75b443f7197
# GPU
@elapsed(CUDA.@sync bench(gpu_blurred, gpu_img, gpu_range, filter))

# ╔═╡ bd9484bc-5e35-11eb-0f71-2b1c254d94a0
md"Setting up the environment:"

# ╔═╡ 79966884-5e3a-11eb-2ba4-25c923de49bf


# ╔═╡ 5ef67d3e-5bb5-11eb-29ff-556cdba4b5b0


# ╔═╡ 5eb5e576-5bb5-11eb-265c-c339f547c12b


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
# ╠═5c5d695a-5e28-11eb-24a8-6bb3c012ec2d
# ╠═aae9636c-5e28-11eb-00fb-17900f53bf4e
# ╠═9fe43544-5e37-11eb-2d54-814a6dc8dcf9
# ╠═0adb8318-5e29-11eb-25a2-c5a439acb115
# ╠═0abbec60-5e29-11eb-3872-112430e3f0d3
# ╠═0aa584fc-5e29-11eb-1036-73bfd7ab888d
# ╟─13fb75d8-5e2f-11eb-1365-b3f0988ebd36
# ╠═d0169b0a-5e32-11eb-12b6-e1f04007c3e8
# ╠═0a890912-5e29-11eb-0a7a-4ba3e9ff6da1
# ╠═0a69da56-5e29-11eb-1983-15df52de477e
# ╠═1ac7ef1c-5e30-11eb-315f-b3b95d978c45
# ╠═1a9706d6-5e30-11eb-2da1-f9ef48542a18
# ╠═1a6a7a62-5e30-11eb-0ad9-95f4618449c3
# ╠═bea222de-5e34-11eb-0af7-f50199286b50
# ╠═be6af5a4-5e34-11eb-1d9d-ed275b86eb73
# ╠═be34d2f6-5e34-11eb-11d7-91dacc81ae0c
# ╟─be002efc-5e34-11eb-28fc-9f90f4adee4b
# ╠═bdc5c71c-5e34-11eb-0ae8-cfd65b7739c2
# ╠═5266e61c-5e35-11eb-2a6d-6ff64279f604
# ╠═5236a330-5e35-11eb-0706-412d909cd8be
# ╠═5201822c-5e35-11eb-2f0c-996d4886e708
# ╠═9434bdee-5e35-11eb-38a7-077e382f5360
# ╠═9402dee6-5e35-11eb-0f75-1d91e0f91e3a
# ╠═bd9484bc-5e35-11eb-0f71-2b1c254d94a0
# ╠═a9fbe424-5bae-11eb-39fc-614d047ec480
# ╠═7caf8746-5bae-11eb-1ed8-eb6b32e6a7e6
# ╠═79966884-5e3a-11eb-2ba4-25c923de49bf
# ╠═5ef67d3e-5bb5-11eb-29ff-556cdba4b5b0
# ╠═5eb5e576-5bb5-11eb-265c-c339f547c12b
