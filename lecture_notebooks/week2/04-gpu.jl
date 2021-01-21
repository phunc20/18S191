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

# ╔═╡ 38869270-5baa-11eb-25eb-83cddddac6dc
md"## Gaussian filter"

# ╔═╡ 84fd13a6-5baa-11eb-3dca-fddfcc6f03d9
σ = 4

# ╔═╡ 32e9445e-5bad-11eb-0d67-d1798bb221ce
begin
  img = load(download("https://raw.githubusercontent.com/JuliaLang/julia-logo-graphics/master/images/julia-logo-color.png"))
end

# ╔═╡ b9bd3ea2-5baf-11eb-0748-152a03b7d3f2
begin
  f = ind -> ind.I
  f.(CartesianIndices( (-2:2, -1:1) ))
end

# ╔═╡ Cell order:
# ╟─38869270-5baa-11eb-25eb-83cddddac6dc
# ╠═84fd13a6-5baa-11eb-3dca-fddfcc6f03d9
# ╠═32e9445e-5bad-11eb-0d67-d1798bb221ce
# ╠═a9fbe424-5bae-11eb-39fc-614d047ec480
# ╠═7caf8746-5bae-11eb-1ed8-eb6b32e6a7e6
# ╠═b9bd3ea2-5baf-11eb-0748-152a03b7d3f2
