### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 2f3aef44-8edc-11eb-14cf-0d842a81dd97
begin
  using FLoops
  using StaticArrays, StatsBase, Combinatorics
end

# ╔═╡ ff50ed1a-8edb-11eb-3a10-4d5d34ff2d5d
tmpdir = mktempdir()

# ╔═╡ 2f4d6cd4-8edc-11eb-0a60-a71c01d64d5d
begin
  using Pkg
  Pkg.activate(tmpdir)
  Pkg.add("FLoops")
  Pkg.add("StaticArrays")
  Pkg.add("StatsBase")
  Pkg.add("Combinatorics")
end

# ╔═╡ 2f22f790-8edc-11eb-2883-7d96b6b5e537
function birthday_problem_floop(t, ncores )
  v = 0
    @floop ThreadedEx(basesize=t÷ncores) for _ in 1:t
      months =  @SVector [rand(1:12) for i in 1:20]
      counts =  @SVector [sum(months.==i) for i=1:12]
      success = sum(counts.==2) == 4  &&  sum(counts.==3)==4
      @reduce(v += success)           
    end
  return v/t
end

# ╔═╡ 2f0abf86-8edc-11eb-0d37-d92da221a5b8
birthday_problem_floop(10_000_000, 4)

# ╔═╡ Cell order:
# ╠═ff50ed1a-8edb-11eb-3a10-4d5d34ff2d5d
# ╠═2f4d6cd4-8edc-11eb-0a60-a71c01d64d5d
# ╠═2f3aef44-8edc-11eb-14cf-0d842a81dd97
# ╠═2f22f790-8edc-11eb-2883-7d96b6b5e537
# ╠═2f0abf86-8edc-11eb-0d37-d92da221a5b8
