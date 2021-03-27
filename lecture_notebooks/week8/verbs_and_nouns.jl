### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ e800535a-8ed4-11eb-19d3-914d5b0acee7
tempdir = mktempdir()

# ╔═╡ 7917745c-8ed5-11eb-1b70-3967f0e1f5f8
begin
  import Pkg
  Pkg.activate(tempdir)
  Pkg.add(["StatsBase", "MixedModels", "GLM"])
  using StatsBase    # fit()
  using GLM          # linear model
  using MixedModels  # defines model types
end

# ╔═╡ 78fc5d0e-8ed5-11eb-281b-67c9a31edda9
md"""
## Structs
- They have a type - this can be used to define how a function acts on the struct
- They form a container holding many values
- They carry type information for the values they hold
"""

# ╔═╡ 78ddd456-8ed5-11eb-195c-f5656abbf203
struct IntPoint
  x::Int64
  y::Int64
end

# ╔═╡ 78c0828e-8ed5-11eb-3e55-a1eec8fb3dff
struct FloatPoint
  x::Float64
  y::Float64
end

# ╔═╡ 309c4166-8ed8-11eb-2fbe-1dff9c1427e1
begin
  import Base: +
  +(a::IntPoint, b::IntPoint) = IntPoint(a.x + b.x, a.y + b.y)
  +(a::FloatPoint, b::FloatPoint) = FloatPoint(a.x + b.x, a.y + b.y)
  +(a::IntPoint, b::FloatPoint) = FloatPoint(a.x + b.x, a.y + b.y)
  +(a::FloatPoint, b::IntPoint) = +(b, a)
end

# ╔═╡ 3068c368-8ed8-11eb-0358-4dba140f14f5
begin
  ai = IntPoint(1,2)
  bi = IntPoint(3,4)
  af = FloatPoint(0.1, -0.2)
  bf = FloatPoint(-0.3,-0.4)
end

# ╔═╡ 304ff90a-8ed8-11eb-2557-91afea2c42c5
ai + bi

# ╔═╡ 30252360-8ed8-11eb-299a-1be52956138e
af + bf

# ╔═╡ 77a9ab66-8ed8-11eb-24d0-5723ad4d5394
ai + bf

# ╔═╡ 7760088a-8ed8-11eb-1518-f5dbae882d34
af + bi

# ╔═╡ b67b4a36-8ed8-11eb-26c6-c3269375fce1
@code_lowered ai + bi

# ╔═╡ d40292ce-8ed8-11eb-07db-7f4bc58213cf
md"""
```
syntax: "%" is not a unary operator
```
```julia
begin
  %1 = Base.getproperty(ai, :x)
  %2 = Base.getproperty(bi, :x)
  %3 = %1 + %2
  %4 = Base.getproperty(ai, :y)
  %5 = Base.getproperty(bi, :y)
  %6 = %4 + %5
  %7 = Main.workspace673.IntPoint(%3, %6)
  return %7
end
```
"""

# ╔═╡ 2ef2525a-8ed9-11eb-1ea9-df3cef0c2cba
begin
  #using PlutoUI
  #PlutoUI.Print(ai + bi)
  ax = Base.getproperty(ai, :x)
  bx = Base.getproperty(bi, :x)
  ay = Base.getproperty(ai, :y)
  by = Base.getproperty(bi, :y)
  Main.workspace673.IntPoint(ax + bx, ay + by)
end

# ╔═╡ 653854f4-8ed9-11eb-01ba-6bc16f1fb1a7
@code_typed ai + bi

# ╔═╡ 72d5dc78-8ed9-11eb-001e-69813aff5e64
@code_typed af + bi

# ╔═╡ a2bb10a8-8ed9-11eb-393b-fd37180277f9
md"""
- `sitofp` means **`signed integer to floating point`**
"""

# ╔═╡ 3ba5e1f0-8eda-11eb-3925-adde0b42147f
let
  bix = Base.getfield(bi, :x)::Int64
  afx = Base.getfield(af, :x)::Float64
  bx = Base.sitofp(Float64, bix)::Float64
  intermediate1 = Base.add_float(bx, afx)::Float64
  biy = Base.getfield(bi, :y)::Int64
  afy = Base.getfield(af, :y)::Float64
  by = Base.sitofp(Float64, biy)::Float64
  intermediate2 = Base.add_float(by, afy)::Float64
  #res = %new(Main.workspace671.FloatPoint, intermediate1, intermediate2)::FloatPoint
  res = Main.workspace671.FloatPoint(intermediate1, intermediate2)
end

# ╔═╡ 9fdb9694-8eda-11eb-0b16-4359651ad558
struct UntypedPoint
  x
  y
end

# ╔═╡ a1fe304e-8eda-11eb-334f-6556885f22bf
md"""
```
MethodError: no method matching +(::Main.workspace757.UntypedPoint, ::Main.workspace757.UntypedPoint)

Closest candidates are:

+(::Any, ::Any, !Matched::Any, !Matched::Any...) at operators.jl:538

+(!Matched::ChainRulesCore.DoesNotExist, ::Any) at /home/phunc20/.julia/packages/ChainRulesCore/JWrYo/src/differential_arithmetic.jl:23

+(!Matched::MutableArithmetics.Zero, ::Any) at /home/phunc20/.julia/packages/MutableArithmetics/bPWR4/src/rewrite.jl:52

...
```
```julia
let
  a = UntypedPoint(1,2)
  b = UntypedPoint(3,4)
  a + b
end
```
"""

# ╔═╡ f514dcea-8eda-11eb-1cb6-c95e9ac6cbca
sum(FloatPoint(i/10, 2i/10) for i in 1:10)

# ╔═╡ 090d8a80-8edb-11eb-3553-ebc985326f7b
md"""
``\sum_{i=1}^{10} i = 55\;`` and
``\;\sum_{i=1}^{10} 2i = 110\,.``
"""

# ╔═╡ Cell order:
# ╠═e800535a-8ed4-11eb-19d3-914d5b0acee7
# ╠═7917745c-8ed5-11eb-1b70-3967f0e1f5f8
# ╟─78fc5d0e-8ed5-11eb-281b-67c9a31edda9
# ╠═78ddd456-8ed5-11eb-195c-f5656abbf203
# ╠═78c0828e-8ed5-11eb-3e55-a1eec8fb3dff
# ╠═309c4166-8ed8-11eb-2fbe-1dff9c1427e1
# ╠═3068c368-8ed8-11eb-0358-4dba140f14f5
# ╠═304ff90a-8ed8-11eb-2557-91afea2c42c5
# ╠═30252360-8ed8-11eb-299a-1be52956138e
# ╠═77a9ab66-8ed8-11eb-24d0-5723ad4d5394
# ╠═7760088a-8ed8-11eb-1518-f5dbae882d34
# ╠═b67b4a36-8ed8-11eb-26c6-c3269375fce1
# ╟─d40292ce-8ed8-11eb-07db-7f4bc58213cf
# ╠═2ef2525a-8ed9-11eb-1ea9-df3cef0c2cba
# ╠═653854f4-8ed9-11eb-01ba-6bc16f1fb1a7
# ╠═72d5dc78-8ed9-11eb-001e-69813aff5e64
# ╟─a2bb10a8-8ed9-11eb-393b-fd37180277f9
# ╠═3ba5e1f0-8eda-11eb-3925-adde0b42147f
# ╠═9fdb9694-8eda-11eb-0b16-4359651ad558
# ╟─a1fe304e-8eda-11eb-334f-6556885f22bf
# ╠═f514dcea-8eda-11eb-1cb6-c95e9ac6cbca
# ╟─090d8a80-8edb-11eb-3553-ebc985326f7b
