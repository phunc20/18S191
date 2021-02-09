

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
index_of_letter(letter) = findfirst(isequal(letter), alphabet)

function transition_counts(cleaned_sample)
	[count(string(a, b), cleaned_sample)
		for a in alphabet,
			b in alphabet]
end

normalize_array(x) = x ./ sum(x)

```
