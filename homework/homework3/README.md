

### Build-in functions
```bash
count(
  pattern::Union{AbstractString,Regex},
  string::AbstractString;
  overlap::Bool = false,
)
```



### User-defined functions
```julia
function rand_sample(frequencies)
  x = rand()  # x ∈ [0,1)
  #= 
  Actually, if sum(frequencies) == 1, then the step
    frequencies ./ sum(frequencies)
  is redundant.
  =#
  findfirst(z -> z >= x, cumsum(frequencies ./ sum(frequencies)))
end



index_of_letter(letter) = findfirst(isequal(letter), alphabet)

function transition_counts(cleaned_sample)
  [count(string(a, b), cleaned_sample)
    for a in alphabet,
      b in alphabet]
end

normalize_array(x) = x ./ sum(x)

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


function bigrams(words)
  map(1:length(words)-1) do i
    words[i:i+1]
  end
end

function ngrams(words, n)
  map(1:length(words)-(n-1)) do i
    words[i:i+(n-1)]
  end
end


```
