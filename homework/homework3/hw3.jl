### A Pluto.jl notebook ###
# v0.12.20

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

# ╔═╡ 86e1ee96-f314-11ea-03f6-0f549b79e7c9
begin
	using Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ a4937996-f314-11ea-2ff9-615c888afaa8
begin
	Pkg.add([
			"Compose",
			"Colors",
			"PlutoUI",
			])

	using Colors
	using PlutoUI
	using Compose
	using LinearAlgebra
end

# ╔═╡ e6b6760a-f37f-11ea-3ae1-65443ef5a81a
md"_homework 3, version 3_"

# ╔═╡ 85cfbd10-f384-11ea-31dc-b5693630a4c5
md"""

# **Homework 3**: _Structure and Language_
`18.S191`, fall 2020

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 33e43c7c-f381-11ea-3abc-c942327456b1
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "phunc20", kerberos_id = "reggae")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ ec66314e-f37f-11ea-0af4-31da0584e881
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 938185ec-f384-11ea-21dc-b56b7469f798
md"_Let's create a package environment:_"

# ╔═╡ b49a21a6-f381-11ea-1a98-7f144c55c9b7
html"""
<iframe width="100%" height="450px" src="https://www.youtube.com/embed/ConoBmjlivs?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ 6f9df800-f92d-11ea-2d49-c1aaabd2d012
md"""
## **Exercise 1:** _Language detection_

In this exercise, we are going to create some super simple _Artificial Intelligence_. Natural language can be quite messy, but hidden in this mess is _structure_, which we are going to look for today.

Let's start with some obvious structure in English text: the set of characters that we write the language in. If we generate random text by sampling _random Unicode characters_, it does not look like English:
"""

# ╔═╡ b61722cc-f98f-11ea-22ae-d755f61f78c3
String(rand(Char, 40))

# ╔═╡ f457ad44-f990-11ea-0e2d-2bb7627716a8
md"""
Instead, let's define an _alphabet_, and only use those letters to sample from. To keep things simple, we ignore punctuation, capitalization, etc, and only use these 27 characters: (26 English letters plus white space)
"""

# ╔═╡ 4efc051e-f92e-11ea-080e-bde6b8f9295a
alphabet = ['a':'z' ; ' ']   # includes the space character

# ╔═╡ 38d1ace8-f991-11ea-0b5f-ed7bd08edde5
md"""
Let's sample random characters from our alphabet:
"""

# ╔═╡ ddf272c8-f990-11ea-2135-7bf1a6dca0b7
String(rand(alphabet, 40)) |> Text

# ╔═╡ 3cc688d2-f996-11ea-2a6f-0b4c7a5b74c2
md"""
That already looks a lot better than our first attempt! But still, this does not look like English text -- we can do better. 

$(html"<br>")

English words are not well modelled by this random-Latin-characters model. Our first observation is that **some letters are more common than others**. To put this observation into practice, we would like to have the **frequency table** of the Latin alphabet. We could search for it online, but it is actually very simple to calculate ourselves! The only thing we need is a _representative sample_ of English text.

The following samples are from Wikipedia, but feel free to type in your own sample! You can also enter a sample of a different language, if that language can be expressed in the Latin alphabet.

Remember that the $(html"<img src='https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.0.0/src/svg/eye-outline.svg' style='width: 1em; height: 1em; margin-bottom: -.2em;'>") button on the left of a cell will show or hide the code.

We also include a sample of Spanish, which we'll use later!
"""

# ╔═╡ a094e2ac-f92d-11ea-141a-3566552dd839
md"""
#### Exercise 1.1 - _Data cleaning_
Looking at the sample, we see that it is quite _messy_: it contains punctuation, accented letters and numbers. For our analysis, we are only interested in our 27-character alphabet (i.e. `'a'` through `'z'` plus `' '`). We are going to clean the data using the Julia function `filter`. 
"""

# ╔═╡ 27c9a7f4-f996-11ea-1e46-19e3fc840ad9
filter(isodd, [6, 7, 8, 9, -5])

# ╔═╡ f2a4edfa-f996-11ea-1a24-1ba78fd92233
md"""
`filter` takes two arguments: a **function** and a **collection**. The function is applied to each element of the collection, and it returns either `true` or `false`. If the result is `true`, then that element is included in the final collection.

Did you notice something cool? Functions are also just _objects_ in Julia, and you can use them as arguments to other functions! _(Fons thinks this is super cool.)_

$(html"<br>")

We have written a function `isinalphabet`, which takes a character and returns a boolean:
"""

# ╔═╡ 5c74a052-f92e-11ea-2c5b-0f1a3a14e313
function isinalphabet(character)
	character ∈ alphabet
end

# ╔═╡ dcc4156c-f997-11ea-3e6f-057cd080d9db
isinalphabet('a'), isinalphabet('+')

# ╔═╡ 129fbcfe-f998-11ea-1c96-0fd3ccd2dcf8
md"👉 Use `filter` to extract just the characters from our alphabet out of `messy_sentence_1`:"

# ╔═╡ 3a5ee698-f998-11ea-0452-19b70ed11a1d
messy_sentence_1 = "#wow 2020 ¥500 (blingbling!)"

# ╔═╡ 75694166-f998-11ea-0428-c96e1113e2a0
cleaned_sentence_1 = filter(isinalphabet, messy_sentence_1)

# ╔═╡ 05f0182c-f999-11ea-0a52-3d46c65a049e
md"""
$(html"<br>")

We are not interested in the case of letters (i.e. `'A'` vs `'a'`), so we want to map these to lower case _before_ we apply our filter. If we don't, all upper case letters would get deleted.
"""

# ╔═╡ 98266882-f998-11ea-3270-4339fb502bc7
md"👉 Use the function `lowercase` to convert `messy_sentence_2` into a lower case string, and then use `filter` to extract only the characters from our alphabet."

# ╔═╡ d3c98450-f998-11ea-3caf-895183af926b
messy_sentence_2 = "Awesome! 😍"

# ╔═╡ d3a4820e-f998-11ea-2a5c-1f37e2a6dd0a
cleaned_sentence_2 = filter(isinalphabet, lowercase(messy_sentence_2))

# ╔═╡ aad659b8-f998-11ea-153e-3dae9514bfeb
md"""
$(html"<br>")

Finally, we need to deal with **accents**: simply deleting accented characters from the source text might deform it too much. We can add accented letters to our alphabet, but a simpler solution is to *replace* accented letters with the corresponding unaccented base character. We have written a function `unaccent` that does just that.
"""

# ╔═╡ d236b51e-f997-11ea-0c55-abb11eb35f4d
french_word = "Égalité!"

# ╔═╡ 24860970-fc48-11ea-0009-cddee695772c
import Unicode

# ╔═╡ 734851c6-f92d-11ea-130d-bf2a69e89255
"""
Turn `"áéíóúüñ asdf"` into `"aeiouun asdf"`.
"""
unaccent(str) = Unicode.normalize(str, stripmark=true)

# ╔═╡ d67034d0-f92d-11ea-31c2-f7a38ebb412f
samples = (
	English = """
Although the word forest is commonly used, there is no universally recognised precise definition, with more than 800 definitions of forest used around the world.[4] Although a forest is usually defined by the presence of trees, under many definitions an area completely lacking trees may still be considered a forest if it grew trees in the past, will grow trees in the future,[9] or was legally designated as a forest regardless of vegetation type.[10][11]
	
The word forest derives from the Old French forest (also forès), denoting "forest, vast expanse covered by trees"; forest was first introduced into English as the word denoting wild land set aside for hunting[14] without the necessity in definition of having trees on the land.[15] Possibly a borrowing, probably via Frankish or Old High German, of the Medieval Latin foresta, denoting "open wood", Carolingian scribes first used foresta in the Capitularies of Charlemagne specifically to denote the royal hunting grounds of the King. The word was not endemic to Romance languages, e. g. native words for forest in the Romance languages derived from the Latin silva, which denoted "forest" and "wood(land)" (confer the English sylva and sylvan); confer the Italian, Spanish, and Portuguese selva; the Romanian silvă; and the Old French selve, and cognates in Romance languages, e. g. the Italian foresta, Spanish and Portuguese floresta, etc., are all ultimately derivations of the French word. 
""",
	Spanish =  """
Un bosque es un ecosistema donde la vegetación predominante la constituyen los árboles y matas.1​ Estas comunidades de plantas cubren grandes áreas del globo terráqueo y funcionan como hábitats para los animales, moduladores de flujos hidrológicos y conservadores del suelo, constituyendo uno de los aspectos más importantes de la biosfera de la Tierra. Aunque a menudo se han considerado como consumidores de dióxido de carbono atmosférico, los bosques maduros son prácticamente neutros en cuanto al carbono, y son solamente los alterados y los jóvenes los que actúan como dichos consumidores.2​3​ De cualquier manera, los bosques maduros juegan un importante papel en el ciclo global del carbono, como reservorios estables de carbono y su eliminación conlleva un incremento de los niveles de dióxido de carbono atmosférico.

Los bosques pueden hallarse en todas las regiones capaces de mantener el crecimiento de árboles, hasta la línea de árboles, excepto donde la frecuencia de fuego natural es demasiado alta, o donde el ambiente ha sido perjudicado por procesos naturales o por actividades humanas. Los bosques a veces contienen muchas especies de árboles dentro de una pequeña área (como la selva lluviosa tropical y el bosque templado caducifolio), o relativamente pocas especies en áreas grandes (por ejemplo, la taiga y bosques áridos montañosos de coníferas). Los bosques son a menudo hogar de muchos animales y especies de plantas, y la biomasa por área de unidad es alta comparada a otras comunidades de vegetación. La mayor parte de esta biomasa se halla en el subsuelo en los sistemas de raíces y como detritos de plantas parcialmente descompuestos. El componente leñoso de un bosque contiene lignina, cuya descomposición es relativamente lenta comparado con otros materiales orgánicos como la celulosa y otros carbohidratos. Los bosques son áreas naturales y silvestre 
""" |> unaccent,
)

# ╔═╡ a56724b6-f9a0-11ea-18f2-991e0382eccf
unaccent(french_word)

# ╔═╡ 2ba47912-63e5-11eb-3de1-cdc44fc3644b
md"**(?)** Will uppercased accented letters still be uppercased after being `unaccent`ed?"

# ╔═╡ 15f86e34-63e5-11eb-0b8c-3b8458efbf01
unaccent("À Ú Ễ")

# ╔═╡ 8d3bc9ea-f9a1-11ea-1508-8da4b7674629
md"""
$(html"<br>")

👉 Let's put everything together. Write a function `clean` that takes a string, and returns a _cleaned_ version, where:
- accented letters are replaced by their base characters;
- upper-case letters are converted to lower case;
- it is filtered to only contain characters from `alphabet`
"""

# ╔═╡ 4affa858-f92e-11ea-3ece-258897c37e51
function clean(text)
	# we turn everything to lowercase to keep the number of letters small
	filter(isinalphabet, lowercase(unaccent(text)))
end

# ╔═╡ e00d521a-f992-11ea-11e0-e9da8255b23b
clean("Crème brûlée est mon plat préféré.")

# ╔═╡ a90c8aaa-63e4-11eb-0fcb-c10264c4a1c2
md"""
#### Stopped (2021/01/31 (日) 23h51)
"""

# ╔═╡ 2680b506-f9a3-11ea-0849-3989de27dd9f
first_sample = clean(first(samples))

# ╔═╡ 571d28d6-f960-11ea-1b2e-d5977ecbbb11
function letter_frequencies(txt)
	ismissing(txt) && return missing
	f = count.(string.(alphabet), txt)
	f ./ sum(f)
end

# ╔═╡ e42fae06-6445-11eb-1acc-9705932dd3a8
md"""
Note that
- `string(alphabet)`
- `string.(alphabet)`
- `String(alphabet)`
give three diff results.
"""

# ╔═╡ caf4ac86-6448-11eb-2e40-f16db03ae51e
count("a", "a apple a day keeps the doctors away.")

# ╔═╡ 1b5ea0f0-6449-11eb-390c-1d24d7c3cde0
count("p", "a apple a day keeps the doctors away.")

# ╔═╡ 05e07a96-6449-11eb-1c64-8392e340dd01
count("app", "a apple a day keeps the doctors away.")

# ╔═╡ 668902a4-6af8-11eb-074c-7986509edb52
count("a ", "a apple a day keeps the doctors away.")

# ╔═╡ dd1fc952-6af8-11eb-232d-eb8bc688cbf2
count("PP", "PPP", overlap=true)

# ╔═╡ 1cbe4598-6af9-11eb-33f3-d92a4e9e9365
count("PP", "PPP", overlap=false)

# ╔═╡ 88d772dc-6af8-11eb-1241-0f69214f9cd7
typeof("c")

# ╔═╡ 8dd89f70-6af8-11eb-2a3d-9f7f67ff8131
typeof('c')

# ╔═╡ 81acdbde-6af8-11eb-1c54-737cae7daa19
md"""
```
MethodError: objects of type Char are not callable

  1. _simple_count(::Char, ::String)@reduce.jl:869
  2. count@reduce.jl:864[inlined]
  3. top-level scope@Local: 1[inlined]
```
```julia
count('c', "a apple a day keeps the doctors away.")
```
"""

# ╔═╡ 3e830222-6449-11eb-3d04-e9c23aaf0775
count.(["day", "a"], "a apple a day keeps the doctors away.")

# ╔═╡ 54aa58b0-6449-11eb-195e-2fc0e042fe82
count.(["day", "a"], ["a apple a day keeps the doctors away.", "Handsome is as handsome does."])

# ╔═╡ 6a64ab12-f960-11ea-0d92-5b88943cdb1a
sample_freqs = letter_frequencies(first_sample)

# ╔═╡ 603741c2-f9a4-11ea-37ce-1b36ecc83f45
md"""
The result is a 27-element array, with values between `0.0` and `1.0`. These values correspond to the _frequency_ of each letter. 

`sample_freqs[i] == 0.0` means that the $i$th letter did not occur in your sample, and 
`sample_freqs[i] == 0.1` means that 10% of the letters in the sample are the $i$th letter.

To make it easier to convert between a character from the alphabet and its index, we have the following function:
"""

# ╔═╡ b3de6260-f9a4-11ea-1bae-9153a92c3fe5
index_of_letter(letter) = findfirst(isequal(letter), alphabet)

# ╔═╡ de8d5968-6449-11eb-3fc0-ef88c175eebc
md"**(?)** Can we implement `index_of_letter()` the C way?"

# ╔═╡ b1e967f8-6449-11eb-2e43-75b351b938c8
'z' - 'a'

# ╔═╡ 6dcc73a2-644a-11eb-2262-55a578dbe3d3
typeof(index_of_letter('6'))

# ╔═╡ eec19e0c-6449-11eb-2af8-7b0cfa7ef5bd
md"""
**(R)** Yes, we can implement it the C way. For example, like follows
"""

# ╔═╡ 0afc3c98-6450-11eb-304a-413a8b351816
iol(letter) = let
    if letter ∉ alphabet
        return Nothing
    elseif letter == ' '
        return 27
    else
        return letter - 'a' + 1
    end
end

# ╔═╡ a6c36bd6-f9a4-11ea-1aba-f75cecc90320
index_of_letter('a'), index_of_letter('b'), index_of_letter(' ')

# ╔═╡ 276fd254-6450-11eb-0b55-99ca5bdbd2bd
iol('a'), iol('b'), iol(' ')

# ╔═╡ 6d3f9dae-f9a5-11ea-3228-d147435e266d
md"""
$(html"<br>")

👉 Which letters from the alphabet did not occur in the sample?
"""

# ╔═╡ bb5f3972-6451-11eb-1a17-573ca56b2be9
[ i for (i, freq) in enumerate(sample_freqs) if freq == 0]

# ╔═╡ 93f1c5c0-6452-11eb-092f-63cc1071ddd5
alphabet[[ i for (i, freq) in enumerate(sample_freqs) if freq == 0]]

# ╔═╡ 92bf9fd2-f9a5-11ea-25c7-5966e44db6c6
unused_letters = let
	alphabet[[ i for (i, freq) in enumerate(sample_freqs) if freq == 0]]
end

# ╔═╡ c39b2870-6452-11eb-1065-11adfbe39d91
md"**(?)** What does the hint mean by _without writing any code_? Or it simply means that it is fine if we just do as follows?
```julia
unused_letters = let
	['j', 'q', 'z']
end
```
It'd be boring if that's the case." 

# ╔═╡ 01215e9a-f9a9-11ea-363b-67392741c8d4
md"""
**Random letters at the correct frequencies:**
"""

# ╔═╡ 8ae13cf0-f9a8-11ea-3919-a735c4ed9e7f
md"""
By considering the _frequencies_ of letters in English, we see that our model is already a lot better!

Our next observation is that **some letter _combinations_ are more common than others**. Our current model thinks that `potato` is just as 'English' as `ooaptt`. (Mathematically, this means that, if the occurrence of letters are independent, then `potato` is equally likely to occur as `ooaptt`.) In the next section, we will quantify these _transition frequencies_, and use it to improve our model.
"""

# ╔═╡ ee226788-6455-11eb-0eec-31b566bacb12
md"""
**(?)** Study the following two functions and recall how you would do them in Python.
"""

# ╔═╡ b5b8dd18-f938-11ea-157b-53b145357fd1
function rand_sample(frequencies)
	x = rand()  # x ∈ [0,1)
	#= 
	Actually, if sum(frequencies) == 1, then the step
	  frequencies ./ sum(frequencies)
	is redundant.
	=#
	findfirst(z -> z >= x, cumsum(frequencies ./ sum(frequencies)))
end

# ╔═╡ 0e872a6c-f937-11ea-125e-37958713a495
function rand_sample_letter(frequencies)
	alphabet[rand_sample(frequencies)]
end

# ╔═╡ 8a16baee-645a-11eb-0d36-7b6a04abd4d0
cumsum([1,2,3,4])

# ╔═╡ f807fed0-645a-11eb-243c-217a37bf9bbc
cumsum([0.25 for _ in 1:4])

# ╔═╡ c414d6ae-645a-11eb-36a5-cb3b67c3725c
[findfirst(z -> z >= rand(), cumsum([0.25 for _ in 1:4])) for _ in 1:20]

# ╔═╡ dbc446ec-6494-11eb-1948-4556a11e203e
md"""
#### Stopped (2021/02/01 (月) 16h30)
"""

# ╔═╡ 77edb54a-6462-11eb-0c70-17551e107ed7
md"""
**(R)**$(html"<br>")
After reading `rand_sample()`, I find it well implemented.

Say, we have a finite set of probability values $p_1, p_2, \ldots, p_n$ storing in the array `frequencies` and summing up to $\sum_{i=1}^{n} p_i = 1.$
Then `findfirst(z -> z >= x, cumsum(frequencies ./ sum(frequencies)))` will find the
smallest $k$ such that $\sum_{i=1}^{k} p_i \ge$ `x`. Note that `findfirst(z -> z >= x, cumsum(frequencies ./ sum(frequencies)))` $= k\;$ if and only if
- `x` $\le \sum_{i=1}^{k} p_i$
- `x` $> \sum_{i=1}^{k-1} p_i\,.$
Note also that
- since `x` is a uniform random variable in $[0,1)$, we know that, for all $p \in [0,1]$, the probability that `x` $\le p$ equals $p\,.$ 
Thus, the probability `findfirst(z -> z >= x, cumsum(frequencies ./ sum(frequencies)))` $= k$ equals
$P\big($`x`$\le \sum_{i=1}^{k} p_i \quad\text{and}\;$ `x` $> \sum_{i=1}^{k-1} p_i\big) = P\big($`x`$\le \sum_{i=1}^{k} p_i\big) - P\big($`x`$\le \sum_{i=1}^{k-1} p_i\big) = p_k\,.$

"""

# ╔═╡ d41bfe0c-6477-11eb-0b84-67ff92cdcdb5
md"""
In the past, when we do this in Python, more specifically in `numpy`, we would use the `np.random.choice()` function to write
```python
def rand_sample_letter(frequencies):
    return np.random.choice(alphabet, p=frequencies)
```
But don't think that this is superior, because if we look inside the source code of `numpy` (in `numpy`'s github page, file `numpy/numpy/random/_generator.pyx`)

In case someone curious how I located this file:
```bash
~/.../numpy-master/numpy/random ❯❯❯ grep -Rn "def choice"
_generator.pyx:598:    def choice(self, a, size=None, replace=True, p=None, axis=0, bint shuffle=True):
mtrand.pyx:806:    def choice(self, a, size=None, replace=True, p=None):
~/.../numpy-master/numpy/random ❯❯❯
```

The following lines are of particular interest.
```python
...
if replace:
    if p is not None:
        cdf = p.cumsum()
        cdf /= cdf[-1]
        uniform_samples = self.random(shape)
        idx = cdf.searchsorted(uniform_samples, side='right')
        # searchsorted returns a scalar
        idx = np.array(idx, copy=False, dtype=np.int64)
    else:
        idx = self.integers(0, pop_size, size=shape, dtype=np.int64)
else:
    if size > pop_size:
        raise ValueError("Cannot take a larger sample than "
                         "population when replace is False")
    elif size < 0:
        raise ValueError("negative dimensions are not allowed")
                                                                      
    if p is not None:
        if np.count_nonzero(p > 0) < size:
            raise ValueError("Fewer non-zero entries in p than size")
...
```
By the look of it, we can kind of see that in essence `numpy` is probably using **the
same technique** to sample a probability distribution **as the Julia code above**.
(cf. `./hw3.ipynb` if interested in the same exercises done in Python.)
"""

# ╔═╡ 56ad9938-646f-11eb-138e-f74a49020de3
md"""
#### Stopped (2021/02/01 (月) 20h50)
"""

# ╔═╡ fbb7c04e-f92d-11ea-0b81-0be20da242c8
function transition_counts(cleaned_sample)
	[count(string(a, b), cleaned_sample)
		for a in alphabet,
			b in alphabet]
end

# ╔═╡ 80118bf8-f931-11ea-34f3-b7828113ffd8
normalize_array(x) = x ./ sum(x)

# ╔═╡ 7f4f6ce4-f931-11ea-15a4-b3bec6a7e8b6
transition_frequencies = normalize_array ∘ transition_counts;

# ╔═╡ d40034f6-f9ab-11ea-3f65-7ffd1256ae9d
transition_frequencies(first_sample)

# ╔═╡ e602f9da-6aef-11eb-106a-6394abbcd72a
sum(transition_frequencies(first_sample))

# ╔═╡ 689ed82a-f9ae-11ea-159c-331ff6660a75
md"What we get is a **27 by 27 matrix**. Each entry corresponds to a character pair. The _row_ corresponds to the first character, the _column_ is the second character. Let's visualize this:"

# ╔═╡ 0b67789c-f931-11ea-113c-35e5edafcbbf
md"""
Answer the following questions with respect to the **cleaned English sample text**, which we called `first_sample`. Let's also give the transition matrix a name:
"""

# ╔═╡ 6896fef8-f9af-11ea-0065-816a70ba9670
sample_freq_matrix = transition_frequencies(first_sample);

# ╔═╡ 39152104-fc49-11ea-04dd-bb34e3600f2f
if first_sample === missing
	md"""
	!!! danger "Don't worry!"
	    👆 These errors will disappear automatically once you have completed the earlier exercises!
	"""
end

# ╔═╡ e91c6fd8-f930-11ea-01ac-476bbde79079
md"""👉 What is the frequency of the combination `"th"`?"""

# ╔═╡ da990002-6af7-11eb-185b-1db6d1549445
"th"[1]

# ╔═╡ 2d9deb94-6af8-11eb-2ae7-a1f0ed9afedc
typeof("th"[1])

# ╔═╡ 33baea36-6af8-11eb-0f78-515714025515
't' - 'a'

# ╔═╡ 42afd1e6-6af8-11eb-3993-bda68667bf81
index_of_letter('t')

# ╔═╡ 1b4c0c28-f9ab-11ea-03a6-69f69f7f90ed
th_frequency = sample_freq_matrix[index_of_letter('t'), index_of_letter('h')]

# ╔═╡ 1f94e0a2-f9ab-11ea-1347-7dd906ebb09d
md"""👉 What about `"ht"`?"""

# ╔═╡ 41b2df7c-f931-11ea-112e-ede3b16f357a
ht_frequency = sample_freq_matrix[index_of_letter('h'), index_of_letter('t')]

# ╔═╡ 1dd1e2f4-f930-11ea-312c-5ff9e109c7f6
md"""
👉 Which le**tt**ers appeared double in our sample?
"""

# ╔═╡ 65c92cac-f930-11ea-20b1-6b8f45b3f262
double_letters = [ c for c in alphabet if sample_freq_matrix[index_of_letter(c), index_of_letter(c)] > 0 ]

# ╔═╡ 71eb6f22-6afa-11eb-3ed1-55c553f415a0
sample_freq_matrix[1,:]

# ╔═╡ 877c36dc-6afa-11eb-1577-fd62528f196b
length(sample_freq_matrix[1,:])

# ╔═╡ 5aa988d0-6afa-11eb-01ad-03abb28bf5a8
argmax(sample_freq_matrix[1,:])

# ╔═╡ 4582ebf4-f930-11ea-03b2-bf4da1a8f8df
md"""
👉 Which letter is most likely to follow a **w**?
"""

# ╔═╡ 7898b76a-f930-11ea-2b7e-8126ec2b8ffd
most_likely_to_follow_w = alphabet[argmax(sample_freq_matrix[index_of_letter('w'),:])]

# ╔═╡ db7a05a2-6afa-11eb-0c0a-bf2bb3911f62
sample_freq_matrix[index_of_letter('w'),:]

# ╔═╡ 458cd100-f930-11ea-24b8-41a49f6596a0
md"""
👉 Which letter is most likely to precede a **w**?
"""

# ╔═╡ bc401bee-f931-11ea-09cc-c5efe2f11194
most_likely_to_precede_w = alphabet[argmax(sample_freq_matrix[:,index_of_letter('w')])]

# ╔═╡ f7ae6e30-6b5d-11eb-2bb7-75fa4af2bfc5
maximum(sample_freq_matrix[:,index_of_letter('w')])

# ╔═╡ fbb2fa9e-6b5d-11eb-0933-7b56a24a99d5
sort(sample_freq_matrix[:,index_of_letter('w')], rev=true)

# ╔═╡ 45c20988-f930-11ea-1d12-b782d2c01c11
md"""
👉 What is the sum of each row? What is the sum of each column? How can we interpret these values?"
"""

# ╔═╡ cc62929e-f9af-11ea-06b9-439ac08dcb52
row_col_answer = md"""
- sum of each row: Say, the row of `w`, is the frequency of `wα` appearing in the sampling text, where `α` can be any letter in `alphabet`
  - If we were to randomly sample two letters from the frequency model of the sampling text, then this sum is the probability of us sampling letters of the form `wα`
- sum of each column: Say, the column of `w`, is the frequency of `αw` appearing in the sampling text, where `α` can be any letter in `alphabet`
  - If we were to randomly sample two letters from the frequency model of the sampling text, then this sum is the probability of us sampling letters of the form `αw`

"""

# ╔═╡ ae7f0ca2-6b6b-11eb-338d-a73f7f0d5343
md"""
#### Stopped (2021/02/10 (水) 13h47)
"""

# ╔═╡ 2f8dedfc-fb98-11ea-23d7-2159bdb6a299
md"""
We can use the measured transition frequencies to generate text in a way that it has **the same transition frequencies** as our original sample. Our generated text is starting to look like real language!
"""

# ╔═╡ b7446f34-f9b1-11ea-0f39-a3c17ba740e5
@bind ex23_sample Select([v => String(k) for (k,v) in zip(fieldnames(typeof(samples)), samples)])

# ╔═╡ 4f97b572-f9b0-11ea-0a99-87af0797bf28
md"""
**Random letters from the alphabet:**
"""

# ╔═╡ 4e8d327e-f9b0-11ea-3f16-c178d96d07d9
md"""
**Random letters at the correct frequencies:**
"""

# ╔═╡ d83f8bbc-f9af-11ea-2392-c90e28e96c65
md"""
**Random letters at the correct transition frequencies:**
"""

# ╔═╡ 0e465160-f937-11ea-0ebb-b7e02d71e8a8
function sample_text(A, n)
	first_index = rand_sample(vec(sum(A, dims=1)))
	# Here I don't think dims=2 or dims=1 makes much difference
	
	indices = reduce(1:n; init=[first_index]) do word, _
		prev = last(word)
		freq = normalize_array(A[prev, :])
		next = rand_sample(freq)
		[word..., next]
	end
	
	String(alphabet[indices])
end

# ╔═╡ b8c50640-6b7e-11eb-3e0e-29d3bcd553d0
md"""
```julia
julia> A = rand(Int8, (3,3))
3×3 Array{Int8,2}:
 109   54  -121
  69  110   -63
  -7   72   -27

julia> A                                                                                        [2/48]
3×3 Array{Int8,2}:
 109   54  -121
  69  110   -63
  -7   72   -27

julia> sum(A)
196

julia> sum(A, dims=1)
1×3 Array{Int64,2}:
 171  236  -211

julia> sum(A, dims=2)
3×1 Array{Int64,2}:
  42
 116
  38

julia> vec(sum(A, dims=2))
3-element Array{Int64,1}:
  42
 116
  38

julia> vec(sum(A, dims=1))
3-element Array{Int64,1}:
  171
  236
 -211
```
"""

# ╔═╡ 885dfc98-6b8b-11eb-2a84-ff28288778f5
md"""
**(?)** Why after `do` there are two arguments `word, _`?
"""

# ╔═╡ 87a22e16-6b93-11eb-0e40-afcaefa4a3fb
begin
  sth, _ = [1,2,3,4]
  md"sth = $(sth)"
end

# ╔═╡ a64d719e-6b94-11eb-2f0c-773663fc272e
reduce(1:9; init=[3]) do a, b
	print(a, b)
	[a..., 1]
end

# ╔═╡ 4c819528-6b94-11eb-090b-19b97deb5391
reduce(1:9; init=[3]) do a, b
	[b..., 1]
end

# ╔═╡ b85d2000-6b94-11eb-2a79-d134eeebb5f3
md"""
**(R)**$(html"<br>")
I seem to understand:
```julia
# Recall the syntax of reduce()
reduce(op, itr; [init])

reduce(itr; init=sth) do a, b
  ...
  [a..., qqch]
end
```
During each iteration (in the `do ... end` block)
- `a` represents the returned value at each iteration
- `b` represents the new incoming element from `itr`

So for example, in the function `sample_text()`, the second arg is `_` because, as we iterate,
we don't really care the `k` coming from `1:n`; what we care is that we generate exactly
`n` indices and each generation is based on the previous index following the `transition_frequencies()` of some given text.


**Rmk.**
- cf. [do-block syntax](https://docs.julialang.org/en/v1/manual/functions/#Do-Block-Syntax-for-Function-Arguments). Simply speaking, do-block is just a way to postpone the specification of the function involved (in `map()`, `reduce()`, etc.), in order to make things clearer.

"""

# ╔═╡ 508f3efe-6b99-11eb-3e6a-93eacd378c96
md"""
**(?)** `ex23_sample`? Where is it defined?
"""

# ╔═╡ 141af892-f933-11ea-1e5f-154167642809
md"""
It looks like we have a decent language model, in the sense that it understands _transition frequencies_ in the language. In the demo above, try switching the language between $(join(string.(fieldnames(typeof(samples))), " and ")) -- the generated text clearly looks more like one or the other, demonstrating that the model can capture differences between the two languages. What's remarkable is that our "training data" was just a single paragraph per language.

In this exercise, we will use our model to write a **classifier**: a program that automatically classifies a text as either $(join(string.(fieldnames(typeof(samples))), " or ")). 

This is not a difficult task - you can get dictionaries for both languages, and count matches - but we are doing something much more cool: we only use a single paragraph of each language, and we use a _language model_ as classifier.
"""

# ╔═╡ 7eed9dde-f931-11ea-38b0-db6bfcc1b558
html"<h4 id='mystery-detect'>Mystery sample</h4>
<p>Enter some text here -- we will detect in which language it is written!</p>" # dont delete me

# ╔═╡ 7e3282e2-f931-11ea-272f-d90779264456
@bind mystery_sample TextField((70,8), default="""
Small boats are typically found on inland waterways such as rivers and lakes, or in protected coastal areas. However, some boats, such as the whaleboat, were intended for use in an offshore environment. In modern naval terms, a boat is a vessel small enough to be carried aboard a ship. Anomalous definitions exist, as lake freighters 1,000 feet (300 m) long on the Great Lakes are called "boats". 
""")

# ╔═╡ 18ef8776-6c2f-11eb-3081-a96f3478a137
md"""
Try with the following Italian excerpt to see if it is closer to Spanish than to English.
"""

# ╔═╡ 7df55e6c-f931-11ea-33b8-fdc3be0b6cfa
mystery_sample

# ╔═╡ 292e0384-fb57-11ea-0238-0fbe416fc976
md"""
Let's compute the transition frequencies of our mystery sample! Type some text in the box below, and check whether the frequency matrix updates.
"""

# ╔═╡ 7dabee08-f931-11ea-0cb2-c7d5afd21551
transition_frequencies(mystery_sample)

# ╔═╡ 3736a094-fb57-11ea-1d39-e551aae62b1d
md"""
Our model will **compare the transition frequencies of our mystery sample** to those of our two language sample. The closest match will be our detected language.

The only question left is: How do we compare two matrices? When two matrices are almost equal, but not exactly, we want to quantify their _distance_.

👉 Write a function called `matrix_distance` which takes 2 matrices of the same size and finds the distance between them by:

1. Subtracting corresponding elements
2. Finding the absolute value of the difference
3. Summing the differences
"""

# ╔═╡ a71c5756-6b9a-11eb-0982-bfc4fb39d523
(A = rand(Int8, (3,3))) - (B = rand(Int8, (3,3)))

# ╔═╡ b04390f6-6b9a-11eb-0f39-0b4f9db680a7
A .- B

# ╔═╡ 13c89272-f934-11ea-07fe-91b5d56dedf8
function matrix_distance(A, B)
	#missing # do something with A .- B
	sum(abs.(A .- B))
end

# ╔═╡ 7d60f056-f931-11ea-39ae-5fa18a955a77
distances = map(samples) do sample
	matrix_distance(transition_frequencies(mystery_sample), transition_frequencies(sample))
end

# ╔═╡ 7d1439e6-f931-11ea-2dab-41c66a779262
try
	@assert !ismissing(distances.English)
	"""<h2>It looks like this text is **$(argmin(distances))**!</h2>""" |> HTML
catch
end

# ╔═╡ df29829a-6b9a-11eb-21eb-5d12ae79614d
typeof(distances)

# ╔═╡ 8c7606f0-fb93-11ea-0c9c-45364892cbb8
md"""
We have written a cell that selects the language with the _smallest distance_ to the mystery language. Make sure sure that `matrix_distance` is working correctly, and [scroll up](#mystery-detect) to the mystery text to see it in action!

#### Further reading
It turns out that the SVD of the transition matrix can mysteriously group the alphabet into vowels and consonants, without any extra information. See [this paper](http://languagelog.ldc.upenn.edu/myl/Moler1983.pdf) if you want to try it yourself! We found that removing the space from `alphabet` (to match the paper) gave better results.
"""

# ╔═╡ 82e0df62-fb54-11ea-3fff-b16c87a7d45b
md"""
## **Exercise 2** - _Language generation_

Our model from Exercise 1 has the property that it can easily be 'reversed' to _generate_ text. While this is useful to demonstrate its structure, the produced text is mostly meaningless: it fails to model words, let alone sentence structure.

To take our model one step further, we are going to _generalize_ what we have done so far. Instead of looking at _letter combinations_, we will model _word combinations_.  And instead of analyzing the frequencies of bigrams (combinations of two letters), we are going to analyze _$n$-grams_.

#### Dataset
This also means that we are going to need a larger dataset to train our model on: the number of English words (and their combinations) is much higher than the number of letters.

We will train our model on the novel [_Emma_ (1815), by Jane Austen](https://en.wikipedia.org/wiki/Emma_(novel)). This work is in the public domain, which means that we can download the whole book as a text file from `archive.org`. We've done the process of downloading and cleaning already, and we have split the text into word and punctuation tokens.
"""

# ╔═╡ c73eeb28-6b9c-11eb-0f76-b159a7a4a018
# Let's see what the return value of download() is.
download("http://languagelog.ldc.upenn.edu/myl/Moler1983.pdf")

# ╔═╡ b7601048-fb57-11ea-0754-97dc4e0623a1
emma = let
	raw_text = read(download("https://ia800303.us.archive.org/24/items/EmmaJaneAusten_753/emma_pdf_djvu.txt"), String)
	
	first_words = "Emma Woodhouse"
	# We drop the introduction, prefaces, etc. to jump directly to chapter 1 of the book.
	last_words = "THE END"
	start_index = findfirst(first_words, raw_text)[1]
	stop_index = findlast(last_words, raw_text)[end]
	
	raw_text[start_index:stop_index]
end;

# ╔═╡ 0e7c1cf2-6bbd-11eb-1af5-eb91c5b25ca6
md"
The following is the reason why we needed to take `[1]` and `[end]` after `findfirst()` and `findlast()`.
"

# ╔═╡ bb0fa18a-6bbc-11eb-1bfc-8b90a9f89452
findfirst("julia", "To use vim to edit julia, I chose the vim-plug julia-vim")

# ╔═╡ e22fe214-6bbc-11eb-271d-4fdaffafe02c
findlast("julia", "To use vim to edit julia, I chose the vim-plug julia-vim")

# ╔═╡ 578a021c-6b9d-11eb-0a5a-7d2133aaf3d9
md"""
If we run `raw_text` to inspect it in a cell, we'd find out
```julia
UndefVarError: raw_text not defined

  1. top-level scope@Local: 1
```

It seems that that variable is local to `emma` and disappeared once the definition of `emma` had been done.
"""

# ╔═╡ 2f652988-6b9d-11eb-080c-1f5a7794b36c
md"""
**(?)** The function `read()`, do we really need to specify `String` as the second arg?
"""

# ╔═╡ cc42de82-fb5a-11ea-3614-25ef961729ab
function splitwords(text)
	# clean up whitespace
	cleantext = replace(text, r"\s+" => " ")
	
	# split on whitespace or other word boundaries
	tokens = split(cleantext, r"(\s|\b)")
end

# ╔═╡ 6f9d91dc-6bbd-11eb-1b02-df56016a9a44
md"""
**(?)** `\s` is white space, understandable; what does `\b` represent? A backspace?
"""

# ╔═╡ d66fe2b2-fb5a-11ea-280f-cfb12b8296ac
emma_words = splitwords(emma)

# ╔═╡ 4ca8e04a-fb75-11ea-08cc-2fdef5b31944
forest_words = splitwords(samples.English)

# ╔═╡ 6f613cd2-fb5b-11ea-1669-cbd355677649
md"""
#### Exercise 2.1 - _bigrams revisited_

The goal of the upcoming exercises is to **generalize** what we have done in Exercise 1. To keep things simple, we _split up our problem_ into smaller problems. (The solution to any computational problem.)

First, here is a function that takes an array, and returns the array of all **neighbour pairs** from the original. For example,

```julia
bigrams([1, 2, 3, 42])
```
gives

```julia
[[1,2], [2,3], [3,42]]
```

(We used integers as "words" in this example, but our function works with any type of word.)
"""

# ╔═╡ 91e87974-fb78-11ea-3ce4-5f64e506b9d2
function bigrams(words)
	map(1:length(words)-1) do i
		words[i:i+1]
	end
end

# ╔═╡ 9f98e00e-fb78-11ea-0f6c-01206e7221d6
bigrams([1, 2, 3, 42])

# ╔═╡ 813be58c-6bbe-11eb-3364-3fb0874ece6a
md"""
I kind of forget and thus become suddenly curious about the `typeof` these arrays and how Pluto displays them. Let's do a tiny experiment.
"""

# ╔═╡ 164c1102-6bbe-11eb-1160-ab715946eb93
[[1,2], [2,3], [3,42]]

# ╔═╡ 332c21a2-6bbe-11eb-006f-b1d50f56e91c
typeof([[1,2], [2,3], [3,42]])

# ╔═╡ 2c542c14-6bbe-11eb-25aa-41d93ac6d7f3
[1, 2, 3, 42]

# ╔═╡ 45f22822-6bbe-11eb-0e1f-338dab65ed83
typeof([1, 2, 3, 42])

# ╔═╡ bd70bea4-6bbe-11eb-2eb6-2dc8bbe9608a
md"""
So Pluto kind of like displays arrays in the form `Type[element1, element2, element3]`, where like the above `Type` can be `Int64`, `Array{Int64,1}`, etc.

It makes one wonder whether the following is legitimate in a Julia array.
- It's inlegitimate in `ndarray` (`numpy`)
- legitimate in Python `list`
"""

# ╔═╡ 72926be6-6bbe-11eb-0123-0ded9b5b8fe1
[[1], [2,2], [3,3,3]]

# ╔═╡ 75964a7e-6bbe-11eb-226f-2b7d8429fc90
typeof([[1], [2,2], [3,3,3]])

# ╔═╡ d7d8cd0c-fb6a-11ea-12bf-2d1448b38162
md"""
👉 Next, it's your turn to write a more general function `ngrams` that takes an array and a number $n$, and returns all **subsequences of length $n$**. For example:

```julia
ngrams([1, 2, 3, 42], 3)
```
should give

```julia
[[1,2,3], [2,3,42]]
```

and

```julia
ngrams([1, 2, 3, 42], 2) == bigrams([1, 2, 3, 42])
```
"""

# ╔═╡ 7be98e04-fb6b-11ea-111d-51c48f39a4e9
function ngrams(words, n)
  map(1:length(words)-(n-1)) do i
    words[i:i+(n-1)]
  end
end

# ╔═╡ 052f822c-fb7b-11ea-382f-af4d6c2b4fdb
ngrams([1, 2, 3, 42], 3)

# ╔═╡ 067f33fc-fb7b-11ea-352e-956c8727c79f
ngrams(forest_words, 4)

# ╔═╡ 114ec026-6bc0-11eb-3d60-2b51098a4401
typeof(forest_words)

# ╔═╡ 3e85b00e-6bc0-11eb-01bb-25d5ec0d586a
md"""
**(?)** `Array{SubString{String},1}`. Why the type was `SubString{String}` instead of simply `String`?
"""

# ╔═╡ 95819b20-6bc0-11eb-04d6-4dea0e1ca743
md"""
#### Stopped (2021/02/10 (水) 23h54)
"""

# ╔═╡ 7b10f074-fb7c-11ea-20f0-034ddff41bc3
md"""
If you are stuck, you can write `ngrams(words, n) = bigrams(words)` (ignoring the true value of $n$), and continue with the other exercises.

#### Exercise 2.2 - _frequency matrix revisisted_
In Exercise 1, we use a 2D array to store the bigram frequencies, where each column or row corresponds to a character from the alphabet. If we use trigrams, we could store the frequencies in a 3D array, and so on. 

However, when counting words instead of letters, we run into a problem. A 3D array with one row, column and layer per word has too many elements to store on our computer.
"""

# ╔═╡ 24ae5da0-fb7e-11ea-3480-8bb7b649abd5
md"""
_Emma_ consists of $(
	length(Set(emma_words))
) unique words. This means that there are $(
	Int(floor(length(Set(emma_words))^3 / 10^9))
) billion possible trigrams - that's too much!
"""

# ╔═╡ edaed7c0-6c35-11eb-27df-7d8de07855fb
8465^3

# ╔═╡ 47836744-fb7e-11ea-2305-3fa5819dc154
md"""
$(html"<br>")

Although the frequency array would be very large, most entries are zero. For example, _"Emma"_ is a common word, but _"Emma Emma Emma"_ does not occur in the novel. This _sparsity_ of non-zero entries can be used to **store the same information in a more efficient structure**. 

Julia's [`SparseArrays.jl` package](https://docs.julialang.org/en/v1/stdlib/SparseArrays/index.html) might sound like a logical choice, but these arrays only support 1D and 2D types, and we also want to directly index using strings, not just integers. So instead, we will use `Dict`, the dictionary type.
"""

# ╔═╡ df4fc31c-fb81-11ea-37b3-db282b36f5ef
healthy = Dict("fruits" => ["🍎", "🍊"], "vegetables" => ["🌽", "🎃", "🍕"])

# ╔═╡ c83b1770-fb82-11ea-20a6-3d3a09606c62
healthy["fruits"]

# ╔═╡ 52970ac4-fb82-11ea-3040-8bd0590348d2
md"""
(Did you notice something funny? The dictionary is _unordered_, this is why the entries were printed in reverse from the definition.)

You can dynamically add or change values of a `Dict` by assigning to `my_dict[key]`. You can check whether a key already exists using `haskey(my_dict, key)`.

👉 Use these two techniques to write a function `word_counts` that takes an array of words, and returns a `Dict` with entries `word => number_of_occurences`.

For example:
```julia
word_counts(["to", "be", "or", "not", "to", "be"])
```
should return
```julia
Dict(
	"to" => 2, 
	"be" => 2, 
	"or" => 1, 
	"not" => 1
)
```
"""

# ╔═╡ e3095812-6c36-11eb-05bf-893697c0e8bf
haskey(healthy, "fruits"), haskey(healthy, "candy")

# ╔═╡ 8ce3b312-fb82-11ea-200c-8d5b12f03eea
function word_counts(words::Vector)
  counts = Dict()
  # your code here
  for word in words
    if haskey(counts, word)
      counts[word] += 1
    else
      counts[word] = 1
    end
  end
  return counts
end

# ╔═╡ a2214e50-fb83-11ea-3580-210f12d44182
word_counts(["to", "be", "or", "not", "to", "be"])

# ╔═╡ 808abf6e-fb84-11ea-0785-2fc3f1c4a09f
md"""
How many times does `"Emma"` occur in the book?
"""

# ╔═╡ 953363dc-fb84-11ea-1128-ebdfaf5160ee
emma_count = word_counts(emma_words)["Emma"]

# ╔═╡ 294b6f50-fb84-11ea-1382-03e9ab029a2d
md"""
Great! Let's get back to our ngrams. For the purpose of generating text, we are going to store a _completions cache_. This is a dictionary where the keys are $(n-1)$-grams, and the values are all found words that complete it to an $n$-gram. Let's look at an example:

```julia
let
	trigrams = ngrams(split("to be or not to be that is the question", " "), 3)
	cache = completions_cache(trigrams)
	cache == Dict(
		["to", "be"] => ["or", "that"],
		["be", "or"] => ["not"],
		["or", "not"] => ["to"],
		...
	)
end
```

So for trigrams, our keys are the first $2$ words of each trigram, and the values are arrays containing every third word of those trigrams.

If the same ngram occurs multiple times (e.g. "said Emma laughing"), then the last word ("laughing") should also be stored multiple times. This will allow us to generate trigrams with the same frequencies as the original text.

👉 Write the function `completions_cache`, which takes an array of ngrams (i.e. an array of arrays of words, like the result of your `ngram` function), and returns a dictionary like described above.
"""

# ╔═╡ c81e5cc4-6c3a-11eb-3e90-239b79413a44
ngrams(split("to be or not to be that is the question", " "), 3)

# ╔═╡ fb6224ac-6c3b-11eb-1720-bd3fbc8fbd5c
md"""
`[1,2,3][:end-1]` is incorrect in Julia and will produce the following error message:
```
MethodError: no method matching -(::Symbol, ::Int64)
Closest candidates are:
-(!Matched::BigInt, ::Union{Int16, Int32, Int64, Int8}) at gmp.jl:532
-(!Matched::Base.CoreLogging.LogLevel, ::Integer) at logging.jl:117
-(!Matched::Missing, ::Number) at missing.jl:115
...
  1. top-level scope@Local: 1[inlined]
```
"""

# ╔═╡ cbff257a-6c3b-11eb-18b8-f3c965d85879
[1,2,3][end], [1,2,3][1:end-1]

# ╔═╡ b726f824-fb5e-11ea-328e-03a30544037f
function completions_cache(grams)
  cache = Dict()
  # your code here
  for gram in grams
    body, tail = gram[1:end-1], gram[end]
    if haskey(cache, body)
      cache[body] = [cache[body]..., tail]
    else
      cache[body] = [tail]
    end
  end
  cache
end

# ╔═╡ 18355314-fb86-11ea-0738-3544e2e3e816
let
	trigrams = ngrams(split("to be or not to be that is the question", " "), 3)
	completions_cache(trigrams)
end

# ╔═╡ f685b4d4-6c3c-11eb-1d81-6b960cdf6c10
md"""
#### Stopped (2021/02/11 (木) 14h44)
"""

# ╔═╡ 3d105742-fb8d-11ea-09b0-cd2e77efd15c
md"""
#### Exercise 2.4 - _write a novel_

We have everything we need to generate our own novel! The final step is to sample random ngrams, in a way that each next ngram overlaps with the previous one. We've done this in the function `generate_from_ngrams` below - feel free to look through the code, or to implement your own version.
"""

# ╔═╡ a72fcf5a-fb62-11ea-1dcc-11451d23c085
"""
	generate_from_ngrams(grams, num_words)

Given an array of ngrams (i.e. an array of arrays of words), generate a sequence of `num_words` words by sampling random ngrams.
"""
function generate_from_ngrams(grams, num_words)
	n = length(first(grams))
	cache = completions_cache(grams)
	
	# we need to start the sequence with at least n-1 words.
	# a simple way to do so is to pick a random ngram!
	sequence = [rand(grams)...]
	
	# we iteratively add one more word at a time
	for i ∈ n+1:num_words
		# the previous n-1 words
		tail = sequence[end-(n-2):end]
		
		# possible next words
		completions = cache[tail]
		
		choice = rand(completions)
		push!(sequence, choice)
	end
	sequence
end

# ╔═╡ f83991c0-fb7c-11ea-0e6f-1f80709d00c1
"Compute the ngrams of an array of words, but add the first n-1 at the end, to ensure that every ngram ends in the the beginning of another ngram."
function ngrams_circular(words, n)
	ngrams([words..., words[1:n-1]...], n)
end

# ╔═╡ abe2b862-fb69-11ea-08d9-ebd4ba3437d5
completions_cache(ngrams_circular(forest_words, 3))

# ╔═╡ 4b27a89a-fb8d-11ea-010b-671eba69364e
"""
	generate(source_text::AbstractString, num_token; n=3, use_words=true)

Given a source text, generate a `String` that "looks like" the original text by satisfying the same ngram frequency distribution as the original.
"""
function generate(source_text::AbstractString, s; n=3, use_words=true)
	# assign diff function to the variable preprocess according to use_words
	preprocess = if use_words
		splitwords
	else
		collect
	end
	
	words = preprocess(source_text)
	if length(words) < n
		""
	else
		grams = ngrams_circular(words, n)
		result = generate_from_ngrams(grams, s)
		if use_words
			join(result, " ")
		else
			String(result)
		end
	end
end

# ╔═╡ c9d3adfc-6c4a-11eb-3673-1f07741874c8
collect("to be or not to be")

# ╔═╡ d7b7a14a-fb90-11ea-3e2b-2fd8f379b4d8
md"
#### Interactive demo

Enter your own text in the box below, and use that as training data to generate anything!
"

# ╔═╡ 1939dbea-fb63-11ea-0bc2-2d06b2d4b26c
@bind generate_demo_sample TextField((50,5), default=samples.English)

# ╔═╡ 70169682-fb8c-11ea-27c0-2dad2ff3080f
md"""Using $(@bind generate_sample_n_letters NumberField(1:5))grams for characters"""

# ╔═╡ c0e40282-6c4a-11eb-22aa-0f6ca37207fe
typeof(generate_demo_sample)

# ╔═╡ 402562b0-fb63-11ea-0769-375572cc47a8
md"""Using $(@bind generate_sample_n_words NumberField(1:5))grams for words"""

# ╔═╡ 2521bac8-fb8f-11ea-04a4-0b077d77529e
md"""
### Automatic Jane Austen

Uncomment the cell below to generate some Jane Austen text:
"""

# ╔═╡ cc07f576-fbf3-11ea-2c6f-0be63b9356fc
if student.name == "Jazzy Doe"
	md"""
	!!! danger "Before you submit"
	    Remember to fill in your **name** and **Kerberos ID** at the top of this notebook.
	"""
end

# ╔═╡ 6b4d6584-f3be-11ea-131d-e5bdefcc791b
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 54b1e236-fb53-11ea-3769-b382ef8b25d6
function Quote(text::AbstractString)
	text |> Markdown.Paragraph |> Markdown.BlockQuote |> Markdown.MD
end

# ╔═╡ b3dad856-f9a7-11ea-1552-f7435f1cb605
String(rand(alphabet, 400)) |> Quote

# ╔═╡ be55507c-f9a7-11ea-189c-4ffe8377212e
if sample_freqs !== missing
	String([rand_sample_letter(sample_freqs) for _ in 1:400]) |> Quote
end

# ╔═╡ 46c905d8-f9b0-11ea-36ed-0515e8ed2621
String(rand(alphabet, 400)) |> Quote

# ╔═╡ 489b03d4-f9b0-11ea-1de0-11d4fe4e7c69
String([rand_sample_letter(letter_frequencies(ex23_sample)) for _ in 1:400]) |> Quote

# ╔═╡ fd202410-f936-11ea-1ad6-b3629556b3e0
sample_text(transition_frequencies(clean(ex23_sample)), 400) |> Quote

# ╔═╡ 518192d0-6c2f-11eb-293b-354131db5680
"""
Già in epoca classica esisteva un uso "volgare" del latino, pervenutoci attraverso testi non letterari, graffiti, iscrizioni non ufficiali o testi letterari attenti a riprodurre la lingua parlata, come accade spesso nella commedia. Accanto a questo, esisteva un latino "letterario", adottato dagli scrittori classici e legato alla lingua scritta, ma anche alla lingua parlata dai ceti socialmente più rilevanti e più colti.

Con la caduta dell'Impero romano e la formazione dei regni romano-barbarici, si verificò una sclerotizzazione del latino scritto (che diventò lingua amministrativa e scolastica), mentre il latino parlato si fuse sempre più intimamente con i dialetti dei popoli latinizzati, dando vita alle lingue neolatine, tra cui l'italiano.

Gli storici della lingua italiana etichettano le parlate che si svilupparono in questo modo in Italia durante il Medioevo come "volgari italiani", al plurale, e non ancora come "lingua italiana". Le testimonianze disponibili mostrano infatti marcate differenze tra le parlate delle diverse zone, mentre mancava un comune modello volgare di riferimento.[senza fonte]

Il primo documento tradizionalmente riconosciuto di uso di un volgare italiano è un placito notarile, conservato nell'abbazia di Montecassino, proveniente dal Principato di Capua e risalente al 960: è il Placito cassinese (detto anche Placito di Capua o "Placito capuano"), che in sostanza è una testimonianza giurata di un abitante circa una lite sui confini di proprietà tra il monastero benedettino di Capua afferente ai Benedettini dell'abbazia di Montecassino e un piccolo feudo vicino, il quale aveva ingiustamente occupato una parte del territorio dell'abbazia: «Sao ko kelle terre per kelle fini que ki contene trenta anni le possette parte Sancti Benedicti.» ("So [dichiaro] che quelle terre nei confini qui contenuti (qui riportati) per trent'anni sono state possedute dall'ordine benedettino"). È soltanto una frase, che tuttavia per svariati motivi può essere considerata ormai "volgare" e non più schiettamente latina: i casi (salvo il genitivo Sancti Benedicti, che riprende la dizione del latino ecclesiastico) sono scomparsi, sono presenti la congiunzione ko ("che") e il dimostrativo kelle ("quelle"), morfologicamente il verbo sao (dal latino sapio) è prossimo alla forma italiana, ecc. Questo documento è seguito a brevissima distanza da altri placiti provenienti dalla stessa area geografico-linguistica, come il Placito di Sessa Aurunca e il Placito di Teano
""" |> Quote

# ╔═╡ b5dff8b8-fb6c-11ea-10fc-37d2a9adae8c
generate(
	generate_demo_sample, 400; 
	n=generate_sample_n_letters, 
	use_words=false
) |> Quote

# ╔═╡ ee8c5808-fb5f-11ea-19a1-3d58217f34dc
generate(
	generate_demo_sample, 100; 
	n=generate_sample_n_words, 
	use_words=true
) |> Quote

# ╔═╡ 49b69dc2-fb8f-11ea-39af-030b5c5053c3
generate(emma, 100; n=4) |> Quote

# ╔═╡ ddef9c94-fb96-11ea-1f17-f173a4ff4d89
function compimg(img, labels=[c*d for c in replace(alphabet, ' ' => "_"), d in replace(alphabet, ' ' => "_")])
	xmax, ymax = size(img)
	xmin, ymin = 0, 0
	arr = [(j-1, i-1) for i=1:ymax, j=1:xmax]

	compose(context(units=UnitBox(xmin, ymin, xmax, ymax)),
		fill(vec(img)),
		compose(context(),
			fill("white"), font("monospace"), 
			text(first.(arr) .+ .1, last.(arr) .+ 0.6, labels)),
		rectangle(
			first.(arr),
			last.(arr),
			fill(1.0, length(arr)),
			fill(1.0, length(arr))))
end

# ╔═╡ b7803a28-fb96-11ea-3e30-d98eb322d19a
function show_pair_frequencies(A)
	imshow = let
		to_rgb(x) = RGB(0.36x, 0.82x, 0.8x)
		to_rgb.(A ./ maximum(abs.(A)))
	end
	compimg(imshow)
end

# ╔═╡ ace3dc76-f9ae-11ea-2bee-3d0bfa57cfbc
show_pair_frequencies(transition_frequencies(first_sample))

# ╔═╡ ffc17f40-f380-11ea-30ee-0fe8563c0eb1
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 7df7ab82-f9ad-11ea-2243-21685d660d71
hint(md"You can answer this question without writing any code: have a look at the values of `sample_freqs`.")

# ╔═╡ e467c1c6-fbf2-11ea-0d20-f5798237c0a6
hint(md"Start out with the same code as `bigrams`, and use the Julia documentation to learn how it works. How can we generalize the `bigram` function into the `ngram` function? It might help to do this on paper first.")

# ╔═╡ ffc40ab2-f380-11ea-2136-63542ff0f386
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ ffceaed6-f380-11ea-3c63-8132d270b83f
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ ffde44ae-f380-11ea-29fb-2dfcc9cda8b4
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ ffe326e0-f380-11ea-3619-61dd0592d409
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ fff5aedc-f380-11ea-2a08-99c230f8fa32
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 954fc466-fb7b-11ea-2724-1f938c6b93c6
let
	output = ngrams([1, 2, 3, 42], 2)

	if output isa Missing
		still_missing()
	elseif !(output isa Vector{<:Vector})
		keep_working(md"Make sure that `ngrams` returns an array of arrays.")
	elseif output == [[1,2], [2,3], [3,42]]
		if ngrams([1,2,3], 1) == [[1],[2],[3]]
			if ngrams([1,2,3], 3) == [[1,2,3]]
				if ngrams(["a"],1) == [["a"]]
					correct()
				else
					keep_working(md"`ngrams` should work with any type, not just integers!")
				end
			else
				keep_working(md"`ngrams(x, 3)` did not give a correct result.")
			end
		else
			keep_working(md"`ngrams(x, 1)` did not give a correct result.")			
		end
	else
		keep_working(md"`ngrams(x, 2)` did not give the correct bigrams. Start out with the same code as `bigrams`.")
	end
end

# ╔═╡ a9ffff9a-fb83-11ea-1efd-2fc15538e52f
let
	output = word_counts(["to", "be", "or", "not", "to", "be"])

	if output === nothing
		keep_working(md"Did you forget to write `return`?")
	elseif output == Dict()
		still_missing(md"Write your function `word_counts` above.")
	elseif !(output isa Dict)
		keep_working(md"Make sure that `word_counts` returns a `Dict`.")
	elseif output == Dict("to" => 2, "be" => 2, "or" => 1, "not" => 1)
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 00026442-f381-11ea-2b41-bde1fff66011
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 6fe693c8-f9a1-11ea-1983-f159131880e9
if !@isdefined(messy_sentence_1)
	not_defined(:messy_sentence_1)
elseif !@isdefined(cleaned_sentence_1)
	not_defined(:cleaned_sentence_1)
else
	if cleaned_sentence_1 isa Missing
		still_missing()
	elseif cleaned_sentence_1 isa Vector{Char}
		keep_working(md"Use `String(x)` to turn an array of characters `x` into a `String`.")
	elseif cleaned_sentence_1 == filter(isinalphabet, messy_sentence_1)
		correct()
	else
		keep_working()
	end
end

# ╔═╡ cee0f984-f9a0-11ea-2c3c-53fe26156ea4
if !@isdefined(messy_sentence_2)
	not_defined(:messy_sentence_2)
elseif !@isdefined(cleaned_sentence_2)
	not_defined(:cleaned_sentence_2)
else
	if cleaned_sentence_2 isa Missing
		still_missing()
	elseif cleaned_sentence_2 isa Vector{Char}
		keep_working(md"Use `String(x)` to turn an array of characters `x` into a `String`.")
	elseif cleaned_sentence_2 == filter(isinalphabet, lowercase(messy_sentence_2))
		correct()
	else
		keep_working()
	end
end

# ╔═╡ ddfb1e1c-f9a1-11ea-3625-f1170272e96a
if !@isdefined(clean)
	not_defined(:clean)
else
	let
		input = "Aè !!!  x1"
		output = clean(input)
		
		
		if output isa Missing
			still_missing()
		elseif output isa Vector{Char}
			keep_working(md"Use `String(x)` to turn an array of characters `x` into a `String`.")
		elseif output == "ae   x"
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ 95b81778-f9a5-11ea-3f51-019430bc8fa8
if !@isdefined(unused_letters)
	not_defined(:unused_letters)
else
	if sample_freqs === missing
		md"""
		!!! warning "Oopsie!"
		    You need to complete the previous exercises first.
		"""
	elseif unused_letters isa Missing
		still_missing()
	elseif unused_letters isa String
		keep_working(md"Use `collect` to turn a string into an array of characters.")
	elseif Set(index_of_letter.(unused_letters)) == Set(findall(isequal(0.0), sample_freqs))
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 489fe282-f931-11ea-3dcb-35d4f2ac8b40
if !@isdefined(th_frequency)
	not_defined(:th_frequency)
elseif !@isdefined(ht_frequency)
	not_defined(:ht_frequency)
else
	if th_frequency isa Missing  || ht_frequency isa Missing
		still_missing()
	elseif th_frequency < ht_frequency
		keep_working(md"Looks like your answers should be flipped. Which combination is more frequent in English?")
	elseif th_frequency == sample_freq_matrix[index_of_letter('t'), index_of_letter('h')] && ht_frequency == sample_freq_matrix[index_of_letter('h'), index_of_letter('t')] 
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 671525cc-f930-11ea-0e71-df9d4aae1c05
if !@isdefined(double_letters)
	not_defined(:double_letters)
end

# ╔═╡ a5fbba46-f931-11ea-33e1-054be53d986c
if !@isdefined(most_likely_to_follow_w)
	not_defined(:most_likely_to_follow_w)
end

# ╔═╡ ba695f6a-f931-11ea-0fbb-c3ef1374270e
if !@isdefined(most_likely_to_precede_w)
	not_defined(:most_likely_to_precede_w)
end

# ╔═╡ b09f5512-fb58-11ea-2527-31bea4cee823
if !@isdefined(matrix_distance)
	not_defined(:matrix_distance)
else
	try
	let
		A = rand(Float64, (5,4))
		B = rand(Float64, (5,4))
		
		output = matrix_distance(A,B)
		
		if output isa Missing
			still_missing()
		elseif !(output isa Number)
			keep_working(md"Make sure that `matrix_distance` returns a nunmber.")
		elseif output == 0.0
			keep_working(md"Two different matrices should have non-zero distance.")
		else
			if matrix_distance(A,B) < 0 || matrix_distance(B,A) < 0
				keep_working(md"The distance between two matrices should always be positive.")
			elseif matrix_distance(A,A) != 0
				almost(md"The distance between two identical matrices should be zero.")
			elseif matrix_distance([1 -1], [0 0]) == 0.0
				almost(md"`matrix_distance([1 -1], [0 0])` should not be zero.")
			else
				correct()
			end
		end
	end
	catch
		keep_working(md"The function errored.")
	end
end

# ╔═╡ 00115b6e-f381-11ea-0bc6-61ca119cb628
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ c086bd1e-f384-11ea-3b26-2da9e24360ca
bigbreak

# ╔═╡ eaa8c79e-f9a2-11ea-323f-8bb2bd36e11c
md"""
$(bigbreak)
#### Exercise 1.2 - _Letter frequencies_

We are going to count the _frequency_ of each letter in this sample, after applying your `clean` function. Can you guess which character is most frequent?
"""

# ╔═╡ dcffd7d2-f9a6-11ea-2230-b1afaecfdd54
md"""
$(bigbreak)
Now that we know the frequencies of letters in English, we can generate random text that already looks closer to English!

**Random letters from the alphabet:**
"""

# ╔═╡ 77623f3e-f9a9-11ea-2f46-ff07bd27cd5f
md"""
$(bigbreak)
#### Exercise 1.3 - _Transition frequencies_
In the previous exercise we computed the frequency of each letter in the sample by _counting_ their occurences, and then dividing by the total number of counts.

In this exercise, we are going to count _letter transitions_, such as `aa`, `as`, `rt`, `yy`. Two letters might both be common, like `a` and `e`, but their combination, `ae`, is uncommon in English. 

To quantify this observation, we will do the same as in our last exercise: we count occurences in a _sample text_, to create the **transition frequency matrix**.
"""

# ╔═╡ d3d7bd9c-f9af-11ea-1570-75856615eb5d
bigbreak

# ╔═╡ 6718d26c-f9b0-11ea-1f5a-0f22f7ddffe9

md"""
$(bigbreak)

#### Exercise 1.4 - _Language detection_
"""

# ╔═╡ 568f0d3a-fb54-11ea-0f77-171718ef12a5
bigbreak

# ╔═╡ 7f341c4e-fb54-11ea-1919-d5421d7a2c75
bigbreak

# ╔═╡ Cell order:
# ╟─e6b6760a-f37f-11ea-3ae1-65443ef5a81a
# ╠═ec66314e-f37f-11ea-0af4-31da0584e881
# ╟─85cfbd10-f384-11ea-31dc-b5693630a4c5
# ╠═33e43c7c-f381-11ea-3abc-c942327456b1
# ╟─938185ec-f384-11ea-21dc-b56b7469f798
# ╠═86e1ee96-f314-11ea-03f6-0f549b79e7c9
# ╠═a4937996-f314-11ea-2ff9-615c888afaa8
# ╟─b49a21a6-f381-11ea-1a98-7f144c55c9b7
# ╟─c086bd1e-f384-11ea-3b26-2da9e24360ca
# ╟─6f9df800-f92d-11ea-2d49-c1aaabd2d012
# ╠═b61722cc-f98f-11ea-22ae-d755f61f78c3
# ╠═f457ad44-f990-11ea-0e2d-2bb7627716a8
# ╠═4efc051e-f92e-11ea-080e-bde6b8f9295a
# ╟─38d1ace8-f991-11ea-0b5f-ed7bd08edde5
# ╠═ddf272c8-f990-11ea-2135-7bf1a6dca0b7
# ╟─3cc688d2-f996-11ea-2a6f-0b4c7a5b74c2
# ╠═d67034d0-f92d-11ea-31c2-f7a38ebb412f
# ╟─a094e2ac-f92d-11ea-141a-3566552dd839
# ╠═27c9a7f4-f996-11ea-1e46-19e3fc840ad9
# ╟─f2a4edfa-f996-11ea-1a24-1ba78fd92233
# ╠═5c74a052-f92e-11ea-2c5b-0f1a3a14e313
# ╠═dcc4156c-f997-11ea-3e6f-057cd080d9db
# ╟─129fbcfe-f998-11ea-1c96-0fd3ccd2dcf8
# ╠═3a5ee698-f998-11ea-0452-19b70ed11a1d
# ╠═75694166-f998-11ea-0428-c96e1113e2a0
# ╠═6fe693c8-f9a1-11ea-1983-f159131880e9
# ╟─05f0182c-f999-11ea-0a52-3d46c65a049e
# ╟─98266882-f998-11ea-3270-4339fb502bc7
# ╠═d3c98450-f998-11ea-3caf-895183af926b
# ╠═d3a4820e-f998-11ea-2a5c-1f37e2a6dd0a
# ╟─cee0f984-f9a0-11ea-2c3c-53fe26156ea4
# ╟─aad659b8-f998-11ea-153e-3dae9514bfeb
# ╠═d236b51e-f997-11ea-0c55-abb11eb35f4d
# ╠═a56724b6-f9a0-11ea-18f2-991e0382eccf
# ╠═24860970-fc48-11ea-0009-cddee695772c
# ╠═734851c6-f92d-11ea-130d-bf2a69e89255
# ╟─2ba47912-63e5-11eb-3de1-cdc44fc3644b
# ╠═15f86e34-63e5-11eb-0b8c-3b8458efbf01
# ╟─8d3bc9ea-f9a1-11ea-1508-8da4b7674629
# ╠═4affa858-f92e-11ea-3ece-258897c37e51
# ╠═e00d521a-f992-11ea-11e0-e9da8255b23b
# ╟─ddfb1e1c-f9a1-11ea-3625-f1170272e96a
# ╟─a90c8aaa-63e4-11eb-0fcb-c10264c4a1c2
# ╟─eaa8c79e-f9a2-11ea-323f-8bb2bd36e11c
# ╠═2680b506-f9a3-11ea-0849-3989de27dd9f
# ╠═571d28d6-f960-11ea-1b2e-d5977ecbbb11
# ╟─e42fae06-6445-11eb-1acc-9705932dd3a8
# ╠═caf4ac86-6448-11eb-2e40-f16db03ae51e
# ╠═1b5ea0f0-6449-11eb-390c-1d24d7c3cde0
# ╠═05e07a96-6449-11eb-1c64-8392e340dd01
# ╠═668902a4-6af8-11eb-074c-7986509edb52
# ╠═dd1fc952-6af8-11eb-232d-eb8bc688cbf2
# ╠═1cbe4598-6af9-11eb-33f3-d92a4e9e9365
# ╠═88d772dc-6af8-11eb-1241-0f69214f9cd7
# ╠═8dd89f70-6af8-11eb-2a3d-9f7f67ff8131
# ╟─81acdbde-6af8-11eb-1c54-737cae7daa19
# ╠═3e830222-6449-11eb-3d04-e9c23aaf0775
# ╠═54aa58b0-6449-11eb-195e-2fc0e042fe82
# ╠═6a64ab12-f960-11ea-0d92-5b88943cdb1a
# ╟─603741c2-f9a4-11ea-37ce-1b36ecc83f45
# ╠═b3de6260-f9a4-11ea-1bae-9153a92c3fe5
# ╟─de8d5968-6449-11eb-3fc0-ef88c175eebc
# ╠═b1e967f8-6449-11eb-2e43-75b351b938c8
# ╠═6dcc73a2-644a-11eb-2262-55a578dbe3d3
# ╟─eec19e0c-6449-11eb-2af8-7b0cfa7ef5bd
# ╠═0afc3c98-6450-11eb-304a-413a8b351816
# ╠═a6c36bd6-f9a4-11ea-1aba-f75cecc90320
# ╠═276fd254-6450-11eb-0b55-99ca5bdbd2bd
# ╟─6d3f9dae-f9a5-11ea-3228-d147435e266d
# ╠═bb5f3972-6451-11eb-1a17-573ca56b2be9
# ╠═93f1c5c0-6452-11eb-092f-63cc1071ddd5
# ╠═92bf9fd2-f9a5-11ea-25c7-5966e44db6c6
# ╠═95b81778-f9a5-11ea-3f51-019430bc8fa8
# ╠═7df7ab82-f9ad-11ea-2243-21685d660d71
# ╟─c39b2870-6452-11eb-1065-11adfbe39d91
# ╟─dcffd7d2-f9a6-11ea-2230-b1afaecfdd54
# ╟─b3dad856-f9a7-11ea-1552-f7435f1cb605
# ╟─01215e9a-f9a9-11ea-363b-67392741c8d4
# ╠═be55507c-f9a7-11ea-189c-4ffe8377212e
# ╟─8ae13cf0-f9a8-11ea-3919-a735c4ed9e7f
# ╟─ee226788-6455-11eb-0eec-31b566bacb12
# ╠═b5b8dd18-f938-11ea-157b-53b145357fd1
# ╠═0e872a6c-f937-11ea-125e-37958713a495
# ╠═8a16baee-645a-11eb-0d36-7b6a04abd4d0
# ╠═f807fed0-645a-11eb-243c-217a37bf9bbc
# ╠═c414d6ae-645a-11eb-36a5-cb3b67c3725c
# ╟─dbc446ec-6494-11eb-1948-4556a11e203e
# ╟─77edb54a-6462-11eb-0c70-17551e107ed7
# ╟─d41bfe0c-6477-11eb-0b84-67ff92cdcdb5
# ╟─56ad9938-646f-11eb-138e-f74a49020de3
# ╟─77623f3e-f9a9-11ea-2f46-ff07bd27cd5f
# ╠═fbb7c04e-f92d-11ea-0b81-0be20da242c8
# ╠═80118bf8-f931-11ea-34f3-b7828113ffd8
# ╠═7f4f6ce4-f931-11ea-15a4-b3bec6a7e8b6
# ╠═d40034f6-f9ab-11ea-3f65-7ffd1256ae9d
# ╠═e602f9da-6aef-11eb-106a-6394abbcd72a
# ╟─689ed82a-f9ae-11ea-159c-331ff6660a75
# ╠═ace3dc76-f9ae-11ea-2bee-3d0bfa57cfbc
# ╟─0b67789c-f931-11ea-113c-35e5edafcbbf
# ╠═6896fef8-f9af-11ea-0065-816a70ba9670
# ╠═39152104-fc49-11ea-04dd-bb34e3600f2f
# ╟─e91c6fd8-f930-11ea-01ac-476bbde79079
# ╠═da990002-6af7-11eb-185b-1db6d1549445
# ╠═2d9deb94-6af8-11eb-2ae7-a1f0ed9afedc
# ╠═33baea36-6af8-11eb-0f78-515714025515
# ╠═42afd1e6-6af8-11eb-3993-bda68667bf81
# ╠═1b4c0c28-f9ab-11ea-03a6-69f69f7f90ed
# ╟─1f94e0a2-f9ab-11ea-1347-7dd906ebb09d
# ╠═41b2df7c-f931-11ea-112e-ede3b16f357a
# ╟─489fe282-f931-11ea-3dcb-35d4f2ac8b40
# ╟─1dd1e2f4-f930-11ea-312c-5ff9e109c7f6
# ╠═65c92cac-f930-11ea-20b1-6b8f45b3f262
# ╟─671525cc-f930-11ea-0e71-df9d4aae1c05
# ╠═71eb6f22-6afa-11eb-3ed1-55c553f415a0
# ╠═877c36dc-6afa-11eb-1577-fd62528f196b
# ╠═5aa988d0-6afa-11eb-01ad-03abb28bf5a8
# ╟─4582ebf4-f930-11ea-03b2-bf4da1a8f8df
# ╠═7898b76a-f930-11ea-2b7e-8126ec2b8ffd
# ╠═db7a05a2-6afa-11eb-0c0a-bf2bb3911f62
# ╟─a5fbba46-f931-11ea-33e1-054be53d986c
# ╠═458cd100-f930-11ea-24b8-41a49f6596a0
# ╠═bc401bee-f931-11ea-09cc-c5efe2f11194
# ╠═f7ae6e30-6b5d-11eb-2bb7-75fa4af2bfc5
# ╠═fbb2fa9e-6b5d-11eb-0933-7b56a24a99d5
# ╟─ba695f6a-f931-11ea-0fbb-c3ef1374270e
# ╟─45c20988-f930-11ea-1d12-b782d2c01c11
# ╟─cc62929e-f9af-11ea-06b9-439ac08dcb52
# ╟─ae7f0ca2-6b6b-11eb-338d-a73f7f0d5343
# ╟─d3d7bd9c-f9af-11ea-1570-75856615eb5d
# ╟─2f8dedfc-fb98-11ea-23d7-2159bdb6a299
# ╟─b7446f34-f9b1-11ea-0f39-a3c17ba740e5
# ╟─4f97b572-f9b0-11ea-0a99-87af0797bf28
# ╠═46c905d8-f9b0-11ea-36ed-0515e8ed2621
# ╟─4e8d327e-f9b0-11ea-3f16-c178d96d07d9
# ╠═489b03d4-f9b0-11ea-1de0-11d4fe4e7c69
# ╟─d83f8bbc-f9af-11ea-2392-c90e28e96c65
# ╠═fd202410-f936-11ea-1ad6-b3629556b3e0
# ╠═0e465160-f937-11ea-0ebb-b7e02d71e8a8
# ╟─b8c50640-6b7e-11eb-3e0e-29d3bcd553d0
# ╟─885dfc98-6b8b-11eb-2a84-ff28288778f5
# ╠═87a22e16-6b93-11eb-0e40-afcaefa4a3fb
# ╠═a64d719e-6b94-11eb-2f0c-773663fc272e
# ╠═4c819528-6b94-11eb-090b-19b97deb5391
# ╟─b85d2000-6b94-11eb-2a79-d134eeebb5f3
# ╟─508f3efe-6b99-11eb-3e6a-93eacd378c96
# ╟─6718d26c-f9b0-11ea-1f5a-0f22f7ddffe9
# ╟─141af892-f933-11ea-1e5f-154167642809
# ╟─7eed9dde-f931-11ea-38b0-db6bfcc1b558
# ╠═7e3282e2-f931-11ea-272f-d90779264456
# ╟─18ef8776-6c2f-11eb-3081-a96f3478a137
# ╟─518192d0-6c2f-11eb-293b-354131db5680
# ╟─7d1439e6-f931-11ea-2dab-41c66a779262
# ╠═7df55e6c-f931-11ea-33b8-fdc3be0b6cfa
# ╟─292e0384-fb57-11ea-0238-0fbe416fc976
# ╠═7dabee08-f931-11ea-0cb2-c7d5afd21551
# ╟─3736a094-fb57-11ea-1d39-e551aae62b1d
# ╠═a71c5756-6b9a-11eb-0982-bfc4fb39d523
# ╠═b04390f6-6b9a-11eb-0f39-0b4f9db680a7
# ╠═13c89272-f934-11ea-07fe-91b5d56dedf8
# ╠═7d60f056-f931-11ea-39ae-5fa18a955a77
# ╠═df29829a-6b9a-11eb-21eb-5d12ae79614d
# ╟─b09f5512-fb58-11ea-2527-31bea4cee823
# ╠═8c7606f0-fb93-11ea-0c9c-45364892cbb8
# ╟─568f0d3a-fb54-11ea-0f77-171718ef12a5
# ╟─82e0df62-fb54-11ea-3fff-b16c87a7d45b
# ╠═c73eeb28-6b9c-11eb-0f76-b159a7a4a018
# ╠═b7601048-fb57-11ea-0754-97dc4e0623a1
# ╟─0e7c1cf2-6bbd-11eb-1af5-eb91c5b25ca6
# ╠═bb0fa18a-6bbc-11eb-1bfc-8b90a9f89452
# ╠═e22fe214-6bbc-11eb-271d-4fdaffafe02c
# ╟─578a021c-6b9d-11eb-0a5a-7d2133aaf3d9
# ╟─2f652988-6b9d-11eb-080c-1f5a7794b36c
# ╠═cc42de82-fb5a-11ea-3614-25ef961729ab
# ╟─6f9d91dc-6bbd-11eb-1b02-df56016a9a44
# ╠═d66fe2b2-fb5a-11ea-280f-cfb12b8296ac
# ╠═4ca8e04a-fb75-11ea-08cc-2fdef5b31944
# ╟─6f613cd2-fb5b-11ea-1669-cbd355677649
# ╠═91e87974-fb78-11ea-3ce4-5f64e506b9d2
# ╠═9f98e00e-fb78-11ea-0f6c-01206e7221d6
# ╟─813be58c-6bbe-11eb-3364-3fb0874ece6a
# ╠═164c1102-6bbe-11eb-1160-ab715946eb93
# ╠═332c21a2-6bbe-11eb-006f-b1d50f56e91c
# ╠═2c542c14-6bbe-11eb-25aa-41d93ac6d7f3
# ╠═45f22822-6bbe-11eb-0e1f-338dab65ed83
# ╟─bd70bea4-6bbe-11eb-2eb6-2dc8bbe9608a
# ╠═72926be6-6bbe-11eb-0123-0ded9b5b8fe1
# ╠═75964a7e-6bbe-11eb-226f-2b7d8429fc90
# ╟─d7d8cd0c-fb6a-11ea-12bf-2d1448b38162
# ╠═7be98e04-fb6b-11ea-111d-51c48f39a4e9
# ╠═052f822c-fb7b-11ea-382f-af4d6c2b4fdb
# ╠═067f33fc-fb7b-11ea-352e-956c8727c79f
# ╠═114ec026-6bc0-11eb-3d60-2b51098a4401
# ╟─3e85b00e-6bc0-11eb-01bb-25d5ec0d586a
# ╟─954fc466-fb7b-11ea-2724-1f938c6b93c6
# ╟─e467c1c6-fbf2-11ea-0d20-f5798237c0a6
# ╟─95819b20-6bc0-11eb-04d6-4dea0e1ca743
# ╟─7b10f074-fb7c-11ea-20f0-034ddff41bc3
# ╟─24ae5da0-fb7e-11ea-3480-8bb7b649abd5
# ╠═edaed7c0-6c35-11eb-27df-7d8de07855fb
# ╟─47836744-fb7e-11ea-2305-3fa5819dc154
# ╠═df4fc31c-fb81-11ea-37b3-db282b36f5ef
# ╠═c83b1770-fb82-11ea-20a6-3d3a09606c62
# ╟─52970ac4-fb82-11ea-3040-8bd0590348d2
# ╠═e3095812-6c36-11eb-05bf-893697c0e8bf
# ╠═8ce3b312-fb82-11ea-200c-8d5b12f03eea
# ╠═a2214e50-fb83-11ea-3580-210f12d44182
# ╟─a9ffff9a-fb83-11ea-1efd-2fc15538e52f
# ╟─808abf6e-fb84-11ea-0785-2fc3f1c4a09f
# ╠═953363dc-fb84-11ea-1128-ebdfaf5160ee
# ╟─294b6f50-fb84-11ea-1382-03e9ab029a2d
# ╠═c81e5cc4-6c3a-11eb-3e90-239b79413a44
# ╟─fb6224ac-6c3b-11eb-1720-bd3fbc8fbd5c
# ╠═cbff257a-6c3b-11eb-18b8-f3c965d85879
# ╠═b726f824-fb5e-11ea-328e-03a30544037f
# ╠═18355314-fb86-11ea-0738-3544e2e3e816
# ╠═abe2b862-fb69-11ea-08d9-ebd4ba3437d5
# ╟─f685b4d4-6c3c-11eb-1d81-6b960cdf6c10
# ╟─3d105742-fb8d-11ea-09b0-cd2e77efd15c
# ╠═a72fcf5a-fb62-11ea-1dcc-11451d23c085
# ╠═f83991c0-fb7c-11ea-0e6f-1f80709d00c1
# ╠═4b27a89a-fb8d-11ea-010b-671eba69364e
# ╠═c9d3adfc-6c4a-11eb-3673-1f07741874c8
# ╟─d7b7a14a-fb90-11ea-3e2b-2fd8f379b4d8
# ╟─1939dbea-fb63-11ea-0bc2-2d06b2d4b26c
# ╠═70169682-fb8c-11ea-27c0-2dad2ff3080f
# ╠═c0e40282-6c4a-11eb-22aa-0f6ca37207fe
# ╠═b5dff8b8-fb6c-11ea-10fc-37d2a9adae8c
# ╟─402562b0-fb63-11ea-0769-375572cc47a8
# ╠═ee8c5808-fb5f-11ea-19a1-3d58217f34dc
# ╟─2521bac8-fb8f-11ea-04a4-0b077d77529e
# ╠═49b69dc2-fb8f-11ea-39af-030b5c5053c3
# ╟─7f341c4e-fb54-11ea-1919-d5421d7a2c75
# ╟─cc07f576-fbf3-11ea-2c6f-0be63b9356fc
# ╟─6b4d6584-f3be-11ea-131d-e5bdefcc791b
# ╟─54b1e236-fb53-11ea-3769-b382ef8b25d6
# ╟─b7803a28-fb96-11ea-3e30-d98eb322d19a
# ╟─ddef9c94-fb96-11ea-1f17-f173a4ff4d89
# ╟─ffc17f40-f380-11ea-30ee-0fe8563c0eb1
# ╟─ffc40ab2-f380-11ea-2136-63542ff0f386
# ╟─ffceaed6-f380-11ea-3c63-8132d270b83f
# ╟─ffde44ae-f380-11ea-29fb-2dfcc9cda8b4
# ╟─ffe326e0-f380-11ea-3619-61dd0592d409
# ╟─fff5aedc-f380-11ea-2a08-99c230f8fa32
# ╟─00026442-f381-11ea-2b41-bde1fff66011
# ╟─00115b6e-f381-11ea-0bc6-61ca119cb628
