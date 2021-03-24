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

# ╔═╡ d3d20fec-8c61-11eb-3d21-c7dabd8e9226
using Dates

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

# ╔═╡ 4cdc72a2-8c5c-11eb-0999-a97a29a1d504
md"""
### Using the data
Since we need to manipulate the columns, let's rename them to something shorter. We can do this either **in place**, i.e. modifying the original `DataFrame`, or **out of place**, creating a new `DataFrame`. The convention in Julia is that functions that modify their argument have a name ending with `!` (often pronounced "bang").

We can use the `head` (deprecated. Use `first` instead) function to see only the first few lines of the data.
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

# ╔═╡ 9832d002-8c5c-11eb-097b-a7494e4c3449
df[5:8, 2]

# ╔═╡ 726c3202-8c50-11eb-10aa-d9d36245b674
countries = unique(all_countries)

# ╔═╡ f37ad402-8c55-11eb-16a4-d95731e2655b
@bind i Slider(1:length(countries), show_value=true)

# ╔═╡ f37a93ca-8c55-11eb-0f7d-a95ec0adfda3
md"$(Text(countries[i]))"

# ╔═╡ f379ef1c-8c55-11eb-20c7-d558e95a39e7
md"You can also use `Select` to get a dropdown list instead:"

# ╔═╡ f379bcc0-8c55-11eb-123c-99ed19385834
@bind country Select(countries)

# ╔═╡ f3795578-8c55-11eb-3774-2fff4fcd6034
country

# ╔═╡ f378c720-8c55-11eb-0b88-2b743a67f76b
md"""How can we extract the data for a particular country? First we need to know the exact name of the country. For example, is the US written as "USA", or "United States"?

We could scroll through to find out, or **filter** the data to only look at a sample of it, for example those countries that begin with the letter "U".

One way to do this is with an array comprehension:"""

# ╔═╡ f377fa48-8c55-11eb-0385-0d1e4bb07c75
startswith("david", "d")

# ╔═╡ f377cd66-8c55-11eb-3c15-c19994870228
startswith("hello", "d")

# ╔═╡ f37797e2-8c55-11eb-190f-4fd7ee27d768
U_countries = [startswith(country, "U") for country in all_countries]

# ╔═╡ f377549e-8c55-11eb-3b4a-91d92296ab95
length(U_countries), length(all_countries)

# ╔═╡ 35e4420e-8c5d-11eb-0a44-6339679f2dfc
df[U_countries, :]

# ╔═╡ 35c3ae9a-8c5d-11eb-3f90-57f70c05a40d
filter(country -> startswith(country, "U"), all_countries)

# ╔═╡ 359f089c-8c5d-11eb-2a7e-4d381db351e0
md"Now we would like to extract the data for the US alone. How can we access the correct row of the table? We can again filter on the country name. A nicer way to do this is to use the `filter` function.

This is a **higher-order function**: its first argument is itself a function, which must return `true` or `false`.  `filter` will return all the rows of the `DataFrame` that satisfy that **predicate**:
"

# ╔═╡ 3581c914-8c5d-11eb-0a84-03948718e0ff
filter(x -> x.country == "United Kingdom", df)

# ╔═╡ 3562d016-8c5d-11eb-0f97-e7fdec3b281b
US_row = findfirst(==("US"), all_countries)

# ╔═╡ 35434624-8c5d-11eb-1f8c-0155978e5ec5
typeof(==("US"))

# ╔═╡ 72697210-8c50-11eb-3824-dd9e199b5f46
typeof(("US"))

# ╔═╡ 81ab32fa-8c5e-11eb-2e5e-3163cce19764
df[US_row, :]

# ╔═╡ 817d0ac4-8c5e-11eb-299f-791036d2b168
df[US_row:US_row, :]

# ╔═╡ 815cc7ca-8c5e-11eb-0ae9-ab7792999ea5
US_data = Vector(df[US_row, 5:end])

# ╔═╡ 8131aade-8c5e-11eb-13c4-cb5089b92422
scatter(US_data, m=:o, alpha=0.5, ms=3, xlabel="day", ylabel="cumulative cases", leg=false)

# ╔═╡ e12bec60-8c5e-11eb-0b73-99f9ec283fe6
md"""
- `m=:o`: marker
- `ms=3`: marker size
- `leg=false`: no **legend**
"""

# ╔═╡ e0fc4582-8c5e-11eb-03d3-77b71d3b3893
md"Note that we are only passing a single vector to the `scatter` function, so the $x$ coordinates are taken as the natural numbers $1$, $2$, etc.

Also note that the $y$-axis in this plot gives the *cumulative* case numbers, i.e. the *total* number of confirmed cases since the start of the epidemic up to the given date. 
"

# ╔═╡ e0d51f48-8c5e-11eb-21b8-f3390eed1cf3
md"""
## Using dates
We would like to use actual dates instead of just the number of days since the start of the recorded data. The dates are given in the column names of the `DataFrame`:
"""

# ╔═╡ e0b6fcd4-8c5e-11eb-2234-89b3c3693927
column_names = names(df)

# ╔═╡ e0572944-8c5e-11eb-333b-4dff1af3df93
date_strings = names(df)[5:end]  # apply String function to each element

# ╔═╡ b38d749e-8c61-11eb-320d-ad2672ec4b95
md"""
Now we need to **parse** the date strings, i.e. convert from a string representation into an actual Julia type provided by the `Dates.jl` standard library package:
"""

# ╔═╡ b35f5c88-8c61-11eb-0bd6-211452fc0ab9
date_strings[1]

# ╔═╡ b33bc886-8c61-11eb-0865-57c37076db0e
date_format = Dates.DateFormat("m/d/Y")

# ╔═╡ b304b030-8c61-11eb-3f44-2bef422b2922
parse(Date, date_strings[1], date_format)

# ╔═╡ 81139bde-8c5e-11eb-119a-276db9e55070
md"Since the year was not correctly represented in the original data, we need to manually fix it:"

# ╔═╡ 384d6584-8c62-11eb-2dab-9945e5e87b22
dates = parse.(Date, date_strings, date_format) .+ Year(2000)

# ╔═╡ 1156ab60-8c63-11eb-1ec4-593d9ed05d64
parse.(Date, date_strings, date_format) .+ Day(365)

# ╔═╡ 3e9a5400-8c63-11eb-0781-29a165656b28
@bind day Clock(0.5)

# ╔═╡ 520dc058-8c63-11eb-2bb5-053752d75eed
day

# ╔═╡ 2387613a-8c63-11eb-1745-a11190477c7e
dates[day]

# ╔═╡ 2347185a-8c63-11eb-024d-b310275af4a9
begin
  plot(dates, US_data, xrotation=45, leg=:topleft,
       label="US data", m=:o, ms=3, alpha=.5)
  xlabel!("date")
  ylabel!("cumulative US cases")
  title!("US cumulative confirmed COVID-19 cases")
end

# ╔═╡ 233aa0e8-8c63-11eb-1ce1-53a8d793bdbb
md"""
## Exploratory data analysis
Working with *cumulative* data is often less intuitive. Let's look at the actual number of daily cases. Julia has a `diff` function to calculate the difference between successive entries of a vector:
"""

# ╔═╡ 2313a3b2-8c63-11eb-3c47-155f972d42c8
begin
  daily_cases = diff(US_data)
  length(daily_cases), length(US_data)
end

# ╔═╡ e53a8694-8c70-11eb-0e4a-272334af2c8f
begin
  using Statistics
  running_mean = [mean(daily_cases[i-6:i]) for i in 7:length(daily_cases)]
end

# ╔═╡ e5666168-8c70-11eb-024e-d3cff4324249
plot(dates[2:end], daily_cases, m=:o, leg=false, xlabel="date", ylabel="daily US cases", alpha=0.5)

# ╔═╡ e55bc00a-8c70-11eb-1b6e-ad0255bd0e00
md"Note that discrete data should *always* be plotted with points. The lines are just to guide the eye. 

Cumulating data corresponds to taking the integral of a function and is a *smoothing* operation. Note that the cumulative data is indeed visually smoother than the daily data.

The oscillations in the daily data seem to be due to a lower incidence of reporting at weekends. We could try to smooth this out by taking a **moving average**, say over the past week:
"

# ╔═╡ e51c303e-8c70-11eb-159a-531b70df0485
begin
  plot(daily_cases, label="raw daily cases")
  plot!(running_mean, m=:o, label="running weakly mean", leg=:topleft)
end

# ╔═╡ e515c0b4-8c70-11eb-07ac-f545ab2b4cbc
begin
	plot(dates[2:end], daily_cases, label="raw daily cases")
	plot!(dates[8:end], running_mean, m=:o, label="running weakly mean", leg=:topleft)
end

# ╔═╡ e4ffe5c8-8c70-11eb-1741-5333bb247991
md"""
## Exponential growth

Simple models of epidemic spread often predict a period with **exponential growth**. Do the data corroborate this?

A visual check for this is to plot the data with a **logarithmic scale** on the $y$ axis (but a standard scale on the $x$ axis).

If we observe a straight line on such a semi-logarithmic plot, then we know that

$$\log(y) \sim \alpha x + \beta,$$

where we are using $\sim$ to denote approximate equality.

Taking exponentials of both sides gives

$$y \sim \exp(\alpha x + \beta),$$

i.e.

$$y \sim c \, \mathrm{e}^{\alpha x},$$

where $c$ is a constant (sometimes called a "pre-factor") and $\alpha$ is the exponential growth rate, found from the slope of the straight line on the semi-log plot.
"""

# ╔═╡ 9948deba-8c74-11eb-14cb-8b26d7ebed0b
daily_cases

# ╔═╡ e4dd6b2e-8c70-11eb-3ff8-8992c983a324
md"""
Since the data contains some zeros, we need to replace those with `NaN`s ("Not a Number"), which `Plots.jl` interprets as a signal to break the line

**(?)** What does it mean
> _which (i.e. `NaN`) `Plots.jl` interprets as a signal to break the line_?


"""

# ╔═╡ e4c84afc-8c70-11eb-0649-af43fd108d82
begin
  plot(replace(daily_cases, 0 => NaN),
       yscale=:log10,
       leg=false,
       m=:o)
  xlabel!("day")
  ylabel!("confirmed cases in US")
  title!("US confirmed COVID-19 cases")
end

# ╔═╡ 5add4b6a-8c75-11eb-172f-ff0cded5375f
md"Let's zoom in on the region of the graph where the growth looks linear on this semi-log plot:"

# ╔═╡ 5abdf382-8c75-11eb-2cca-335ff895ca90
xlims!(0, 100)

# ╔═╡ 5aa60ca2-8c75-11eb-31b7-f9b03205d5f7
exp_period = 38:60

# ╔═╡ 5a8e7300-8c75-11eb-2a64-951b7e445c57
md"We see that there is a period lasting from around day $(first(exp_period)) to around day $(last(exp_period)) when the curve looks straight on the semi-log plot."

# ╔═╡ 5a72b2a0-8c75-11eb-1e92-954a2164203b
dates[exp_period]

# ╔═╡ 5a673e3e-8c75-11eb-187a-01dcab6d957f
md"i.e. the first 3 weeks of March. Fortunately the imposition of lockdown during the last 10 days of March (on different days in different US states) significantly reduced transmission."

# ╔═╡ 5a3ef924-8c75-11eb-1613-e1478090d5cf
md"""
## Data fitting

Let's try to fit an exponential function to our data in the relevant region. We will use the Julia package `LsqFit.jl` ("least-squares fit").

This package allows us to specify a model function that takes a vector of data and a vector of parameters, and it finds the best fit to the data.
"""

# ╔═╡ 5a310daa-8c75-11eb-3657-c5286d8c7692
model(x, (c, α)) = c .* exp.(α .* x)

# ╔═╡ 5a0b608c-8c75-11eb-1345-d7d7b6387903
begin
  p0 = [0.5, 0.5]  # initial guess
  x_data = exp_period
  y_data = daily_cases[exp_period]
  fit = curve_fit(model, x_data, y_data, p0)
end;

# ╔═╡ a3cb0834-8c76-11eb-1604-33e49362d618
md"""
**Rmk.** The `;` sign suppresses the foregoing cell from displaying `fit`.
"""

# ╔═╡ a3b2264a-8c76-11eb-2d7f-c777effb16df
md"We are interested in the coefficients of the best-fitting model:"

# ╔═╡ a39af538-8c76-11eb-35f8-59126411220e
parameters = coef(fit)

# ╔═╡ a385c394-8c76-11eb-1ce3-f9569bb6c5a0
begin
  plot(replace(daily_cases, 0 => NaN),
       yscale=:log10,
       leg=false,
       m=:o,
       xlims=(1,100),
       alpha=0.5)
  line_range = 30:70
  plot!(line_range,
        model(line_range, parameters),
        lw=3,
        ls=:dash,
        alpha=0.7)
  # lw: line width
  # ls: line style
  xlabel!("day")
  ylabel!("confirmed cases in US")
  title!("confirmed cases in US")
end

# ╔═╡ a379ab3a-8c76-11eb-11a4-910f9de9578c
md"""
## Geographical data
Our data set contains more information: the geographical locations (latitude and longitude) of each country (or, rather, of a particular point that was chosen as being representative of that country).
"""

# ╔═╡ a3536cca-8c76-11eb-1f9a-7dda7bf7c41b
province = df.province

# ╔═╡ 1aebbfb6-8c78-11eb-013a-ef5d3a4036ef
md"If the `province` is missing we should use the country name instead:"

# ╔═╡ 1acc36c6-8c78-11eb-2261-a147de0e2c2a
indices = ismissing.(province)

# ╔═╡ 1ab67536-8c78-11eb-1faf-e11b708db2e0
province[indices] .= all_countries[indices]

# ╔═╡ 1aad4308-8c78-11eb-197c-b76f1c070c76
df.province

# ╔═╡ 1a80e2e0-8c78-11eb-29ca-45d0f85696fe
begin
  scatter(df.longitude, df.latitude, legend=false, alpha=0.5, ms=2)
  #for i in 1:length(province)
  #  annotate!(df.longitude[i],
  #            df.latitude[i],
  #            text(province[i], :center, 5, color=RGBA{Float64}(0.0, 0.0, 0.0, 0.3)))
  #end
  plot!(axis=false)
end

# ╔═╡ 5a8b0e54-8c7a-11eb-08fe-c130072e0b91
md"""
**(?)** I was unable to figure out how to make the `annotate!()` part work.
"""

# ╔═╡ 0b3e2fd0-8c79-11eb-12c7-bd299ad5efba
md"""
## Adding maps
We would also like to see the outlines of each country. For this we can use, for example, the data from [Natural Earth](https://www.naturalearthdata.com/downloads/110m-cultural-vectors/110m-admin-0-countries), which comes in the form of **shape files**, giving the outlines in terms of latitude and longitude coordinates. 

These may be read in using the `Shapefile.jl` package.

The data is provided in a `.zip` file, so after downloading it we first need to decompress it.
"""

# ╔═╡ 0b175496-8c79-11eb-1b38-87e7b9427a0d
begin
  zipfile = "ne_110m_admin_0_countries.zip"
  if !(zipfile in readdir())
    zipfile = download("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip")
  end
  r = ZipFile.Reader(zipfile)
  for f in r.files
    println("Filename: $(f.name)")
    open(f.name, "w") do io
      write(io, read(f))
    end
  end
  close(r)
end

# ╔═╡ 0b0495b8-8c79-11eb-2200-238009b6738a
readdir()

# ╔═╡ 0adb456c-8c79-11eb-3074-09f21cc077ac
shp_countries = Shapefile.shapes(Shapefile.Table("./ne_110m_admin_0_countries.shp"))

# ╔═╡ 415b31bc-8c7b-11eb-2ddd-7515d3818cc0
plot!(shp_countries, alpha=0.2)

# ╔═╡ 52e93a08-8c7b-11eb-36f2-0f8650c3221d
md"Now we would like to combine the geographical and temporal (time) aspects. One way to do so is to animate time:"

# ╔═╡ 52c8a720-8c7b-11eb-3818-bb39950e78e4
daily = max.(1, diff(Array(df[:, 5:end]), dims=2))

# ╔═╡ 52b105d4-8c7b-11eb-3c26-c947f8ef8a8a
@bind day2 Slider(1:size(daily, 2), show_value=true)

# ╔═╡ be1d450a-8c7b-11eb-08c3-b9a5038e7c7e
log10(maximum(daily[:, day]))

# ╔═╡ bdfb5220-8c7b-11eb-20eb-874f376d08e1
dates[day2]

# ╔═╡ bddb928e-8c7b-11eb-36e2-1530fb7f0a06
world_plot = begin
  plot(shp_countries, alpha=0.2)
  scatter!(df.longitude, df.latitude, leg=false, ms=2*log10.(daily[:, day2]), alpha=0.7)
  xlabel!("latitude")
  ylabel!("longitude")
  title!("daily cases per country")
end

# ╔═╡ 414e5c06-8c7b-11eb-0c06-f5dcb33fe6f3


# ╔═╡ 41164b68-8c7b-11eb-122f-878a6b790da0


# ╔═╡ 40f9814a-8c7b-11eb-021f-13de83c988de


# ╔═╡ 40c2400e-8c7b-11eb-01bb-8574b647fe80


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
# ╠═4cdc72a2-8c5c-11eb-0999-a97a29a1d504
# ╠═420c2d28-8bed-11eb-007e-cd88bd06e547
# ╠═02181656-8c50-11eb-1994-936ab84ce68f
# ╟─791c96c8-8c55-11eb-316f-c5d17a3cb093
# ╠═017c09f0-8c50-11eb-16e1-4b742f4719cf
# ╠═15ca8b70-8c50-11eb-1e49-2f6092315600
# ╠═726d1bc4-8c50-11eb-3cd0-6bb2b90897d4
# ╠═9832d002-8c5c-11eb-097b-a7494e4c3449
# ╠═726c3202-8c50-11eb-10aa-d9d36245b674
# ╠═f37ad402-8c55-11eb-16a4-d95731e2655b
# ╠═f37a93ca-8c55-11eb-0f7d-a95ec0adfda3
# ╟─f379ef1c-8c55-11eb-20c7-d558e95a39e7
# ╠═f379bcc0-8c55-11eb-123c-99ed19385834
# ╠═f3795578-8c55-11eb-3774-2fff4fcd6034
# ╟─f378c720-8c55-11eb-0b88-2b743a67f76b
# ╠═f377fa48-8c55-11eb-0385-0d1e4bb07c75
# ╠═f377cd66-8c55-11eb-3c15-c19994870228
# ╠═f37797e2-8c55-11eb-190f-4fd7ee27d768
# ╠═f377549e-8c55-11eb-3b4a-91d92296ab95
# ╠═35e4420e-8c5d-11eb-0a44-6339679f2dfc
# ╠═35c3ae9a-8c5d-11eb-3f90-57f70c05a40d
# ╟─359f089c-8c5d-11eb-2a7e-4d381db351e0
# ╠═3581c914-8c5d-11eb-0a84-03948718e0ff
# ╠═3562d016-8c5d-11eb-0f97-e7fdec3b281b
# ╠═35434624-8c5d-11eb-1f8c-0155978e5ec5
# ╠═72697210-8c50-11eb-3824-dd9e199b5f46
# ╠═81ab32fa-8c5e-11eb-2e5e-3163cce19764
# ╠═817d0ac4-8c5e-11eb-299f-791036d2b168
# ╠═815cc7ca-8c5e-11eb-0ae9-ab7792999ea5
# ╠═8131aade-8c5e-11eb-13c4-cb5089b92422
# ╠═e12bec60-8c5e-11eb-0b73-99f9ec283fe6
# ╟─e0fc4582-8c5e-11eb-03d3-77b71d3b3893
# ╟─e0d51f48-8c5e-11eb-21b8-f3390eed1cf3
# ╠═e0b6fcd4-8c5e-11eb-2234-89b3c3693927
# ╠═e0572944-8c5e-11eb-333b-4dff1af3df93
# ╟─b38d749e-8c61-11eb-320d-ad2672ec4b95
# ╠═b35f5c88-8c61-11eb-0bd6-211452fc0ab9
# ╠═d3d20fec-8c61-11eb-3d21-c7dabd8e9226
# ╠═b33bc886-8c61-11eb-0865-57c37076db0e
# ╠═b304b030-8c61-11eb-3f44-2bef422b2922
# ╟─81139bde-8c5e-11eb-119a-276db9e55070
# ╠═384d6584-8c62-11eb-2dab-9945e5e87b22
# ╠═1156ab60-8c63-11eb-1ec4-593d9ed05d64
# ╠═3e9a5400-8c63-11eb-0781-29a165656b28
# ╠═520dc058-8c63-11eb-2bb5-053752d75eed
# ╠═2387613a-8c63-11eb-1745-a11190477c7e
# ╠═2347185a-8c63-11eb-024d-b310275af4a9
# ╠═233aa0e8-8c63-11eb-1ce1-53a8d793bdbb
# ╠═2313a3b2-8c63-11eb-3c47-155f972d42c8
# ╠═e5666168-8c70-11eb-024e-d3cff4324249
# ╟─e55bc00a-8c70-11eb-1b6e-ad0255bd0e00
# ╠═e53a8694-8c70-11eb-0e4a-272334af2c8f
# ╠═e51c303e-8c70-11eb-159a-531b70df0485
# ╠═e515c0b4-8c70-11eb-07ac-f545ab2b4cbc
# ╟─e4ffe5c8-8c70-11eb-1741-5333bb247991
# ╠═9948deba-8c74-11eb-14cb-8b26d7ebed0b
# ╠═e4dd6b2e-8c70-11eb-3ff8-8992c983a324
# ╠═e4c84afc-8c70-11eb-0649-af43fd108d82
# ╟─5add4b6a-8c75-11eb-172f-ff0cded5375f
# ╠═5abdf382-8c75-11eb-2cca-335ff895ca90
# ╠═5aa60ca2-8c75-11eb-31b7-f9b03205d5f7
# ╟─5a8e7300-8c75-11eb-2a64-951b7e445c57
# ╠═5a72b2a0-8c75-11eb-1e92-954a2164203b
# ╟─5a673e3e-8c75-11eb-187a-01dcab6d957f
# ╟─5a3ef924-8c75-11eb-1613-e1478090d5cf
# ╠═5a310daa-8c75-11eb-3657-c5286d8c7692
# ╠═5a0b608c-8c75-11eb-1345-d7d7b6387903
# ╟─a3cb0834-8c76-11eb-1604-33e49362d618
# ╟─a3b2264a-8c76-11eb-2d7f-c777effb16df
# ╠═a39af538-8c76-11eb-35f8-59126411220e
# ╠═a385c394-8c76-11eb-1ce3-f9569bb6c5a0
# ╟─a379ab3a-8c76-11eb-11a4-910f9de9578c
# ╠═a3536cca-8c76-11eb-1f9a-7dda7bf7c41b
# ╟─1aebbfb6-8c78-11eb-013a-ef5d3a4036ef
# ╠═1acc36c6-8c78-11eb-2261-a147de0e2c2a
# ╠═1ab67536-8c78-11eb-1faf-e11b708db2e0
# ╠═1aad4308-8c78-11eb-197c-b76f1c070c76
# ╠═1a80e2e0-8c78-11eb-29ca-45d0f85696fe
# ╟─5a8b0e54-8c7a-11eb-08fe-c130072e0b91
# ╟─0b3e2fd0-8c79-11eb-12c7-bd299ad5efba
# ╠═0b175496-8c79-11eb-1b38-87e7b9427a0d
# ╠═0b0495b8-8c79-11eb-2200-238009b6738a
# ╠═0adb456c-8c79-11eb-3074-09f21cc077ac
# ╠═415b31bc-8c7b-11eb-2ddd-7515d3818cc0
# ╟─52e93a08-8c7b-11eb-36f2-0f8650c3221d
# ╠═52c8a720-8c7b-11eb-3818-bb39950e78e4
# ╠═52b105d4-8c7b-11eb-3c26-c947f8ef8a8a
# ╠═be1d450a-8c7b-11eb-08c3-b9a5038e7c7e
# ╠═bdfb5220-8c7b-11eb-20eb-874f376d08e1
# ╠═bddb928e-8c7b-11eb-36e2-1530fb7f0a06
# ╠═414e5c06-8c7b-11eb-0c06-f5dcb33fe6f3
# ╠═41164b68-8c7b-11eb-122f-878a6b790da0
# ╠═40f9814a-8c7b-11eb-021f-13de83c988de
# ╠═40c2400e-8c7b-11eb-01bb-8574b647fe80
