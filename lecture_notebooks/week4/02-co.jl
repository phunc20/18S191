### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 80b422bc-8be6-11eb-0905-fb94cce1660c
begin
  using Pkg
  #import Pkg
  Pkg.activate(mktempdir())
  Pkg.add.(["CSV", "DataFrames", "PlutoUI", "Shapefile", "ZipFile", "LsqFit", "Plots"])
  using CSV
  using DataFrames
  using PlutoUI
  using Shapefile
  using ZipFile
  using LsqFit
  using Plots
end

# ╔═╡ de6ca00e-8bbf-11eb-1c25-331d7f69f79b
begin
  csv_fname = "covid_data.csv"
  if !(csv_fname in readdir())
    url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
    download(url, csv_fname)
  end
  csv_data = CSV.File("covid_data.csv")
  df = DataFrame(csv_data)
end

# ╔═╡ df35ca90-8be9-11eb-029a-1721985cbe90
#df["Country/Region"]
df."Country/Region"

# ╔═╡ 53adcc10-8bea-11eb-1012-8d0b48c002e3
md"""
Unlike `pandas`, we do not write `df["Country/Region"]` in `Julia`. Instead, the _columns_ are to be accessed more like _attributes_.
"""

# ╔═╡ 37819fc6-8bea-11eb-1492-d1e1c361ab39
unique(df."Country/Region")

# ╔═╡ 1406ce94-8bf2-11eb-2f04-69138797d734
first(df, 5)

# ╔═╡ b823040a-8bf2-11eb-10b5-e534f7222ccd
last(df, 4)

# ╔═╡ 89943b7a-8bf2-11eb-2d79-b930623872de
typeof(df)

# ╔═╡ 61d4dfa6-8bf2-11eb-291d-85a7b64f93a9
md"""
### Deprecation of `head(df)`
- [https://discourse.julialang.org/t/i-might-have-missed-this-but-why-is-head-df-abstractdataframe-deprecated/27988/8](https://discourse.julialang.org/t/i-might-have-missed-this-but-why-is-head-df-abstractdataframe-deprecated/27988/8)
Roughly speaking, as of 2021/03/23, `head()` seems to be deprecated and `first(df, 5)` is used to display the
first `5` rows of the dataframe `df`.
"""

# ╔═╡ 420c2d28-8bed-11eb-007e-cd88bd06e547
begin
  df2 = rename(df, 1 => "province", 2 => "country", 3 => "latitude", 4 => "longitude") 
  first(df2, 5)
end

# ╔═╡ 02181656-8c50-11eb-1994-936ab84ce68f
begin
  rename!(df, 1 => "province", 2 => "country", 3 => "latitude", 4 => "longitude") 
  first(df, 5)
end

# ╔═╡ 791c96c8-8c55-11eb-316f-c5d17a3cb093
md"## Extracting useful information
How can we extract the list of all the countries? Here below are a few ways to do it.
"

# ╔═╡ 017c09f0-8c50-11eb-16e1-4b742f4719cf
all_countries = df[:, "country"]

# ╔═╡ 15ca8b70-8c50-11eb-1e49-2f6092315600
all_countries2 = df[:, :country]

# ╔═╡ 726d1bc4-8c50-11eb-3cd0-6bb2b90897d4
all_countries3 = df[:, 2]

# ╔═╡ 726c3202-8c50-11eb-10aa-d9d36245b674
countries = unique(all_countries)

# ╔═╡ f37ad402-8c55-11eb-16a4-d95731e2655b
@bind i Slider(1:length(countries), show_value=true)

# ╔═╡ f37a93ca-8c55-11eb-0f7d-a95ec0adfda3
md"$(Text(countries[i]))"

# ╔═╡ f37a5aae-8c55-11eb-0eef-439cdb0a2d81
md"[Here we used **string interpolation** with `$` to put the text into a Markdown string.]"

# ╔═╡ f379ef1c-8c55-11eb-20c7-d558e95a39e7


# ╔═╡ f379bcc0-8c55-11eb-123c-99ed19385834
@bind country Select(countries)

# ╔═╡ f3795578-8c55-11eb-3774-2fff4fcd6034
country

# ╔═╡ f378c720-8c55-11eb-0b88-2b743a67f76b


# ╔═╡ f377fa48-8c55-11eb-0385-0d1e4bb07c75


# ╔═╡ f377cd66-8c55-11eb-3c15-c19994870228


# ╔═╡ f37797e2-8c55-11eb-190f-4fd7ee27d768


# ╔═╡ f377549e-8c55-11eb-3b4a-91d92296ab95


# ╔═╡ 72697210-8c50-11eb-3824-dd9e199b5f46


# ╔═╡ Cell order:
# ╠═80b422bc-8be6-11eb-0905-fb94cce1660c
# ╠═de6ca00e-8bbf-11eb-1c25-331d7f69f79b
# ╠═df35ca90-8be9-11eb-029a-1721985cbe90
# ╟─53adcc10-8bea-11eb-1012-8d0b48c002e3
# ╠═37819fc6-8bea-11eb-1492-d1e1c361ab39
# ╠═1406ce94-8bf2-11eb-2f04-69138797d734
# ╠═b823040a-8bf2-11eb-10b5-e534f7222ccd
# ╠═89943b7a-8bf2-11eb-2d79-b930623872de
# ╟─61d4dfa6-8bf2-11eb-291d-85a7b64f93a9
# ╠═420c2d28-8bed-11eb-007e-cd88bd06e547
# ╠═02181656-8c50-11eb-1994-936ab84ce68f
# ╟─791c96c8-8c55-11eb-316f-c5d17a3cb093
# ╠═017c09f0-8c50-11eb-16e1-4b742f4719cf
# ╠═15ca8b70-8c50-11eb-1e49-2f6092315600
# ╠═726d1bc4-8c50-11eb-3cd0-6bb2b90897d4
# ╠═726c3202-8c50-11eb-10aa-d9d36245b674
# ╠═f37ad402-8c55-11eb-16a4-d95731e2655b
# ╠═f37a93ca-8c55-11eb-0f7d-a95ec0adfda3
# ╠═f37a5aae-8c55-11eb-0eef-439cdb0a2d81
# ╠═f379ef1c-8c55-11eb-20c7-d558e95a39e7
# ╠═f379bcc0-8c55-11eb-123c-99ed19385834
# ╠═f3795578-8c55-11eb-3774-2fff4fcd6034
# ╠═f378c720-8c55-11eb-0b88-2b743a67f76b
# ╠═f377fa48-8c55-11eb-0385-0d1e4bb07c75
# ╠═f377cd66-8c55-11eb-3c15-c19994870228
# ╠═f37797e2-8c55-11eb-190f-4fd7ee27d768
# ╠═f377549e-8c55-11eb-3b4a-91d92296ab95
# ╠═72697210-8c50-11eb-3824-dd9e199b5f46
