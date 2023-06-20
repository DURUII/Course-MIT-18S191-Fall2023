### A Pluto.jl notebook ###
# v0.19.26

#> [frontmatter]
#> chapter = 2
#> section = 3.5
#> order = 3.5
#> homework_number = 6
#> title = "Probability distributions"
#> layout = "layout.jlhtml"
#> tags = ["homework", "module2", "track_julia", "track_math", "track_data", "structure", "probability", "statistics", "plotting", "interactive"]
#> description = "Calculate a probability distribution from a dataset, experiment with different statistical models, and learn how to plot your results."

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 8c8388cf-9891-423c-8db2-d40d870bb38e
using PlutoUI, Plots

# ╔═╡ eadb174e-2c1d-48c8-9de2-99cdc2b38d32
md"_homework 6, version 5_"

# ╔═╡ 082542fe-f89d-4774-be20-1e1a78f21291
md"""

# **Homework 6**: _Probability distributions_
`18.S191`, Fall 2023

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

Feel free to ask questions!
"""

# ╔═╡ aaa41509-a62d-417b-bca7-a120e3a5e5b2
md"""
#### Initializing packages
_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ 6c6e055a-8c4c-11eb-14a7-6d3036e248b9
md"""

## **Exercise 1:** _Calculating frequencies_

In this exercise we practise using dictionaries in Julia by writing our own version of the `countmap` function. Recall that that function counts the number of times that a given (discrete) value occurs in an input data set.

A suitable data structure for this is a **dictionary**, since it allows us to store data that is very sparse (i.e. for which many input values do not occur).
"""

# ╔═╡ 2bebafd4-8c4d-11eb-14ba-27ab7eb763c1
function counts(data::Vector)
	counts = Dict{Int,Int}()
	
	# your code here
	for item in data
		counts[item] = get(counts, item, 0) + 1
	end
	
	return counts
end

# ╔═╡ d025d432-23d0-4a6b-8b09-cc1114367b8f
counts([7, 8, 9, 7])

# ╔═╡ 17faeb5e-8c4d-11eb-3589-c96e799b8a52
md"""
Test that your code is correct by applying it to obtain the counts of the data vector `test_data` defined below. What should the result be? Test that you do get the correct result and call the result `test_counts`.
"""

# ╔═╡ 5e6f16fc-04a0-4774-8ce0-78953e047269
test_data = [1, 0, 1, 0, 1000, 1, 1, 1000]

# ╔═╡ 49b9e55c-1179-4bee-844e-62ae36d20a5d
test_counts = counts(test_data)

# ╔═╡ 18031e1e-8c4d-11eb-006b-adaf55d54282
md"""
#### Exercise 1.2
The dictionary contains the information as a sequence of **pairs** mapping keys to values. This is not a particularly useful form for us. Instead, we would prefer a vector of the keys and a vector of the values, sorted in order of the key.

We are going to make a new version `counts2` where you do the following (below). Start off by just running the following commands each in their own cell on the dictionary `test_counts` you got by running the previous `counts` function on the vector `test_data` so that you see the result of running each command. Once you have understood what's happening at *each* step, add them to the `counts2` function in a new cell.

👉 Extract vectors `ks` of keys and `vs` of values using the `keys()` and `values()` functions and convert the results into a vector using the `collect` function.
"""

# ╔═╡ 4bbbbd24-d592-4ce3-a619-b7f760672b99
ks = collect(keys(test_counts))

# ╔═╡ 44d0f365-b2a8-41a2-98d3-0aa34e8c80c0
vs = collect(values(test_counts))

# ╔═╡ 18094d52-8c4d-11eb-0620-d30c24a8c75e
md"""
👉 Define a variable `perm` as the result of running the function `sortperm` on the keys. This gives a **permutation** that tells you in which order you need to take the keys to give a sorted version.
"""

# ╔═╡ c825f913-9545-4dbd-96f9-5f7621fc242d
perm = sortperm(ks)

# ╔═╡ 180fc1d2-8c4d-11eb-0362-230d84d47c7f
md"""

👉 Use indexing `ks[perm]` to find the sorted keys and values vectors.  

[Here we are passing in a *vector* as the index. Julia extracts the values at the indices given in that vector]
"""

# ╔═╡ fde456e5-9985-4939-af59-9b9a92313b61
ks[perm]

# ╔═╡ cc6923ff-09e0-44cc-9385-533182c4382d
vs[perm]

# ╔═╡ 18103c98-8c4d-11eb-2bed-ed20aba64ae6
md"""
Verify that your new `counts2` function gives the correct result for the vector `v` by comparing it to the true result (that you get by doing the counting by hand!)
"""

# ╔═╡ bfa216a2-ffa6-4716-a057-62a58fd9f04a
md"""
👉 Create the function `counts2` that performs these steps.
"""

# ╔═╡ 156c1bea-8c4f-11eb-3a7a-793d0a056f80
function counts2(data::Vector)
	c = counts(data)
	ks, vs= collect(keys(c)), collect(values(c))
	perm = sortperm(ks)
	return ks[perm], vs[perm]
end

# ╔═╡ 37294d02-8c4f-11eb-141e-0be49ea07611
counts2(test_data)

# ╔═╡ 18139dc0-8c4d-11eb-0c31-a75361ed7321
md"""
#### Exercise 1.3
👉 Make a function `probability_distribution` that normalizes the result of `counts2` to calculate the relative frequencies of each value, i.e. to give a probability distribution (i.e. such that the sum of the resulting vector is 1).

The function should return the keys (the unique data that was in the original data set, as calculated in `counts2`, and the probabilities (relative frequencies).

Test that it gives the correct result for the vector `vv`.

We will use this function in the rest of the exercises.
"""

# ╔═╡ 447bc642-8c4f-11eb-1d4f-750e883b81fb
function probability_distribution(data::Vector)
	ks, vs = counts2(data)
	return ks, vs ./ sum(vs)
end

# ╔═╡ 6b1dc96a-8c4f-11eb-27ca-ffba02520fec
probability_distribution(test_data)

# ╔═╡ 95145ee9-c826-45e3-ab51-442c8ca70fa3
md"""
## Intermezzo: _**function**_ vs. _**begin**_ vs. _**let**_
$(html"<span id=function_begin_let></span>")

In our lecture materials, we sometimes use a `let` block in this cell to group multiple expressions together, but how is it different from `begin` or `function`?

> ##### function
> Writing functions is a way to group multiple expressions (i.e. lines of code) together into a mini-program. Note the following about functions:
> - A function always returns **one object**.[^1] This object can be given explicitly by writing `return x`, or implicitly: Julia functions always return the result of the last expression by default. So `f(x) = x+2` is the same as `f(x) = return x+2`.
> - Variables defined inside a function are _not accessible outside the function_. We say that function bodies have a **local scope**. This helps to keep your program easy to read and write: if you define a local variable, then you don't need to worry about it in the rest of the notebook.
> 
> There are two other ways to group expressions together that you might have seen before: `begin` and `let`.

> ##### begin
> **`begin`** will group expressions together, and it takes the value of its last subexpression. 
>     
> We use it in this notebook when we want multiple expressions to always run together.

> ##### let
> **`let`** also groups multiple expressions together into one, but variables defined inside of it are **local**: they don't affect code outside of the block. So like `begin`, it is just a block of code, but like `function`, it has a local variable scope.
> 
> We use it when we want to define some local (temporary) variables to produce a complicated result, without interfering with other cells. Pluto allows only one definition per _global_ variable of the same name, but you can define _local_ variables with the same names whenever you wish!

[^1]: Even a function like 
    
    `f(x) = return`
    
    returns **one object**: the object `nothing` — try it out!
"""

# ╔═╡ c5464196-8ef7-418d-b1aa-fafc3a03c68c
md"""
### Example of a scope problem with `begin`

The following will not work, because `fruits` has multiple definitions:
"""

# ╔═╡ 409ed7e5-a3b8-4d37-b85d-e5cb4c1e1708
md"""
### Solved using `let`
"""

# ╔═╡ 36de9792-1870-4c78-8330-83f273ee1b46
let
	vegetables = ["🥦", "🥔", "🥬"]
	length(vegetables)
end

# ╔═╡ 8041603b-ae47-4569-af1d-cebb00edb32a
let
	vegetables = ["🌽"]
	length(vegetables)
end

# ╔═╡ 2d56bf20-8866-4ec1-9ceb-41004aa185d0


# ╔═╡ 2577c5a7-338f-4aef-b34b-456949cfc17b
md"""
This works, because `vegetables` is only defined as a _local variable inside the cell_, not as a global:
"""

# ╔═╡ d12229f4-d950-4983-84a4-304a7637ac7b
vegetables

# ╔═╡ a8241562-8c4c-11eb-2a85-d7502e7fb2cf
md"""
## **Exercise 2:** _Modelling component failure with the geometric distribution_

In this exercise, we will investigate the simple model of failure of mechanical components (or light bulbs, or radioactive decay, or recovery from an infection, or...) that we saw in lectures. 
Let's call $\tau$ the time to failure.

We will use a  simple model, in which each component has probability $p$ to fail each day. If it fails on day $n$, then $\tau = n$.
We see that $\tau$ is a random variable, so we need to study its **probability distribution**.

"""

# ╔═╡ fdb394a0-8c4f-11eb-0585-bb8c28f952cb
md"""
#### Exercise 2.1

👉 Define the function `bernoulli(p)` from lectures. Recall that this generates `true` with probability $p$ and `false` with probability $(1 - p)$.
"""

# ╔═╡ 0233835a-8c50-11eb-01e7-7f80bd27683e
bernoulli(p::Real) = rand() < p

# ╔═╡ fdb3f1c8-8c4f-11eb-2281-bf01205bb804
md"""
#### Exercise 2.2

👉 Write a function `geometric(p)`. This should run a simulation with probability $p$ to recover and wait *until* the individual recovers, at which point it returns the time taken to recover. The resulting failure time is known as a **geometric random variable**, or a random variable whose distribution is the **geometric distribution**.
"""

# ╔═╡ 08028df8-8c50-11eb-3b22-fdf5104a4d52
function geometric(p::Real)
	if p == 0
		throw(ArgumentError("Make sure not to run the code with p = 0!"))
	end
	
	agent = 1
	
	while(!bernoulli(p))
		agent += 1
	end
	
	return agent
end

# ╔═╡ 2b35dc1c-8c50-11eb-3517-83589f2aa8cc
geometric(0.25)

# ╔═╡ e125bd7f-1881-4cff-810f-8af86850249d
md"""
We should always be aware of special cases (sometimes called "boundary conditions"). Make sure *not* to run the code with $p=0$! What would happen in that case? Your code should check for this and throw an `ArgumentError` as follows:

```julia
throw(ArgumentError("..."))  
```

with a suitable error message.
    
"""

# ╔═╡ 6cb36508-836a-4191-b615-45681a1f7443
md"""
👉 What happens for $p=1$? 
"""

# ╔═╡ 370ec1dc-8688-443c-bf57-dd1b2a42a5fa
interpretation_of_p_equals_one = md"""
`bernoulli` function always returns TRUE, so the component fails right after the first day.
"""

# ╔═╡ fdb46c72-8c4f-11eb-17a2-8b7628b5d3b3
md"""
#### Exercise 2.3
👉 Write a function `experiment(p, N)` that runs the `geometric` function `N` times and collects the results into a vector.
"""

# ╔═╡ 32700660-8c50-11eb-2fdf-5d9401c07de3
function experiment(p::Real, N::Integer)
	
	return [geometric(p) for i in 1:N]
end

# ╔═╡ 192caf02-5234-4379-ad74-a95f3f249a72
small_experiment = experiment(0.5, 20)

# ╔═╡ fdc1a9f2-8c4f-11eb-1c1e-5f92987b79c7
md"""
#### Exercise 2.4
Let's run an experiment with $p=0.25$ and $N=10,000$. We will plot the resulting probability distribution, i.e. plot $P(\tau = n)$ against $n$, where $n$ is the recovery time.
"""

# ╔═╡ 3cd78d94-8c50-11eb-2dcc-4d0478096274
large_experiment = experiment(0.25, 10000)

# ╔═╡ 4118ef38-8c50-11eb-3433-bf3df54671f0
let
	xs, ps = probability_distribution(large_experiment)
	p = bar(xs, ps, alpha=0.5, label="monte-carlo")	
end

# ╔═╡ c4ca3940-9bd5-4fa6-8c73-8675ef7d5f41
md"""
👉 Calculate the mean recovery time. 


"""

# ╔═╡ 25ae71d0-e6e2-45ff-8900-3caf6fcea937
mean = sum(large_experiment)/length(large_experiment)

# ╔═╡ 3a7c7ca2-e879-422e-a681-d7edd271c018
md"""
👉 Create the same plot as above, and add the mean recovery time to the plot using the `vline!()` function and the `ls=:dash` argument to make a dashed line.

Note that `vline!` requires a *vector* of values where you wish to draw vertical lines.
"""

# ╔═╡ 97d7d154-8c50-11eb-2fdd-fdf0a4e402d3
let
	xs, ps = probability_distribution(large_experiment)
	p = bar(xs, ps, alpha=0.5, label="monte-carlo")	
	vline!(p, xs, [mean for _ in xs], ls=:dash, label="mean")
end

# ╔═╡ b1287960-8c50-11eb-20c3-b95a2a1b8de5
md"""
$(html"<span id=note_about_plotting></span>")
> ### Note about plotting
> 
> Plots.jl has an interesting property: a plot is an object, not an action. Functions like `plot`, `bar`, `histogram` don't draw anything on your screen - they just return a `Plots.Plot`. This is a struct that contains the _description_ of a plot (what data should be plotted in what way?), not the _picture_.
> 
> So a Pluto cell with a single line, `plot(1:10)`, will show a plot, because the _result_ of the function `plot` is a `Plot` object, and Pluto just shows the result of a cell.
>
> ##### Modifying plots
> Nice plots are often formed by overlaying multiple plots. In Plots.jl, this is done using the **modifying functions**: `plot!`, `bar!`, `vline!`, etc. These take an extra (first) argument: a previous plot to modify.
> 
> For example, to plot the `sin`, `cos` and `tan` functions in the same view, we do:
> ```julia
> function sin_cos_plot()
>     T = -1.0:0.01:1.0
>     
>     result = plot(T, sin.(T))
>     plot!(result, T, cos.(T))
>     plot!(result, T, tan.(T))
>
>     return result
> end
> ```
> 
> 💡 This example demonstrates a useful pattern to combine plots:
> 1. Create a **new** plot and store it in a variable
> 2. **Modify** that plot to add more elements
> 3. Return the plot
> 
> ##### Grouping expressions
> It is highly recommended that these 3 steps happen **within a single cell**. This can prevent some strange glitches when re-running cells. There are three ways to group expressions together into a single cell: `begin`, `let` and `function`. More on this [here](#function_begin_let)!
"""

# ╔═╡ fdcab8f6-8c4f-11eb-27c6-3bdaa3fcf505
md"""
#### Exercise 2.5
👉 What shape does the distribution seem to have? Can you verify that by using one or more log scales in a new plot?
"""

# ╔═╡ 1b1f870f-ee4d-497f-8d4b-1dba737be075
let
	xs, ps = probability_distribution(large_experiment)
	result = bar(xs, ps, alpha=0.5, label="monte-carlo")	
end

# ╔═╡ fdcb1c1a-8c4f-11eb-0aeb-3fae27eaacbd
md"""
Use the widgets from PlutoUI to write an interactive visualization that performs Exercise 2.3 for $p$ varying between $0$ and $1$ and $N$ between $0$ and $100,000$.

You might want to go back to Exercise 2.3 to turn your code into a _function_ that can be called again.

As you vary $p$, what do you observe? Does that make sense?
"""

# ╔═╡ d5b29c53-baff-4529-b2c1-776afe000d38
@bind p Slider(0.05:0.05:1, show_value=true)

# ╔═╡ 9a92eba4-ad68-4c53-a242-734718aeb3f1
@bind N Slider(0:100:1e6, show_value=true)

# ╔═╡ 48751015-c374-4a77-8a00-bca81bbc8305
iexperiment = experiment(p, Int64(round(N)))

# ╔═╡ 562202be-5eac-46a4-9542-e6593bc39ff9
let
	xs, ps = probability_distribution(iexperiment)
	result = bar(xs, ps, alpha=0.5, label="monte-carlo")	

	mean = sum(iexperiment)/length(iexperiment)
	vline!(result, xs, [mean for _ in xs], ls=:dash, label="mean")
end

# ╔═╡ fdd5d98e-8c4f-11eb-32bc-51bc1db98930
md"""
#### Exercise 2.6
👉 For fixed $N = 10,000$, write a function that calculates the *mean* time to recover, $\langle \tau(p) \rangle$, as a function of $p$.
"""

# ╔═╡ 406c9bfa-409d-437c-9b86-fd02fdbeb88f
function τ(p)
	iexperiment = experiment(p, 100000)
	return sum(iexperiment)/length(iexperiment)
end

# ╔═╡ f8b982a7-7246-4ede-89c8-b2cf183470e9
md"""
👉 Use plots of your function to find the relationship between $\langle \tau(p) \rangle$ and $p$.
"""

# ╔═╡ caafed37-0b3b-4f6c-919f-f16df7248c23
let
	# computational thinking
	pp, τs = 0.001:0.001:0.999, [τ(i) for i in 0.001:0.001:0.999]
	plot(pp, τs, markershape=:auto, linewidth=2, label = "monte-carlo τ(p)")
	xlabel!("p")
	ylabel!("τ")

	# mathematical thinking
	# σ(p) = log(0.5*(-p*(log(1-p)-2)+log(1-p))/p)/log(1-p)
	# xx, yy = 0.001:0.001:0.999, [σ(i) for i in 0.001:0.001:0.999]
	# plot!(xx, yy, markershape=:auto, linewidth=2, label = "theoretical τ(p)")

	xlims!(0, 0.1)
end

# ╔═╡ d2e4185e-8c51-11eb-3c31-637902456634
md"""
Based on my observations, it looks like we have the following relationship:

```math
\langle \tau(p) \rangle = x ^ {-p}(not \ quite)
```
"""

# ╔═╡ a82728c4-8c4c-11eb-31b8-8bc5fcd8afb7
md"""

## **Exercise 3:** _More efficient geometric distributions_

Let's use the notation $P_n := \mathbb{P}(\tau = n)$ for the probability to fail on the $n$th step.

Probability theory tells us that in the limit of an infinite number of trials, we have the following exact results: $P_1 = p$;  $P_2 = p (1-p)$, and in general $P_n = p (1 - p)^{n-1}$.
	"""

# ╔═╡ 23a1b76b-7393-4a4c-b6a5-40fb15dadd29
md"""
#### Exercise 3.1

👉 Fix $p = 0.25$. Make a vector of the values $P_n$ for $n=1, \dots, 50$. You must (of course!) use a loop or similar construction; do *not* do this by hand!
"""

# ╔═╡ 45735d82-8c52-11eb-3735-6ff9782dde1f
Ps = let 
	# your code here
	p = 0.25
	[p * (1 - p) ^ (n - 1) for n in 1:50]
end

# ╔═╡ dd80b2eb-e4c3-4b2f-ad5c-526a241ac5e6
md"""
👉 Do they sum to 1?

"""

# ╔═╡ 3df70c76-1aa6-4a0c-8edf-a6e3079e406b
sum(Ps)

# ╔═╡ b1ef5e8e-8c52-11eb-0d95-f7fa123ee3c9
md"""
#### Exercise 3.2
👉 Check analytically that the probabilities sum to 1 when you include *all* (infinitely many) of them.
"""

# ╔═╡ a3f08480-4b2b-46f2-af4a-14270869e766
md"""

```math
\sum_{k=1}^{\infty} P_k = p \sum_{k=1}^{\infty} (1-p)^{k-1} = p \lim_{k \to \infty} \frac{1 - (1-p)^{k}}{1 - (1 - p)} = p * \frac{1}{p} = 1

```
"""

# ╔═╡ 1b6035fb-d8fc-437f-b75e-f1a6b3b4cae7
md"""
#### Exercise 3.3: Sum of a geometric series
"""

# ╔═╡ c3cb9ea0-5e0e-4d5a-ab23-80ed8d91209c
md"""
👉 Plot $P_n$ as a function of $n$. Compare it to the corresponding result from the previous exercise (i.e. plot them both on the same graph).
	"""

# ╔═╡ dd59f48c-bb22-47b2-8acf-9c4ee4457cb9
let
	xs, ps = probability_distribution(iexperiment)
	bar(xs, ps, alpha=0.5, label="monte-carlo")	

	xx, pp = 1:length(ps), [(1 - p) ^ (i - 1) * p for i in 1:length(ps)]
	plot!(xx, pp, markershape=:auto, label="theoretical")

	mean = sum(iexperiment)/length(iexperiment)
	vline!(xs, [mean for _ in xs], ls=:dash, label="mean")
end

# ╔═╡ 5907dc0a-de60-4b58-ac4b-1e415f0051d2
md"""
👉   How could we measure the *error*, i.e. the distance between the two graphs? What do you think determines it?
	"""

# ╔═╡ c7093f08-52d2-4f22-9391-23bd196c6fb9
let
	xs, ps = probability_distribution(iexperiment)
	xx, pp = 1:length(ps), [(1 - p) ^ (i - 1) * p for i in 1:length(ps)]
	bar(xx, ps - pp, alpha=0.5, label="error")	
end

# ╔═╡ 316f369a-c051-4a35-9c64-449b12599295
md"""
#### Exercise 3.4
If $p$ is *small*, say $p=0.001$, then the algorithm we used in Exercise 2 to sample from geometric distribution will be very slow, since it just sits there calculating a lot of `false`s! (The average amount of time taken is what you found in [1.8].)
"""

# ╔═╡ 9240f9dc-aa34-4e7b-8b82-86ea1376f527
md"""
   Let's make a better algorithm. Think of each probability $P_n$ as a "bin", or interval, of length $P_n$. If we lay those bins next to each other starting from $P_1$ on the left, then $P_2$, etc., there will be an *infinite* number of bins that fill up the interval between $0$ and $1$. (In principle there is no upper limit on how many days it will take to recover, although the probability becomes *very* small.)
"""

# ╔═╡ d24ddb61-3d65-4bea-ad8f-d5a3ac44a563
md"""
   Now suppose we take a uniform random number $r$ between $0$ and $1$. That will fall into one of the bins. If it falls into the bin corresponding to $P_n$, then we return $n$ as the recovery time!
"""

# ╔═╡ 430e0975-8eb6-420c-a18e-f3493182c5c7
md"""
👉 To draw this picture, we need to add up the lengths of the lines from 1 to $n$ for each $n$, i.e. calculate the **cumulative sum**. Write a function `cumulative_sum`, which returns a new vector.
"""

# ╔═╡ 5185c938-8c53-11eb-132d-83342e0c775f
function cumulative_sum(xs::Vector)
	sum = xs
	
	for i in 2:length(sum)
		sum[i] = sum[i-1] + xs[i]
	end

	return sum
end

# ╔═╡ e4095d34-552e-495d-b318-9afe6839d577
cumulative_sum([1, 3, 5, 7, 9])

# ╔═╡ fa5843e8-8c52-11eb-2138-dd57b8bf25f7
md"""
👉 Plot the resulting values on a horizontal line. Generate a few random points and plot those. Convince yourself that the probability that a point hits a bin is equal to the length of that bin.
"""

# ╔═╡ 7aa0ec08-8c53-11eb-1935-23237a448399
cumulative = cumulative_sum(Ps)

# ╔═╡ e649c914-dd28-4194-9393-4dc8836f3743
let 
	xs, ps = cumulative, [0 for _ in 1:length(cumulative)]
	plot(xs, ps, markershape=:circle)
	ylims!(-0.1, 0.1)

	rx, ry = [], []
	for i in 1:100
		push!(rx, rand(1:cumulative[end]))
		push!(ry, rand(-0.1:0.0001:0.1))
	end
	scatter!(rx, ry, markershape=:circle)
end

# ╔═╡ fa59099a-8c52-11eb-37a7-291f80ea0406
md"""
#### Exercise 3.5
👉 Calculate the sum of $P_1$ up to $P_n$ analytically.
"""

# ╔═╡ 1ae91530-c77e-4d92-9ad3-c969bc7e1fa8
md"""
```math
C_n := \sum_{k=1}^n P_k = p \sum_{k=1}^{n} (1-p)^{n-1} = p * \frac{1 - (1-p)^{n}}{1 - (1 - p)} = 1 - (1-p)^n
```
"""

# ╔═╡ fa599248-8c52-11eb-147a-99b5fb75d131
md"""
👉 Use the previous result to find (analytically) which bin $n$ a given value of $r \in [0, 1]$ falls into, using the inequality $P_{n+1} \le r \le P_n$.


	
"""

# ╔═╡ 16b4e98c-4ae7-4145-addf-f43a0a96ec82
md"""

```math
P_{n+1} \le r \le P_n
```

```math
(1-p)^n \le 1 - r \le (1-p)^{n+1}
```

```math
n log_e (1-p) \le log_e (1 - r) \le (n+1) log_e (1-p)
```

```math
n \le \frac{log_e (1 - r)}{log_e (1-p)} \le n+1
```

```math
\frac{log_e (1 - r)}{log_e (1-p)} - 1 \le n \le \frac{log_e (1 - r)}{log_e (1-p)}
```

```math
n(r,p) = \left \lceil \frac{log_e (1 - r)}{log_e (1-p)} - 1  \right \rceil
```

"""

# ╔═╡ fa671c06-8c52-11eb-20e0-85e2abb4ecc7
md"""
#### Exercise 3.6

👉 Implement this as a function `geomtric_bin(r, p)`, use the `floor` function.
"""

# ╔═╡ 47d56992-8c54-11eb-302a-eb3153978d26
function geometric_bin(r::Real, p::Real)
	
	return floor(log(1-r)/log(1-p))
end

# ╔═╡ adfb343d-beb8-4576-9f2a-d53404cee42b
md"""
We can use this to define a **fast** version of the `geomtric` function:
"""

# ╔═╡ 5b7f2a91-a4f0-49f7-b8cf-6f677104d3e1
geometric_fast(p) = geometric_bin(rand(), p)

# ╔═╡ b3b11113-2f0c-45d2-a14e-011a61ae8e9b
geometric_fast(0.25)

# ╔═╡ fc681dde-8c52-11eb-07fa-7d0ef9f22e93
md"""
#### Exercise 3.7
👉 Generate `10_000` samples from `geometric_fast` with $p=10^{-10}$ and plot a histogram of them. This would have taken a very long time with the previous method!
"""

# ╔═╡ 24937bf7-9687-4ef5-8aa5-0a9e520f49b4
let
	histogram([geometric_fast(10e-10) for _ in 1:10_000])
end

# ╔═╡ 79eb5e14-8c54-11eb-3c8c-dfeba16305b2
md"""
## **Exercise 4:** _Distribution of the "atmosphere"_

In this question we will implement a (very!) simple model of the density of the atmosphere, using a **random walk**, i.e. a particle that undergoes random *motion*. (We will see more about random walks in lectures.)

We can think of a very light dust particle being moved around by the wind. We are only interested in its vertical position, $y$, and we will suppose for simplicity that $y$ is an integer. The particle jumps up and down randomly as it is moved by the wind; however, due to gravity it has a higher probability $p$ of moving downwards (to $y-1$) than upwards (to $y+1$), which happens with probability $1-p$.

At $y = 1$ there is a **boundary condition**: it hits a reflective boundary (the "surface of the Earth"). We can model this using "bounce-back": if the particle tries to jump downwards from $y=1$ then it hits a reflective boundary and bounces back to $y=1$. (In other words it remains in the same place.)

"""

# ╔═╡ 8c9c217e-8c54-11eb-07f1-c5fde6aa2946
md"""
#### Exercise 4.1
👉 Write a simulation of this model in a function `atmosphere` that accepts `p`, the initial height `y0`, and the number of steps $N$ as variables.

"""

# ╔═╡ 2270e6ba-8c5e-11eb-3600-615519daa5e0
function atmosphere(p::Real, y0::Real, N::Integer)

	result = []
	
	for i in 1:N
		if bernoulli(p)
		    if y0 > 1
				y0 = y0 - 1
			end
		else
			y0 = y0 + 1
		end

		push!(result, y0)
	end
	
	return result
	
end

# ╔═╡ 225bbcbd-0628-4151-954e-9a85d1020fd9
histogram(atmosphere(0.8, 10, 50))

# ╔═╡ 1dc5daa6-8c5e-11eb-1355-b1f627d04a18
md"""
Let's simulate it for $10^7$ time steps with $x_0 = 10$ and $p=0.55$. 

#### Exercise 4.2

👉 Calculate and plot the probability distribution of the walker's height.
"""

# ╔═╡ deb5fbfb-1e03-42ce-a6d6-c8d3edd89a9a
let 
	histogram(atmosphere(0.8, 10, 100_000_000))
	xlims!(0, 5)
end

# ╔═╡ 1dc68e2e-8c5e-11eb-3486-454d58ac9c87
md"""
👉 What does the resulting figure look like? What form do you think this distribution has? Verify your hypothesis by plotting the distribution using different scales. You can increase the number of time steps to make the results look nicer.
"""

# ╔═╡ bb8f69fd-c704-41ca-9328-6622d390f71f
let 
	histogram(atmosphere(0.8, 1, 10_000_000))
	xlims!(0, 5)
end

# ╔═╡ 44f18e84-7623-4a62-ad3f-30bdde17759b
let 
	histogram(atmosphere(0.8, 100, 10_000_000))
	xlims!(0, 5)
end

# ╔═╡ 1dc7389c-8c5e-11eb-123a-7f59dc6504cf
md"""
#### Exercise 4.3

👉 Make an interactive visualization of how the distribution develops over time. What happens for longer and longer times?

"""

# ╔═╡ d3bec73d-0106-496d-93ae-e1e26534b8c7
@bind T Slider(1:1:100_000, show_value=true)

# ╔═╡ d972be1f-a8ad-43ed-a90d-bca358d812c2
histogram(atmosphere(0.8, 10, T))

# ╔═╡ de83ffd6-cd0c-4b78-afe4-c0bcc54471d7
md"""
👉 Use wikipedia to find a formula for the barometric pressure at a given altitude. Does this result match your expectations?
"""

# ╔═╡ fe45b8de-eb3f-43ca-9d63-5c01d0d27671
md"""
![](https://upload.wikimedia.org/wikipedia/commons/8/88/Atmospheric_Pressure_vs._Altitude.png)
"""

# ╔═╡ 5aabbec1-a079-4936-9cd1-9c25fe5700e6
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 42d6b87d-b4c3-4ccb-aceb-d1b020135f47
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 17fa9e2e-8c4d-11eb-334c-ad3704b43e95
md"""

#### Exercise 1.1
👉 Write a function `counts` that accepts a vector `data` and calculates the number of times each value in `data` occurs.

The input will be an array of integers, **with duplicates**, and the result will be a dictionary that maps each occurred value to its count in the data.

For example,
```julia
counts([7, 8, 9, 7])
```
should give
```julia
Dict(
	7 => 2, 
	8 => 1, 
	9 => 1,
)
```

To do so, use a **dictionary** called `counts`. [We can create a local variable with the same name as the function.]

$(hint(md"Do you remember how we worked with dictionaries in Homework 3? You can create an empty dictionary using `Dict()`. You may want to use either the function `haskey` or the function `get` on your dictionary -- check the documentation for how to use these functions.
"))

The function should return the dictionary.
"""

# ╔═╡ 7077a0b6-4539-4246-af2d-ab990c34e810
hint(md"Remember to always re-use work you have done previously: in this case you should re-use the function `bernoulli`.")

# ╔═╡ 8fd9e34c-8f20-4979-8f8a-e3e2ae7d6c65
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ d375c52d-2126-4594-b819-aba9d34fe77f
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ 2d7565d4-88da-4e41-aad6-958ed6b3b2e0
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ d7f45d51-f426-4353-af58-858395295ce0
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next question."]

# ╔═╡ 9b2aa95d-4583-40ec-893c-9fc751ea22a1
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 5dca2bb3-24e6-49ae-a6fc-d3912da4f82a
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 645ace88-b8e6-4957-ad6e-49fd82b08fe5
if !@isdefined(counts)
	not_defined(:counts)
else
	let
		result = counts([51,-52,-52,53,51])

		if ismissing(result)
			still_missing()
		elseif !(result isa Dict)
			keep_working(md"Make sure that `counts` returns a Dictionary.")
		elseif result == Dict(
				51 => 2,
				-52 => 2,
				53 => 1,
			)
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ 6a302ce6-a327-449e-b41a-859d502f4df7
if !@isdefined(test_counts)
	not_defined(:test_counts)
else
	if test_counts != Dict(
			0 => 2,
			1000 => 2,
			1 => 4
			)
		
		keep_working()
	else
		correct()
	end
end

# ╔═╡ 2b6a64b9-779b-47d1-9724-ad066f14fbff
if !@isdefined(counts2)
	not_defined(:counts2)
else
	let
		result = counts2([51,-52,-52,53,51])

		if ismissing(result)
			still_missing()
		elseif !(result isa Tuple{<:AbstractVector,<:AbstractVector})
			keep_working(md"Make sure that `counts2` returns a Tuple of two vectors.")
		elseif result == (
				[-52, 51, 53],
				[2, 2, 1],
			)
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ 26bf2a9c-f42e-4c97-83d2-b9d637a2e8ae
if !@isdefined(probability_distribution)
	not_defined(:probability_distribution)
else
	let
		result = probability_distribution([51,-52,-52,53,51])

		if ismissing(result)
			still_missing()
		elseif !(result isa Tuple{<:AbstractVector,<:AbstractVector})
			keep_working(md"Make sure that `counts2` returns a Tuple of two vectors.")
		elseif result[1] == [-52, 51, 53] &&
				isapprox(result[2], [2, 2, 1] ./ 5)
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ 3ea51057-4438-4d4a-b964-630e87a82ce5
if !@isdefined(bernoulli)
	not_defined(:bernoulli)
else
	let
		result = bernoulli(0.5)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Bool)
			keep_working(md"Make sure that you return either `true` or `false`.")
		else
			if bernoulli(0.0) == false && bernoulli(1.0) == true
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ fccff967-e44f-4f89-8995-d822783301c3
if !@isdefined(geometric)
	not_defined(:geometric)
else
	let
		result = geometric(1.0)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Int)
			keep_working(md"Make sure that you return an integer: the recovery time.")
		else
			if result == 1
				samples = [geometric(0.2) for _ in 1:256]
				
				a, b = extrema(samples)
				if a == 1 && b > 20
					correct()
				else
					keep_working()
				end
			else
				keep_working(md"`p = 1.0` should return `1`: the agent recovers after the first time step.")
			end
		end
	end
end

# ╔═╡ 0210b558-80ae-4a15-92c1-60b0fd7924f3
if !@isdefined(cumulative_sum)
	not_defined(:cumulative_sum)
else
	let
		result = cumulative_sum([1,2,3,4])
		if result isa Missing
			still_missing()
		elseif !(result isa AbstractVector)
			keep_working(md"Make sure that you return an Array: the cumulative sum!")
		elseif length(result) != 4
			keep_working(md"You should return an array of the same size a `xs`.")
		else
			if isapprox(result, [1, 3, 6, 10])
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ a81516e8-0099-414e-9f2c-ab438764348e
if !@isdefined(geometric_bin)
	not_defined(:geometric_bin)
else
	let
		result1 = geometric_bin(0.1, 0.1)
		result2 = geometric_bin(0.9, 0.1)
		
		if result1 isa Missing
			still_missing()
		elseif !(result1 isa Real)
			keep_working(md"Make sure that you return a number.")
		elseif all(isinteger, [result1, result2])
			if result1 == 21 || result2 == 21 ||  result1 == 22 || result2 == 22

				correct()
			else
				keep_working()
			end
		else
			keep_working(md"You should use the `floor` function to return an integer.")
		end
	end
end

# ╔═╡ ddf2a828-7823-4fc0-b944-72b60b391247
todo(text) = HTML("""<div
	style="background: rgb(220, 200, 255); padding: 2em; border-radius: 1em;"
	><h1>TODO</h1>$(repr(MIME"text/html"(), text))</div>""")

# ╔═╡ a7feaaa4-618b-4afe-8050-4bf7cc609c17
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 4ce0e43d-63d6-4cb2-88b8-8ba80e17012a
bigbreak

# ╔═╡ 6f55a612-8c4f-11eb-0f6b-755442c4ed3d
bigbreak

# ╔═╡ 51801da7-38da-4628-8a7a-119358e60086
bigbreak

# ╔═╡ 43966251-c8db-4999-bc4f-0f1fc34e0264
bigbreak

# ╔═╡ 06412687-b44d-4a69-8d6c-0cf4eb51dfad
bigbreak

# ╔═╡ 2962c6da-feda-4d65-918b-d3b178a18fa0
begin
	fruits = ["🍒", "🍐", "🍋"]
	length(fruits)
end

# ╔═╡ 887a5106-c44a-4437-8c6f-04ad6610738a
begin
	fruits = ["🍉"]
	length(fruits)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Plots = "~1.38.16"
PlutoUI = "~0.7.51"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.1"
manifest_format = "2.0"
project_hash = "5534ede614eb302e3406fc5b7d596581a54741ec"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "be6ab11021cd29f0344d5c4357b163af05a48cba"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.21.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "7a60c856b9fa189eb34f5f8a6f6b5529b7942957"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "96d823b94ba8d187a6d8f0826e731195a74b90e9"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "738fec4d684a9a6ee9598a8bfee305b26831f28c"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.2"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "8b8a2fd4536ece6e554168c21860b6820a8a83db"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.7"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "19fad9cd9ae44847fe842558a744748084a722d1"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.7+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "5e77dbf117412d4f164a464d610ee6050cc75272"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.9.6"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "c3ce8e7420b3a6e071e0fe4745f5d4300e37b13f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.24"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1aa4b74f80b01c6bc2b89992b861b5f210e665b5"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.21+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "d321bf2de576bf25ec4d3e4360faca399afca282"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "5a6ab2f64388fd1175effdf73fe5933ef1e0bac0"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.0"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "75ca67b2c6512ad2d0c767a7cfc55e75075f8bbc"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.16"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "b478a748be27bd2f2c73a7690da219d0844db305"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.51"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "45a7769a04a3cf80da1c1c7c60caf932e6f4c9f7"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.6.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "75ebe04c5bed70b91614d684259b661c9e6274a4"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "ba4aa36b2d5c98d6ed1f149da916b3ba46527b2b"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.14.0"

    [deps.Unitful.extensions]
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─eadb174e-2c1d-48c8-9de2-99cdc2b38d32
# ╟─082542fe-f89d-4774-be20-1e1a78f21291
# ╟─aaa41509-a62d-417b-bca7-a120e3a5e5b2
# ╠═8c8388cf-9891-423c-8db2-d40d870bb38e
# ╟─4ce0e43d-63d6-4cb2-88b8-8ba80e17012a
# ╟─6c6e055a-8c4c-11eb-14a7-6d3036e248b9
# ╟─17fa9e2e-8c4d-11eb-334c-ad3704b43e95
# ╠═2bebafd4-8c4d-11eb-14ba-27ab7eb763c1
# ╠═d025d432-23d0-4a6b-8b09-cc1114367b8f
# ╟─17faeb5e-8c4d-11eb-3589-c96e799b8a52
# ╠═5e6f16fc-04a0-4774-8ce0-78953e047269
# ╠═49b9e55c-1179-4bee-844e-62ae36d20a5d
# ╟─645ace88-b8e6-4957-ad6e-49fd82b08fe5
# ╟─6a302ce6-a327-449e-b41a-859d502f4df7
# ╟─18031e1e-8c4d-11eb-006b-adaf55d54282
# ╠═4bbbbd24-d592-4ce3-a619-b7f760672b99
# ╠═44d0f365-b2a8-41a2-98d3-0aa34e8c80c0
# ╟─18094d52-8c4d-11eb-0620-d30c24a8c75e
# ╠═c825f913-9545-4dbd-96f9-5f7621fc242d
# ╟─180fc1d2-8c4d-11eb-0362-230d84d47c7f
# ╠═fde456e5-9985-4939-af59-9b9a92313b61
# ╠═cc6923ff-09e0-44cc-9385-533182c4382d
# ╟─18103c98-8c4d-11eb-2bed-ed20aba64ae6
# ╟─bfa216a2-ffa6-4716-a057-62a58fd9f04a
# ╠═156c1bea-8c4f-11eb-3a7a-793d0a056f80
# ╠═37294d02-8c4f-11eb-141e-0be49ea07611
# ╟─2b6a64b9-779b-47d1-9724-ad066f14fbff
# ╟─18139dc0-8c4d-11eb-0c31-a75361ed7321
# ╠═447bc642-8c4f-11eb-1d4f-750e883b81fb
# ╠═6b1dc96a-8c4f-11eb-27ca-ffba02520fec
# ╟─26bf2a9c-f42e-4c97-83d2-b9d637a2e8ae
# ╟─6f55a612-8c4f-11eb-0f6b-755442c4ed3d
# ╟─95145ee9-c826-45e3-ab51-442c8ca70fa3
# ╟─51801da7-38da-4628-8a7a-119358e60086
# ╟─c5464196-8ef7-418d-b1aa-fafc3a03c68c
# ╠═2962c6da-feda-4d65-918b-d3b178a18fa0
# ╠═887a5106-c44a-4437-8c6f-04ad6610738a
# ╟─409ed7e5-a3b8-4d37-b85d-e5cb4c1e1708
# ╠═36de9792-1870-4c78-8330-83f273ee1b46
# ╠═8041603b-ae47-4569-af1d-cebb00edb32a
# ╟─2d56bf20-8866-4ec1-9ceb-41004aa185d0
# ╟─2577c5a7-338f-4aef-b34b-456949cfc17b
# ╠═d12229f4-d950-4983-84a4-304a7637ac7b
# ╟─43966251-c8db-4999-bc4f-0f1fc34e0264
# ╟─a8241562-8c4c-11eb-2a85-d7502e7fb2cf
# ╟─fdb394a0-8c4f-11eb-0585-bb8c28f952cb
# ╠═0233835a-8c50-11eb-01e7-7f80bd27683e
# ╟─3ea51057-4438-4d4a-b964-630e87a82ce5
# ╟─fdb3f1c8-8c4f-11eb-2281-bf01205bb804
# ╠═08028df8-8c50-11eb-3b22-fdf5104a4d52
# ╠═2b35dc1c-8c50-11eb-3517-83589f2aa8cc
# ╟─7077a0b6-4539-4246-af2d-ab990c34e810
# ╟─e125bd7f-1881-4cff-810f-8af86850249d
# ╟─fccff967-e44f-4f89-8995-d822783301c3
# ╟─6cb36508-836a-4191-b615-45681a1f7443
# ╠═370ec1dc-8688-443c-bf57-dd1b2a42a5fa
# ╟─fdb46c72-8c4f-11eb-17a2-8b7628b5d3b3
# ╠═32700660-8c50-11eb-2fdf-5d9401c07de3
# ╠═192caf02-5234-4379-ad74-a95f3f249a72
# ╟─fdc1a9f2-8c4f-11eb-1c1e-5f92987b79c7
# ╠═3cd78d94-8c50-11eb-2dcc-4d0478096274
# ╠═4118ef38-8c50-11eb-3433-bf3df54671f0
# ╟─c4ca3940-9bd5-4fa6-8c73-8675ef7d5f41
# ╠═25ae71d0-e6e2-45ff-8900-3caf6fcea937
# ╟─3a7c7ca2-e879-422e-a681-d7edd271c018
# ╠═97d7d154-8c50-11eb-2fdd-fdf0a4e402d3
# ╟─b1287960-8c50-11eb-20c3-b95a2a1b8de5
# ╟─fdcab8f6-8c4f-11eb-27c6-3bdaa3fcf505
# ╠═1b1f870f-ee4d-497f-8d4b-1dba737be075
# ╟─fdcb1c1a-8c4f-11eb-0aeb-3fae27eaacbd
# ╠═d5b29c53-baff-4529-b2c1-776afe000d38
# ╠═9a92eba4-ad68-4c53-a242-734718aeb3f1
# ╠═48751015-c374-4a77-8a00-bca81bbc8305
# ╠═562202be-5eac-46a4-9542-e6593bc39ff9
# ╟─fdd5d98e-8c4f-11eb-32bc-51bc1db98930
# ╠═406c9bfa-409d-437c-9b86-fd02fdbeb88f
# ╟─f8b982a7-7246-4ede-89c8-b2cf183470e9
# ╠═caafed37-0b3b-4f6c-919f-f16df7248c23
# ╠═d2e4185e-8c51-11eb-3c31-637902456634
# ╟─06412687-b44d-4a69-8d6c-0cf4eb51dfad
# ╟─a82728c4-8c4c-11eb-31b8-8bc5fcd8afb7
# ╟─23a1b76b-7393-4a4c-b6a5-40fb15dadd29
# ╠═45735d82-8c52-11eb-3735-6ff9782dde1f
# ╟─dd80b2eb-e4c3-4b2f-ad5c-526a241ac5e6
# ╠═3df70c76-1aa6-4a0c-8edf-a6e3079e406b
# ╟─b1ef5e8e-8c52-11eb-0d95-f7fa123ee3c9
# ╠═a3f08480-4b2b-46f2-af4a-14270869e766
# ╟─1b6035fb-d8fc-437f-b75e-f1a6b3b4cae7
# ╟─c3cb9ea0-5e0e-4d5a-ab23-80ed8d91209c
# ╠═dd59f48c-bb22-47b2-8acf-9c4ee4457cb9
# ╟─5907dc0a-de60-4b58-ac4b-1e415f0051d2
# ╠═c7093f08-52d2-4f22-9391-23bd196c6fb9
# ╟─316f369a-c051-4a35-9c64-449b12599295
# ╟─9240f9dc-aa34-4e7b-8b82-86ea1376f527
# ╟─d24ddb61-3d65-4bea-ad8f-d5a3ac44a563
# ╟─430e0975-8eb6-420c-a18e-f3493182c5c7
# ╠═5185c938-8c53-11eb-132d-83342e0c775f
# ╠═e4095d34-552e-495d-b318-9afe6839d577
# ╟─0210b558-80ae-4a15-92c1-60b0fd7924f3
# ╟─fa5843e8-8c52-11eb-2138-dd57b8bf25f7
# ╠═7aa0ec08-8c53-11eb-1935-23237a448399
# ╠═e649c914-dd28-4194-9393-4dc8836f3743
# ╟─fa59099a-8c52-11eb-37a7-291f80ea0406
# ╠═1ae91530-c77e-4d92-9ad3-c969bc7e1fa8
# ╠═fa599248-8c52-11eb-147a-99b5fb75d131
# ╠═16b4e98c-4ae7-4145-addf-f43a0a96ec82
# ╟─fa671c06-8c52-11eb-20e0-85e2abb4ecc7
# ╠═47d56992-8c54-11eb-302a-eb3153978d26
# ╟─a81516e8-0099-414e-9f2c-ab438764348e
# ╟─adfb343d-beb8-4576-9f2a-d53404cee42b
# ╠═5b7f2a91-a4f0-49f7-b8cf-6f677104d3e1
# ╠═b3b11113-2f0c-45d2-a14e-011a61ae8e9b
# ╟─fc681dde-8c52-11eb-07fa-7d0ef9f22e93
# ╠═24937bf7-9687-4ef5-8aa5-0a9e520f49b4
# ╟─79eb5e14-8c54-11eb-3c8c-dfeba16305b2
# ╟─8c9c217e-8c54-11eb-07f1-c5fde6aa2946
# ╠═2270e6ba-8c5e-11eb-3600-615519daa5e0
# ╠═225bbcbd-0628-4151-954e-9a85d1020fd9
# ╟─1dc5daa6-8c5e-11eb-1355-b1f627d04a18
# ╠═deb5fbfb-1e03-42ce-a6d6-c8d3edd89a9a
# ╟─1dc68e2e-8c5e-11eb-3486-454d58ac9c87
# ╠═bb8f69fd-c704-41ca-9328-6622d390f71f
# ╠═44f18e84-7623-4a62-ad3f-30bdde17759b
# ╟─1dc7389c-8c5e-11eb-123a-7f59dc6504cf
# ╠═d3bec73d-0106-496d-93ae-e1e26534b8c7
# ╠═d972be1f-a8ad-43ed-a90d-bca358d812c2
# ╟─de83ffd6-cd0c-4b78-afe4-c0bcc54471d7
# ╠═fe45b8de-eb3f-43ca-9d63-5c01d0d27671
# ╟─5aabbec1-a079-4936-9cd1-9c25fe5700e6
# ╟─42d6b87d-b4c3-4ccb-aceb-d1b020135f47
# ╟─8fd9e34c-8f20-4979-8f8a-e3e2ae7d6c65
# ╟─d375c52d-2126-4594-b819-aba9d34fe77f
# ╟─2d7565d4-88da-4e41-aad6-958ed6b3b2e0
# ╟─d7f45d51-f426-4353-af58-858395295ce0
# ╟─9b2aa95d-4583-40ec-893c-9fc751ea22a1
# ╟─5dca2bb3-24e6-49ae-a6fc-d3912da4f82a
# ╟─ddf2a828-7823-4fc0-b944-72b60b391247
# ╟─a7feaaa4-618b-4afe-8050-4bf7cc609c17
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
