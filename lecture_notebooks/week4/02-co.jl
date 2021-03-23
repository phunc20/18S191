### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

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
- (https://discourse.julialang.org/t/i-might-have-missed-this-but-why-is-head-df-abstractdataframe-deprecated/27988/8)[https://discourse.julialang.org/t/i-might-have-missed-this-but-why-is-head-df-abstractdataframe-deprecated/27988/8]
Roughly speaking, as of 2021/03/23, `head()` seems to be deprecated and `first(df, 5)` is used to display the
first `5` rows of the dataframe `df`.
"""

# ╔═╡ 420c2d28-8bed-11eb-007e-cd88bd06e547
begin
  df2 = rename(df, 1 => "province", 2 => "country", 3 => "latitude", 4 => "longitude") 
  first(df2, 5)
end

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
