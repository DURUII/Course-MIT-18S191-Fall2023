### A Pluto.jl notebook ###
# v0.19.26

#> [frontmatter]
#> chapter = 1
#> section = 9.5
#> order = 9.5
#> homework_number = 4
#> title = "Dynamic programming"
#> layout = "layout.jlhtml"
#> tags = ["homework", "module1", "track_julia", "track_math", "structure", "programming", "dynamic programming", "matrix", "recursion"]
#> description = ""

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

# ╔═╡ a4937996-f314-11ea-2ff9-615c888afaa8
begin
    using Images, ImageIO, FileIO, TestImages, ImageFiltering
	using Statistics
	using PlutoUI
	using BenchmarkTools
end

# ╔═╡ 0f271e1d-ae16-4eeb-a8a8-37951c70ba31
all_image_urls = [
	"https://wisetoast.com/wp-content/uploads/2015/10/The-Persistence-of-Memory-salvador-deli-painting.jpg" => "Salvador Dali — The Persistence of Memory (replica)",
	"https://i.imgur.com/4SRnmkj.png" => "Frida Kahlo — The Bride Frightened at Seeing Life Opened",
	"https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan_No._1_%2813947%29.jpg/477px-Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan_No._1_%2813947%29.jpg" => "Hilma Klint - The Swan No. 1",
	"https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Piet_Mondriaan%2C_1930_-_Mondrian_Composition_II_in_Red%2C_Blue%2C_and_Yellow.jpg/300px-Piet_Mondriaan%2C_1930_-_Mondrian_Composition_II_in_Red%2C_Blue%2C_and_Yellow.jpg" => "Piet Mondriaan - Composition with Red, Blue and Yellow",
	"https://user-images.githubusercontent.com/6933510/110993432-950df980-8377-11eb-82e7-b7ce4a0d04bc.png" => "Mario",
]

# ╔═╡ 5370bf57-1341-4926-b012-ba58780217b1
removal_test_image = Gray.(rand(4,4))

# ╔═╡ 6c7e4b54-f318-11ea-2055-d9f9c0199341
begin
	brightness(c::RGB) = mean((c.r, c.g, c.b))
	brightness(c::RGBA) = mean((c.r, c.g, c.b))
	brightness(c::Gray) = gray(c)
end

# ╔═╡ d184e9cc-f318-11ea-1a1e-994ab1330c1a
convolve(img, k) = imfilter(img, reflect(k)) # uses ImageFiltering.jl package
# behaves the same way as the `convolve` function used in our lectures and homeworks

# ╔═╡ cdfb3508-f319-11ea-1486-c5c58a0b9177
float_to_color(x) = RGB(max(0, -x), max(0, x), 0)

# ╔═╡ e9402079-713e-4cfd-9b23-279bd1d540f6
energy(∇x, ∇y) = sqrt.(∇x.^2 .+ ∇y.^2)

# ╔═╡ 6f37b34c-f31a-11ea-2909-4f2079bf66ec
function energy(img)
	∇y = convolve(brightness.(img), Kernel.sobel()[1])
	∇x = convolve(brightness.(img), Kernel.sobel()[2])
	energy(∇x, ∇y)
end

# ╔═╡ f5a74dfc-f388-11ea-2577-b543d31576c6
html"""
<iframe width="100%" height="450px" src="https://www.youtube.com/embed/rpB6zQNsbQU?start=777&end=833" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ 2f9cbea8-f3a1-11ea-20c6-01fd1464a592
random_seam(m, n, i) = reduce((a, b) -> [a..., clamp(last(a) + rand(-1:1), 1, n)], 1:m-1; init=[i])

# ╔═╡ a4d14606-7e58-4770-8532-66b875c97b70
grant_example = [
	1 8 8 3 5 4
	7 8 1 0 8 4
	8 0 4 7 2 9
	9 0 0 5 9 4
	2 4 0 2 4 5
	2 4 2 5 3 0
] ./ 10

# ╔═╡ 38f70c35-2609-4599-879d-e032cd7dc49d
Gray.(grant_example)

# ╔═╡ 2a98f268-f3b6-11ea-1eea-81c28256a19e
function fib(n)
    # base case (basis)
	if n == 0 || n == 1      # `||` means "or"
		return 1
	end

    # recursion (induction)
	return fib(n-1) + fib(n-2)
end

# ╔═╡ 1add9afd-5ff5-451d-ad81-57b0e929dfe8
grant_example

# ╔═╡ 8b8da8e7-d3b5-410e-b100-5538826c0fde
grant_example_optimal_seam = [4, 3, 2, 2, 3, 3]

# ╔═╡ 281b950f-2331-4666-9e45-8fd117813f45
(
	sum(grant_example[i, grant_example_optimal_seam[i]] for i in 1:6),
	grant_example_optimal_seam[2]
)

# ╔═╡ cbf29020-f3ba-11ea-2cb0-b92836f3d04b
begin
	struct AccessTrackerArray{T,N} <: AbstractArray{T,N}
		data::Array{T,N}
		accesses::Ref{Int}
	end
	
	Base.IndexStyle(::Type{AccessTrackerArray}) = IndexLinear()
	
	Base.size(x::AccessTrackerArray) = size(x.data)
	Base.getindex(x::AccessTrackerArray, i::Int...) = (x.accesses[] += 1; x.data[i...])
	Base.setindex!(x::AccessTrackerArray, v, i...) = (x.accesses[] += 1; x.data[i...] = v;)
	
	
	track_access(x) = AccessTrackerArray(x, Ref(0))
	function track_access(f::Function, x::Array)
		tracked = track_access(x)
		f(tracked)
		tracked.accesses[]
	end
end

# ╔═╡ e6b6760a-f37f-11ea-3ae1-65443ef5a81a
md"_homework 4, version 5_"

# ╔═╡ 85cfbd10-f384-11ea-31dc-b5693630a4c5
md"""

# **Homework 4**: _Dynamic programming_
`18.S191`, Fall 2023

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

Feel free to ask questions!
"""

# ╔═╡ 938185ec-f384-11ea-21dc-b56b7469f798
md"""
#### Initializing packages
_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ 6dabe5e2-c851-4a2e-8b07-aded451d8058
md"""
### Choose your image

 $(@bind image_url Select(all_image_urls))

Maximum image size: $(@bind max_height_str Select(string.([500, 200, 100, 50]))) pixels. _(Using a large image might lead to long runtimes in the later exercises.)_
"""

# ╔═╡ 0d144802-f319-11ea-0028-cd97a776a3d0
img_original = load(download(image_url));

# ╔═╡ a5271c38-ba45-416b-94a4-ba608c25b897
max_height = parse(Int, max_height_str)

# ╔═╡ 365349c7-458b-4a6d-b067-5112cb3d091f
"Decimate an image such that its new height is at most `height`."
function decimate_to_height(img, height)
	factor = max(1, 1 + size(img, 1) ÷ height)
	img[1:factor:end, 1:factor:end]
end

# ╔═╡ ab276048-f34b-42dd-b6bf-0b83c6d99e6a
img = decimate_to_height(img_original, max_height)

# ╔═╡ 74059d04-f319-11ea-29b4-85f5f8f5c610
Gray.(brightness.(img))

# ╔═╡ b49e8cc8-f381-11ea-1056-91668ac6ae4e
md"""
## Cutting a seam

Below is a function called `remove_in_each_row(img, pixels)`. It takes a matrix `img` and a vector of integers, `pixels`, and shrinks the image by 1 pixel in width by removing the element `img[i, pixels[i]]` in every row. This function is one of the building blocks of the Image Seam algorithm we saw in the lecture.

Read it and convince yourself that it is correct.
"""

# ╔═╡ 90a22cc6-f327-11ea-1484-7fda90283797
function remove_in_each_row(img::Matrix, column_numbers::Vector)
	m, n = size(img)
	@assert m == length(column_numbers) # same as the number of rows

	local img′ = similar(img, m, n-1) # create a similar image with one column less

	for (i, j) in enumerate(column_numbers)
		img′[i, 1:j-1] .= @view img[i, 1:(j-1)]
		img′[i, j:end] .= @view img[i, (j+1):end]
	end
	img′
end

# ╔═╡ 52425e53-0583-45ab-b82b-ffba77d444c8
let
	seam = [1,2,3,4]
	remove_in_each_row(removal_test_image, seam)
end

# ╔═╡ 268546b2-c4d5-4aa5-a57f-275c7da1450c
let
	seam = [1,1,1,1]
	remove_in_each_row(removal_test_image, seam)
end

# ╔═╡ 2f945ca3-e7c5-4b14-b618-1f9da019cffd
let
	seam = [1,1,1,1]
	result1 = remove_in_each_row(removal_test_image, seam)
	result2 = remove_in_each_row(result1, seam)
	result2
end

# ╔═╡ c075a8e6-f382-11ea-2263-cd9507324f4f
md"Let's use our function to remove the _diagonal_ from our image. Take a close look at the images to verify that we removed the diagonal. "

# ╔═╡ a09aa706-6e35-4536-a16b-494b972e2c03
md"""
Removing the seam `[1,1,1,1]` is equivalent to removing the first column:
"""

# ╔═╡ 6aeb2d1c-8585-4397-a05f-0b1e91baaf67
md"""
If we remove the same seam twice, we remove the first two rows:
"""

# ╔═╡ 318a2256-f369-11ea-23a9-2f74c566549b
md"""
## _Brightness and Energy_
"""

# ╔═╡ 7a44ba52-f318-11ea-0406-4731c80c1007
md"""
First, we will define a `brightness` function for a pixel (a color) as the mean of the red, green and blue values.

You should use this function whenever the problem set asks you to deal with _brightness_ of a pixel.
"""

# ╔═╡ 0b9ead92-f318-11ea-3744-37150d649d43
md"""We provide you with a convolve function below.
"""

# ╔═╡ 5fccc7cc-f369-11ea-3b9e-2f0eca7f0f0e
md"""
finally we define the `energy` function which takes the Sobel gradients along x and y directions and computes the norm of the gradient for each pixel.
"""

# ╔═╡ 87afabf8-f317-11ea-3cb3-29dced8e265a
md"""
## **Exercise 1** - _Building up to dynamic programming_

In this exercise and the following ones, we will use the computational problem of Seam carving. We will think through all the "gut reaction" solutions, and then finally end up with the dynamic programming solution that we saw in the lecture.

In the process we will understand the performance and accuracy of each iteration of our solution.

### How to implement the solutions:

For every variation of the algorithm, your job is to write a function which takes a matrix of energies, and an index for a pixel on the first row, and computes a "seam" starting at that pixel.

The function should return a vector of as many integers as there are rows in the input matrix where each number points out a pixel to delete from the corresponding row. (it acts as the input to `remove_in_each_row`).
"""

# ╔═╡ 8ba9f5fc-f31b-11ea-00fe-79ecece09c25
md"""
#### Exercise 1.1 - _The greedy approach_

The first approach discussed in the lecture (included below) is the _greedy approach_: you start from your top pixel, and at each step you just look at the three neighbors below. The next pixel in the seam is the neighbor with the lowest energy.

"""

# ╔═╡ c3543ea4-f393-11ea-39c8-37747f113b96
md"""
👉 Implement the greedy approach.
"""

# ╔═╡ abf20aa0-f31b-11ea-2548-9bea4fab4c37
function greedy_seam(energies, starting_pixel::Int)
	m, n = size(energies)
	# you can delete the body of this function - it's just a placeholder.
	result = [starting_pixel]
	for row in 2:m
		last_col = result[length(result)]
		boss_val, boss_col = typemax(Float64), 0
		for col in max(last_col - 1, 1):min(last_col + 1, n)
			if energies[row, col] < boss_val
				boss_val = energies[row, col]
				boss_col = col
			end
		end
		push!(result, boss_col)
	end
	return result
end

# ╔═╡ 5430d772-f397-11ea-2ed8-03ee06d02a22
md"Before we apply your function to our test image, let's try it out on a small matrix of energies (displayed here in grayscale), just like in the lecture snippet above (clicking on the video will take you to the right part of the video). Light pixels have high energy, dark pixels signify low energy."

# ╔═╡ 6f52c1a2-f395-11ea-0c8a-138a77f03803
md"Starting pixel: $(@bind greedy_starting_pixel Slider(1:size(grant_example, 2); show_value=true, default=5))"

# ╔═╡ 5057652e-2f88-40f1-82f0-55b1b5bca6f6
greedy_seam_result = greedy_seam(grant_example, greedy_starting_pixel)

# ╔═╡ 2643b00d-2bac-4868-a832-5fb8ad7f173f
let
	s = sum(grant_example[i,j] for (i, j) in enumerate(greedy_seam_result))
	md"""
	**Total energy:** $(round(s,digits=1))
	"""
end

# ╔═╡ 9945ae78-f395-11ea-1d78-cf6ad19606c8
md"_Let's try it on the bigger image!_"

# ╔═╡ 87efe4c2-f38d-11ea-39cc-bdfa11298317
begin
	# reactive references to uncheck the checkbox when the functions are updated
	greedy_seam, img, grant_example
	
	md"Compute shrunk image: $(@bind shrink_greedy CheckBox())"
end

# ╔═╡ 52452d26-f36c-11ea-01a6-313114b4445d
md"""
#### Exercise 1.2 - _Recursion_

A common pattern in algorithm design is the idea of solving a problem as the combination of solutions to subproblems.

The classic example, is a [Fibonacci number](https://en.wikipedia.org/wiki/Fibonacci_number) generator.

The recursive implementation of Fibonacci looks something like this
"""

# ╔═╡ 32e9a944-f3b6-11ea-0e82-1dff6c2eef8d
md"""
Notice that you can call a function from within itself which may call itself and so on until a base case is reached. Then the program will combine the result from the base case up to the final result.

In the case of the Fibonacci function, we added the solutions to the subproblems `fib(n-1)`, `fib(n-2)` to produce `fib(n)`.

An analogy can be drawn to the process of mathematical induction in mathematics. And as with mathematical induction there are parts to constructing such a recursive algorithm:

- Defining a base case
- Defining an recursion i.e. finding a solution to the problem as a combination of solutions to smaller problems.

"""

# ╔═╡ 9101d5a0-f371-11ea-1c04-f3f43b96ca4a
md"""
👉 Define a `least_energy` function which returns:
1. the lowest possible total energy for a seam starting at the pixel at $(i, j)$;
2. the column to jump to on the next move (in row $i + 1$),
which is one of $j-1$, $j$ or $j+1$, up to boundary conditions.

Return these two values in a tuple.
"""

# ╔═╡ 8ec27ef8-f320-11ea-2573-c97b7b908cb7
## returns lowest possible sum energy at pixel (i, j), and the column to jump to in row i+1.
function least_energy(energies, i, j)
	m, n = size(energies)
	
	## base case
	# if i == something
	#    return (energies[...], ...) # no need for recursive computation in the base case!
	# end

	if i == m
		return (energies[i, j], -1)
	end
	
	## induction
	# combine results from recursive calls to `least_energy`.

	boss_val , boss_jump = typemax(Float64), -1
	for dir in -1:1
		if 1<=j+dir<=n
			val = energies[i, j] + least_energy(energies, i+1, j+dir)[1]
			if val < boss_val
				boss_val = val
				boss_jump = j+dir
			end
		end
	end

	return (boss_val, boss_jump)
	
end

# ╔═╡ ad524df7-29e2-4f0d-ad72-8ecdd57e4f02
least_energy(grant_example, 1, 4)

# ╔═╡ 447e54f8-d3db-4970-84ee-0708ab8a9244
md"""
#### Expected output
As shown in the lecture, the optimal seam from the point (1,4) should be:
"""

# ╔═╡ e1074d35-58c4-43c0-a6cb-1413ed194e25
md"""
So we expect the output of `least_energy(grant_example, 1, 4)` to be:
"""

# ╔═╡ a7f3d9f8-f3bb-11ea-0c1a-55bbb8408f09
md"""
This is elegant and correct, but inefficient! Let's look at the number of accesses made to the energies array needed to compute the least energy seam of a 10x10 image:
"""

# ╔═╡ fa8e2772-f3b6-11ea-30f7-699717693164
track_access(rand(10,10)) do tracked
	least_energy(tracked, 1, 5)
end

# ╔═╡ 18e0fd8a-f3bc-11ea-0713-fbf74d5fa41a
md"Whoa! We will need to optimize this later!"

# ╔═╡ 8bc930f0-f372-11ea-06cb-79ced2834720
md"""
#### Exercise 1.3 - _Exhaustive search with recursion_

Now use the `least_energy` function you defined above to define the `recursive_seam` function which takes the energies matrix and a starting pixel, and computes the seam with the lowest energy from that starting pixel.

This will give you the method used in the lecture to perform [exhaustive search of all possible paths](https://youtu.be/rpB6zQNsbQU?t=839).
"""

# ╔═╡ 85033040-f372-11ea-2c31-bb3147de3c0d
function recursive_seam(energies, starting_pixel)
	m, n = size(energies)
	# Replace the following line with your code.
	result = [starting_pixel]
	for i in 1:m-1
		j = result[length(result)]
		push!(result, least_energy(energies, i, j)[2])
	end
	return result
end

# ╔═╡ f92ac3e4-fa70-4bcf-bc50-a36792a8baaa
md"""
We won't use this function to shrink our larger image, because it is too inefficient. (Your notebook might get stuck!) But let's try it on the small example matrix from the lecture, to verify that we have found the optimal seam.
"""

# ╔═╡ 7ac5eb8d-9dba-4700-8f3a-1e0b2addc740
recursive_seam_test = recursive_seam(grant_example, 4)

# ╔═╡ c572f6ce-f372-11ea-3c9a-e3a21384edca
md"""
#### Exercise 1.4

- State clearly why this algorithm does an exhaustive search of all possible paths.
- How does the number of possible seam grow as n increases for a `m×n` image? (Big O notation is fine, or an approximation is fine).
"""

# ╔═╡ 6d993a5c-f373-11ea-0dde-c94e3bbd1552
exhaustive_observation = md"""
1. every possible path is visited. 
2. every pixel(considered as a node in a tree) would lead to at most 3 childs(2 sometimes), so that would be approximately $n \times m$, and there should be m-1 loops; while in each loop, so, to sum up, it should be $O(m^2 \times n)$ without memoization.
"""

# ╔═╡ ea417c2a-f373-11ea-3bb0-b1b5754f2fac
md"""
## **Exercise 2** - _Memoization_

**Memoization** is the name given to the technique of storing results to expensive function calls that will be accessed more than once.

As stated in the video, the function `least_energy` is called repeatedly with the same arguments. In fact, we call it on the order of $3^n$ times, when there are only really $m \times n$ unique ways to call it!

Lets implement memoization on this function with first a [dictionary](https://docs.julialang.org/en/v1/base/collections/#Dictionaries) for storage.
"""

# ╔═╡ 56a7f954-f374-11ea-0391-f79b75195f4d
md"""
#### Exercise 2.1 - _Dictionary as storage_

Let's make a memoized version of least_energy function which takes a dictionary and
first checks to see if the dictionary contains the key (i,j) if it does, returns the value stored in that place, if not, will compute it, and store it in the dictionary at key (i, j) and return the value it computed.


`memoized_least_energy(energies, starting_pixel, memory)`

This function must recursively call itself, and pass the same `memory` object it received as an argument.

You are expected to read and understand the [documentation on dictionaries](https://docs.julialang.org/en/v1/base/collections/#Dictionaries) to find out how to:

1. Create a dictionary
2. Check if a key is stored in the dictionary
3. Access contents of the dictionary by a key.
"""

# ╔═╡ f853967a-fea4-4943-aab5-d481cc5a013b
a=Dict()

# ╔═╡ 63026eb5-1fa1-423e-8d23-a4a9c8a71cc3
a[(1, 2)]=(3)

# ╔═╡ b1d09bc8-f320-11ea-26bb-0101c9a204e2
function memoized_least_energy(energies, i, j, memory::Dict)
	m, n = size(energies)
	
	# you should start by copying the code from 
	# your (not-memoized) least_energies function.

	if haskey(memory, (i, j))
		return memory[(i, j)]
	end

	if i == m
		memory[(i, j)] = (energies[i, j], -1)
		return memory[(i, j)]
	end

	boss_val , boss_jump = typemax(Float64), -1
	for dir in -1:1
		if 1<=j+dir<=n
			val = energies[i, j] + memoized_least_energy(energies, i+1, j+dir, memory)[1]
			if val < boss_val
				boss_val = val
				boss_jump = j+dir
			end
		end
	end
	memory[(i, j)] = (boss_val, boss_jump)
	return memory[(i, j)]
	
end

# ╔═╡ 1947f304-fa2c-4019-8584-01ef44ef2859
memoized_least_energy_test = memoized_least_energy(grant_example, 1, 4, Dict())

# ╔═╡ 8992172e-c5b6-463e-a06e-5fe42fb9b16b
md"""
Let's see how many matrix access we have now:
"""

# ╔═╡ ced5a7b5-24eb-43b7-841e-16c80d300e2e
track_access(rand(10,10)) do tracked
	least_energy(tracked, 1, 5)
end

# ╔═╡ b387f8e8-dced-473a-9434-5334829ecfd1
track_access(rand(10,10)) do tracked
	memoized_least_energy(tracked, 1, 5, Dict())
end

# ╔═╡ 3e8b0868-f3bd-11ea-0c15-011bbd6ac051
function memoized_recursive_seam(energies, starting_pixel)
	# we set up the the _memory_: note the key type (Tuple{Int,Int}) and
	# the value type (Tuple{Float64,Int}). 
	# If you need to memoize something else, you can just use Dict() without types.
	memory = Dict{Tuple{Int,Int},Tuple{Float64,Int}}()
	
	m, n = size(energies)
	
	# you should start by copying the code from 
	# your (not-memoized) recursive_seam function.
	result = [starting_pixel]
	for i in 1:m-1
		j = result[length(result)]
		memoized_least_energy(energies, i, j, memory)
		push!(result, memory[(i, j)][2])
	end
	return result
end

# ╔═╡ d941c199-ed77-47dd-8b5a-e34b864f9a79
memoized_recursive_seam(grant_example, 4)

# ╔═╡ 726280f0-682f-4b05-bf5a-688554a96287
grant_example_optimal_seam

# ╔═╡ cf39fa2a-f374-11ea-0680-55817de1b837
md"""
### Exercise 2.2 - _Matrix as storage_ (optional)

The dictionary-based memoization we tried above works well in general as there is no restriction on what type of keys can be used.

But in our particular case, we can use a matrix as a storage, since a matrix is naturally keyed by two integers.

👉 Write a variant of `matrix_memoized_least_energy` and `matrix_memoized_seam` which use a matrix as storage. 
"""

# ╔═╡ c8724b5e-f3bd-11ea-0034-b92af21ca12d
function matrix_memoized_least_energy(energies, i, j, memory::Matrix)
	m, n = size(energies)
	
	# Replace the following line with your code.

	if memory[i, j] != nothing
		return memory[i, j]
	end

	if i == m
		memory[i, j] = (energies[i, j], -1)
		return memory[i, j]
	end

	boss_val , boss_jump = typemax(Float64), -1
	for dir in -1:1
		if 1<=j+dir<=n
			
			val = energies[i, j] + matrix_memoized_least_energy(
				energies, i+1, j+dir, memory
			)[1]
			
			if val < boss_val
				boss_val = val
				boss_jump = j+dir
			end
		end
	end
	
	memory[i, j] = (boss_val, boss_jump)
	return memory[i, j]
	
end

# ╔═╡ be7d40e2-f320-11ea-1b56-dff2a0a16e8d
function matrix_memoized_seam(energies, starting_pixel)
	memory = Matrix{Union{Nothing,Tuple{Float64,Int}}}(nothing, size(energies))

	# use me instead of you use a different element type:
	# memory = Matrix{Any}(nothing, size(energies))
	m, n = size(energies)
	
	# Replace the following line with your code.
	result = [starting_pixel]
	for i in 1:m-1
		j = result[length(result)]
		matrix_memoized_least_energy(energies, i, j, memory)
		push!(result, memory[i, j][2])
	end
	return result
end

# ╔═╡ 8cd3112d-c986-4f91-8dcb-e38b3830d3f9
matrix_memoized_seam(grant_example, 4) == grant_example_optimal_seam

# ╔═╡ 507f3870-f3c5-11ea-11f6-ada3bb087634
begin
	matrix_memoized_seam, img
	
	md"Compute shrunk image: $(@bind shrink_matrix CheckBox())"
end

# ╔═╡ 24792456-f37b-11ea-07b2-4f4c8caea633
md"""
## **Exercise 3** - _Dynamic programming without recursion_ 

Now it's easy to see that the above algorithm is equivalent to one that populates the memory matrix in a for loop.

#### Exercise 3.1

👉 Write a function which takes the energies and returns the least energy matrix which has the least possible seam energy for each pixel. This was shown in the lecture, but attempt to write it on your own.
"""

# ╔═╡ ff055726-f320-11ea-32f6-2bf38d7dd310
function least_energy_matrix(energies)
	m, n = size(energies)
	result = fill(typemax(Float64), size(energies))
	result[m, :] = energies[m, :]
	
	# your code here
	for i=m-1:-1:1, j=1:n, k=j-1:j+1
		if 1<=k<=n
			result[i, j]=min(result[i, j], result[i+1, k]+energies[i, j])
		end
	end
	return result
end

# ╔═╡ 00c71421-1113-451c-b123-e1de3d70302f
le_test_example = least_energy_matrix(grant_example)

# ╔═╡ d3e69cf6-61b1-42fc-9abd-42d1ae7d61b2
img_brightness = brightness.(img);

# ╔═╡ 3bc23fef-a860-437b-8c84-4f6ec55e77e6
le_test = least_energy_matrix(img_brightness)

# ╔═╡ e06d4e4a-146c-4dbd-b742-317f638a3bd8
spooky(A::Matrix{<:Real}) = map(sqrt.(A ./ maximum(A))) do x
	RGB(.8x, x, .8x)
end

# ╔═╡ 7f861036-4707-4161-8dbd-b2320292168a
spooky(le_test)

# ╔═╡ 92e19f22-f37b-11ea-25f7-e321337e375e
md"""
#### Exercise 3.2

👉 Write a function which, when given the matrix returned by `least_energy_matrix` and a starting pixel (on the first row), computes the least energy seam from that pixel.
"""

# ╔═╡ 795eb2c4-f37b-11ea-01e1-1dbac3c80c13
function seam_from_precomputed_least_energy(energies, starting_pixel::Int)
	least_energies = least_energy_matrix(energies)
	m, n = size(least_energies)
	
	# Replace the following line with your code.
	result = [starting_pixel]
	for i in 1:m-1
		j = result[length(result)]

		boss_val, boss_jump = typemax(Float64), -1
		
		for k in j-1:j+1
			if 1<=k<=n && least_energies[i+1, k] < boss_val
				boss_val = least_energies[i+1, k]
				boss_jump = k
			end
		end
		
		push!(result, boss_jump)
		
	end
	
	return result
	
end

# ╔═╡ 51df0c98-f3c5-11ea-25b8-af41dc182bac
begin
	img, seam_from_precomputed_least_energy
	md"Compute shrunk image: $(@bind shrink_bottomup CheckBox())"
end

# ╔═╡ 6b4d6584-f3be-11ea-131d-e5bdefcc791b
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ ef88c388-f388-11ea-3828-ff4db4d1874e
function mark_path(img, path)
	img′ = RGB.(img) # also makes a copy
	m = size(img, 2)
	for (i, j) in enumerate(path)
		if size(img, 2) > 50
			# To make it easier to see, we'll color not just
			# the pixels of the seam, but also those adjacent to it
			for j′ in j-1:j+1
				img′[i, clamp(j′, 1, m)] = RGB(1,0,1)
			end
		else
			img′[i, j] = RGB(1,0,1)
		end
	end
	img′
end

# ╔═╡ 437ba6ce-f37d-11ea-1010-5f6a6e282f9b
function shrink_n(min_seam::Function, img::Matrix{<:Colorant}, n, imgs=[];
		show_lightning=true,
	)
	
	n==0 && return push!(imgs, img)

	e = energy(img)
	seam_energy(seam) = sum(e[i, seam[i]]  for i in 1:size(img, 1))
	_, min_j = findmin(map(j->seam_energy(min_seam(e, j)), 1:size(e, 2)))
	min_seam_vec = min_seam(e, min_j)
	img′ = remove_in_each_row(img, min_seam_vec)
	if show_lightning
		push!(imgs, mark_path(img, min_seam_vec))
	else
		push!(imgs, img′)
	end
	shrink_n(min_seam, img′, n-1, imgs; show_lightning=show_lightning)
end

# ╔═╡ f6571d86-f388-11ea-0390-05592acb9195
if shrink_greedy
	local n = min(200, size(img, 2))
	greedy_carved = shrink_n(greedy_seam, img, n)
	md"Shrink by: $(@bind greedy_n Slider(1:n; show_value=true))"
end

# ╔═╡ f626b222-f388-11ea-0d94-1736759b5f52
if shrink_greedy
	greedy_carved[greedy_n]
end

# ╔═╡ 4e3bcf88-f3c5-11ea-3ada-2ff9213647b7
begin
	# reactive references to uncheck the checkbox when the functions are updated
	img, memoized_recursive_seam, shrink_n
	
	md"Compute shrunk image: $(@bind shrink_dict CheckBox())"
end

# ╔═╡ 4e3ef866-f3c5-11ea-3fb0-27d1ca9a9a3f
if shrink_dict
	local n = min(20, size(img, 2))
	dict_carved = shrink_n(memoized_recursive_seam, img, n)
	md"Shrink by: $(@bind dict_n Slider(1:n, show_value=true))"
end

# ╔═╡ 6e73b1da-f3c5-11ea-145f-6383effe8a89
if shrink_dict
	dict_carved[dict_n]
end

# ╔═╡ 50829af6-f3c5-11ea-04a8-0535edd3b0aa
if shrink_matrix
	local n = min(20, size(img, 2))
	matrix_carved = shrink_n(matrix_memoized_seam, img, n)
	md"Shrink by: $(@bind matrix_n Slider(1:n, show_value=true))"
end

# ╔═╡ 9e56ecfa-f3c5-11ea-2e90-3b1839d12038
if shrink_matrix
	matrix_carved[matrix_n]
end

# ╔═╡ 51e28596-f3c5-11ea-2237-2b72bbfaa001
if shrink_bottomup
	local n = min(40, size(img, 2))
	bottomup_carved = shrink_n(seam_from_precomputed_least_energy, img, n)
	md"Shrink by: $(@bind bottomup_n Slider(1:n, show_value=true))"
end

# ╔═╡ 0a10acd8-f3c6-11ea-3e2f-7530a0af8c7f
if shrink_bottomup
	bottomup_carved[bottomup_n]
end

# ╔═╡ ef26374a-f388-11ea-0b4e-67314a9a9094
function pencil(X)
	f(x) = RGB(1-x,1-x,1-x)
	map(f, X ./ maximum(X))
end

# ╔═╡ 6bdbcf4c-f321-11ea-0288-fb16ff1ec526
function decimate(img, n)
	img[1:n:end, 1:n:end]
end

# ╔═╡ ffc17f40-f380-11ea-30ee-0fe8563c0eb1
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 9f18efe2-f38e-11ea-0871-6d7760d0b2f6
hint(md"You can call the `least_energy` function recursively within itself to obtain the least energy of the adjacent cells and add the energy at the current cell to get the total energy.")

# ╔═╡ 6435994e-d470-4cf3-9f9d-d00df183873e
hint(md"We recommend using a matrix with element type `Union{Nothing, Tuple{Float64,Int}}`, initialized to all `nothing`s. You can check whether the value at `(i,j)` has been computed before using `memory[i,j] != nothing`.")

# ╔═╡ ffc40ab2-f380-11ea-2136-63542ff0f386
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ ffceaed6-f380-11ea-3c63-8132d270b83f
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ ffde44ae-f380-11ea-29fb-2dfcc9cda8b4
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ 1413d047-099f-48c9-bbb0-ff0a3ddb4888
begin
	function visualize_seam_algorithm(test_energies, algorithm::Function, starting_pixel::Integer)
		seam = algorithm(test_energies, starting_pixel)
		visualize_seam_algorithm(test_energies, seam)
	end
	function visualize_seam_algorithm(test_energies, seam::Vector)
	display_img = RGB.(test_energies)
		for (i, j) in enumerate(seam)
			try
				display_img[i, j] = RGB(0.9, 0.3, 0.6)
			catch ex
				if ex isa BoundsError
					return keep_working("")
				end
				# the solution might give an illegal index
			end
		end
		display_img
	end
end

# ╔═╡ 2a7e49b8-f395-11ea-0058-013e51baa554
visualize_seam_algorithm(grant_example, greedy_seam_result)

# ╔═╡ ffe326e0-f380-11ea-3619-61dd0592d409
yays = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ fff5aedc-f380-11ea-2a08-99c230f8fa32
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 9ff0ce41-327f-4bf0-958d-309cd0c0b6e5
if recursive_seam_test == grant_example_optimal_seam
	correct()
else
	keep_working()
end

# ╔═╡ 344964a8-7c6b-4720-a624-47b03483263b
let
	result = track_access(rand(10,10)) do tracked
		memoized_least_energy(tracked, 1, 5, Dict())
		end
	if result == 0
		nothing
	elseif result < 200
		correct()
	else
		keep_working(md"That's still too many accesses! Did you forget to add a result to the `memory`?")
	end
end

# ╔═╡ c1ab3d5f-8e6c-4702-ad40-6c7f787f1c43
let
	aresult = track_access(rand(10,10)) do tracked
		memoized_recursive_seam(tracked, 5)
	end
	if aresult < 200
		if memoized_recursive_seam(grant_example, 4) == grant_example_optimal_seam
			correct()
		else
			keep_working(md"The returned seam is not correct. Did you implement the non-memoized version correctly?")
		end
	else
		keep_working(md"Careful! Your `memoized_recursive_seam` is still making too many memory accesses, you may not want to run the visualization below.")
	end
end

# ╔═╡ 00026442-f381-11ea-2b41-bde1fff66011
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 414dd91b-8d05-44f0-8bbd-b15981ce1210
if !@isdefined(least_energy)
	not_defined(:least_energy)
else
	let
		result1 = least_energy(grant_example, 6, 4)
		
		if !(result1 isa Tuple)
			keep_working(md"Your function should return a _tuple_, like `(1.2, 5)`.")
		elseif !(result1 isa Tuple{Float64,Int})
			keep_working(md"Your function should return a _tuple_, like `(1.2, 5)`.")
		else
			result = least_energy(grant_example, 1, 4)
			if !(result isa Tuple{Float64,Int})
				keep_working(md"Your function should return a _tuple_, like `(1.2, 5)`.")
			else
				a, b = result

				if a ≈ 0.3 && b == 4
					almost(md"Only search the (at most) three cells that are within reach.")
				elseif a ≈ 0.6 && b == 3
					correct()
				else
					keep_working()
				end
			end
		end
	end
end

# ╔═╡ e0622780-f3b4-11ea-1f44-59fb9c5d2ebd
if !@isdefined(least_energy_matrix)
	not_defined(:least_energy_matrix)
elseif !(le_test isa Matrix{<:Real})
	keep_working(md"`least_energy_matrix` should return a 2D array of Float64 values.")
end

# ╔═╡ 946b69a0-f3a2-11ea-2670-819a5dafe891
if !@isdefined(seam_from_precomputed_least_energy)
	not_defined(:seam_from_precomputed_least_energy)
end

# ╔═╡ fbf6b0fa-f3e0-11ea-2009-573a218e2460
function hbox(x, y, gap=16; sy=size(y), sx=size(x))
	w, h = (max(sx[1], sy[1]),
		   gap + sx[2] + sy[2])
	
	slate = fill(RGB(1,1,1), w,h)
	slate[1:size(x,1), 1:size(x,2)] .= RGB.(x)
	slate[1:size(y,1), size(x,2) + gap .+ (1:size(y,2))] .= RGB.(y)
	slate
end

# ╔═╡ f010933c-f318-11ea-22c5-4d2e64cd9629
hbox(
	float_to_color.(convolve(brightness.(img), Kernel.sobel()[1])),
	float_to_color.(convolve(brightness.(img), Kernel.sobel()[2])),
)

# ╔═╡ 9fa0cd3a-f3e1-11ea-2f7e-bd73b8e3f302
hbox(
	float_to_color.(energy(img)),
	Gray.(energy(img))
)

# ╔═╡ 256edf66-f3e1-11ea-206e-4f9b4f6d3a3d
vbox(x,y, gap=16) = hbox(x', y')'

# ╔═╡ 00115b6e-f381-11ea-0bc6-61ca119cb628
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ c086bd1e-f384-11ea-3b26-2da9e24360ca
bigbreak

# ╔═╡ f7eba2b6-f388-11ea-06ad-0b861c764d61
bigbreak

# ╔═╡ 4f48c8b8-f39d-11ea-25d2-1fab031a514f
bigbreak

# ╔═╡ 48089a00-f321-11ea-1479-e74ba71df067
bigbreak

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
ImageFiltering = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
TestImages = "5e47fb64-e119-507b-a336-dd2b206d9990"

[compat]
BenchmarkTools = "~1.3.2"
FileIO = "~1.16.1"
ImageFiltering = "~0.7.5"
ImageIO = "~0.6.6"
Images = "~0.25.3"
PlutoUI = "~0.7.51"
TestImages = "~1.7.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.1"
manifest_format = "2.0"
project_hash = "2cfc96ed43a53f59fd4037791e550b40403521d5"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "16b6dbc4cf7caee4e1e75c49485ec67b667098a0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "76289dc51920fdc6e0013c872ba9551d54961c24"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.2"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "1dd4d9f5beebac0c03446918741b1a03dc5e5788"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.6"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e30f2f4e20f7f186dc36529910beaedc60cfa644"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.16.0"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "a6e6ce44a1e0a781772fc795fb7343b1925e9898"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.2"

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

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "f9d7112bfff8a19a3a4ea4e03a8e6a91fe8456bf"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.3"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

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

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "49eba9ad9f7ead780bfb7ee319f962c811c6d3b2"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.8"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "06bf20fcecd258eccf9a6ef7b99856a4dfe7b64c"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.7.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "299dc33549f68299137e51e6d49a13b5b1da9673"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "43ba3d3c82c18d88471cfd2924931658838c9d8f"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.0+4"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "1cf1d7dcb4bc32d7b4a5add4232db3750c27ecb4"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.8.0"

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

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "c54b581a83008dc7f292e205f4c409ab5caa0f04"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.10"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageContrastAdjustment]]
deps = ["ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "0d75cafa80cf22026cea21a8e6cf965295003edc"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.10"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "b1798a4a6b9aafb530f8f0c4a7b2eb5501e2f2a3"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.16"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "Reexport", "SnoopPrecompile", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "d90867cbe037730a73c9a9499b3591eedbe387a0"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.5"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "342f789fd041a55166764c351da1710db97ce0e0"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.6"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils", "Libdl", "Pkg", "Random"]
git-tree-sha1 = "5bc1cb62e0c5f1005868358db0692c994c3a13c6"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.1"

[[deps.ImageMagick_jll]]
deps = ["Artifacts", "Ghostscript_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "124626988534986113cfd876e3093e4a03890f58"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.12+3"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "36cbaebed194b292590cba2593da27b34763804a"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.8"

[[deps.ImageMorphology]]
deps = ["ImageCore", "LinearAlgebra", "Requires", "TiledIteration"]
git-tree-sha1 = "e7c68ab3df4a75511ba33fc5d8d9098007b579a8"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.3.2"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "LazyModules", "OffsetArrays", "PrecompileTools", "Statistics"]
git-tree-sha1 = "bcc2f0db769e5d42a67f501ec6781401a4389e8f"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.5"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "44664eea5408828c03e5addb84fa4f916132fc26"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.8.1"

[[deps.ImageShow]]
deps = ["Base64", "ColorSchemes", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "ce28c68c900eed3cdbfa418be66ed053e54d4f56"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.7"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "ColorVectorSpace", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "8717482f4a2108c9358e5c3ca903d3a6113badc9"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.9.5"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "5fa9f92e1e2918d9d1243b1131abe623cdf98be7"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.25.3"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3d09a9f60edf77f8a4d99f9e015e8fbf9989605d"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.7+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "be8e690c3973443bec584db3346ddc904d4884eb"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0cb9352ef2e01574eeebdb102948a58740dcaf83"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2023.1.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "721ec2cf720536ad005cb38f50dbba7b02419a15"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.7"

[[deps.IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "16c0cc91853084cb5f58a78bd209513900206ce6"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.4"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "4ced6667f9974fc5c5943fa5e2ef1ca43ea9e450"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.8.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "Printf", "Reexport", "Requires", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "42c17b18ced77ff0be65957a591d34f4ed57c631"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.31"

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

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "106b6aa272f294ba47e96bd3acbabdc0407b5c60"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.2"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

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

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

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

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "2ce8695e1e699b68702c03402672a69f54b8aca9"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "1130dbe1d5276cb656f6e1094ce97466ed700e5a"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "2c3726ceb3388917602169bed973dbc97f1b51a8"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.13"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "5ae7ca23e13855b3aba94550f26146c01d259267"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "82d7c9e310fe55aa54996e6f7f94674e2a38fcb4"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.9"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "a4ca623df1ae99d09bc9868b008262d0c0ac1e4f"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.4+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "d321bf2de576bf25ec4d3e4360faca399afca282"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.0"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "f809158b27eba0c18c269cf2a2be6ed751d3e81d"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.17"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "5a6ab2f64388fd1175effdf73fe5933ef1e0bac0"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f6cf8e7944e50901594838951729a1861e668cb8"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.2"

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

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "da095158bdc8eaccb7890f9884048555ab771019"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays"]
git-tree-sha1 = "54ccb4dbab4b1f69beb255a2c0ca5f65a9c82f08"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.5.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays"]
git-tree-sha1 = "4b33e0e081a825dbfaf314decf58fa47e53d6acb"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.4.0"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "832afbae2a45b4ae7e831f86965469a24d1d8a83"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.26"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

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

[[deps.StringDistances]]
deps = ["Distances", "StatsAPI"]
git-tree-sha1 = "ceeef74797d961aee825aabf71446d6aba898acb"
uuid = "88034a9c-02f8-509d-84a9-84ec65e18404"
version = "0.11.2"

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

[[deps.TestImages]]
deps = ["AxisArrays", "ColorTypes", "FileIO", "ImageIO", "ImageMagick", "OffsetArrays", "Pkg", "StringDistances"]
git-tree-sha1 = "03492434a1bdde3026288939fc31b5660407b624"
uuid = "5e47fb64-e119-507b-a336-dd2b206d9990"
version = "1.7.1"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "8621f5c499a8aa4aa970b1ae381aae0ef1576966"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.4"

[[deps.TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "5683455224ba92ef59db72d10690690f4a8dc297"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.1"

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

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─e6b6760a-f37f-11ea-3ae1-65443ef5a81a
# ╟─85cfbd10-f384-11ea-31dc-b5693630a4c5
# ╟─938185ec-f384-11ea-21dc-b56b7469f798
# ╠═a4937996-f314-11ea-2ff9-615c888afaa8
# ╟─0f271e1d-ae16-4eeb-a8a8-37951c70ba31
# ╟─6dabe5e2-c851-4a2e-8b07-aded451d8058
# ╠═ab276048-f34b-42dd-b6bf-0b83c6d99e6a
# ╠═0d144802-f319-11ea-0028-cd97a776a3d0
# ╟─a5271c38-ba45-416b-94a4-ba608c25b897
# ╟─365349c7-458b-4a6d-b067-5112cb3d091f
# ╟─b49e8cc8-f381-11ea-1056-91668ac6ae4e
# ╠═90a22cc6-f327-11ea-1484-7fda90283797
# ╠═5370bf57-1341-4926-b012-ba58780217b1
# ╟─c075a8e6-f382-11ea-2263-cd9507324f4f
# ╠═52425e53-0583-45ab-b82b-ffba77d444c8
# ╟─a09aa706-6e35-4536-a16b-494b972e2c03
# ╠═268546b2-c4d5-4aa5-a57f-275c7da1450c
# ╟─6aeb2d1c-8585-4397-a05f-0b1e91baaf67
# ╠═2f945ca3-e7c5-4b14-b618-1f9da019cffd
# ╟─c086bd1e-f384-11ea-3b26-2da9e24360ca
# ╟─318a2256-f369-11ea-23a9-2f74c566549b
# ╟─7a44ba52-f318-11ea-0406-4731c80c1007
# ╠═6c7e4b54-f318-11ea-2055-d9f9c0199341
# ╠═74059d04-f319-11ea-29b4-85f5f8f5c610
# ╟─0b9ead92-f318-11ea-3744-37150d649d43
# ╠═d184e9cc-f318-11ea-1a1e-994ab1330c1a
# ╠═cdfb3508-f319-11ea-1486-c5c58a0b9177
# ╠═f010933c-f318-11ea-22c5-4d2e64cd9629
# ╟─5fccc7cc-f369-11ea-3b9e-2f0eca7f0f0e
# ╠═e9402079-713e-4cfd-9b23-279bd1d540f6
# ╠═6f37b34c-f31a-11ea-2909-4f2079bf66ec
# ╠═9fa0cd3a-f3e1-11ea-2f7e-bd73b8e3f302
# ╟─f7eba2b6-f388-11ea-06ad-0b861c764d61
# ╟─87afabf8-f317-11ea-3cb3-29dced8e265a
# ╟─8ba9f5fc-f31b-11ea-00fe-79ecece09c25
# ╟─f5a74dfc-f388-11ea-2577-b543d31576c6
# ╟─2f9cbea8-f3a1-11ea-20c6-01fd1464a592
# ╟─c3543ea4-f393-11ea-39c8-37747f113b96
# ╠═abf20aa0-f31b-11ea-2548-9bea4fab4c37
# ╟─5430d772-f397-11ea-2ed8-03ee06d02a22
# ╟─6f52c1a2-f395-11ea-0c8a-138a77f03803
# ╠═5057652e-2f88-40f1-82f0-55b1b5bca6f6
# ╠═2a7e49b8-f395-11ea-0058-013e51baa554
# ╟─2643b00d-2bac-4868-a832-5fb8ad7f173f
# ╟─a4d14606-7e58-4770-8532-66b875c97b70
# ╠═38f70c35-2609-4599-879d-e032cd7dc49d
# ╟─1413d047-099f-48c9-bbb0-ff0a3ddb4888
# ╟─9945ae78-f395-11ea-1d78-cf6ad19606c8
# ╟─87efe4c2-f38d-11ea-39cc-bdfa11298317
# ╟─f6571d86-f388-11ea-0390-05592acb9195
# ╟─f626b222-f388-11ea-0d94-1736759b5f52
# ╟─52452d26-f36c-11ea-01a6-313114b4445d
# ╠═2a98f268-f3b6-11ea-1eea-81c28256a19e
# ╟─32e9a944-f3b6-11ea-0e82-1dff6c2eef8d
# ╟─9101d5a0-f371-11ea-1c04-f3f43b96ca4a
# ╠═8ec27ef8-f320-11ea-2573-c97b7b908cb7
# ╠═ad524df7-29e2-4f0d-ad72-8ecdd57e4f02
# ╠═1add9afd-5ff5-451d-ad81-57b0e929dfe8
# ╟─414dd91b-8d05-44f0-8bbd-b15981ce1210
# ╟─447e54f8-d3db-4970-84ee-0708ab8a9244
# ╠═8b8da8e7-d3b5-410e-b100-5538826c0fde
# ╟─e1074d35-58c4-43c0-a6cb-1413ed194e25
# ╠═281b950f-2331-4666-9e45-8fd117813f45
# ╟─9f18efe2-f38e-11ea-0871-6d7760d0b2f6
# ╟─a7f3d9f8-f3bb-11ea-0c1a-55bbb8408f09
# ╠═fa8e2772-f3b6-11ea-30f7-699717693164
# ╟─18e0fd8a-f3bc-11ea-0713-fbf74d5fa41a
# ╟─cbf29020-f3ba-11ea-2cb0-b92836f3d04b
# ╟─8bc930f0-f372-11ea-06cb-79ced2834720
# ╠═85033040-f372-11ea-2c31-bb3147de3c0d
# ╟─f92ac3e4-fa70-4bcf-bc50-a36792a8baaa
# ╠═7ac5eb8d-9dba-4700-8f3a-1e0b2addc740
# ╟─9ff0ce41-327f-4bf0-958d-309cd0c0b6e5
# ╟─c572f6ce-f372-11ea-3c9a-e3a21384edca
# ╠═6d993a5c-f373-11ea-0dde-c94e3bbd1552
# ╟─ea417c2a-f373-11ea-3bb0-b1b5754f2fac
# ╟─56a7f954-f374-11ea-0391-f79b75195f4d
# ╠═f853967a-fea4-4943-aab5-d481cc5a013b
# ╠═63026eb5-1fa1-423e-8d23-a4a9c8a71cc3
# ╠═b1d09bc8-f320-11ea-26bb-0101c9a204e2
# ╠═1947f304-fa2c-4019-8584-01ef44ef2859
# ╟─8992172e-c5b6-463e-a06e-5fe42fb9b16b
# ╠═ced5a7b5-24eb-43b7-841e-16c80d300e2e
# ╠═b387f8e8-dced-473a-9434-5334829ecfd1
# ╟─344964a8-7c6b-4720-a624-47b03483263b
# ╠═3e8b0868-f3bd-11ea-0c15-011bbd6ac051
# ╠═d941c199-ed77-47dd-8b5a-e34b864f9a79
# ╠═726280f0-682f-4b05-bf5a-688554a96287
# ╟─c1ab3d5f-8e6c-4702-ad40-6c7f787f1c43
# ╟─4e3bcf88-f3c5-11ea-3ada-2ff9213647b7
# ╟─4e3ef866-f3c5-11ea-3fb0-27d1ca9a9a3f
# ╟─6e73b1da-f3c5-11ea-145f-6383effe8a89
# ╟─cf39fa2a-f374-11ea-0680-55817de1b837
# ╠═c8724b5e-f3bd-11ea-0034-b92af21ca12d
# ╟─6435994e-d470-4cf3-9f9d-d00df183873e
# ╠═be7d40e2-f320-11ea-1b56-dff2a0a16e8d
# ╠═8cd3112d-c986-4f91-8dcb-e38b3830d3f9
# ╟─507f3870-f3c5-11ea-11f6-ada3bb087634
# ╟─50829af6-f3c5-11ea-04a8-0535edd3b0aa
# ╟─9e56ecfa-f3c5-11ea-2e90-3b1839d12038
# ╟─4f48c8b8-f39d-11ea-25d2-1fab031a514f
# ╟─24792456-f37b-11ea-07b2-4f4c8caea633
# ╠═ff055726-f320-11ea-32f6-2bf38d7dd310
# ╠═00c71421-1113-451c-b123-e1de3d70302f
# ╠═3bc23fef-a860-437b-8c84-4f6ec55e77e6
# ╟─e0622780-f3b4-11ea-1f44-59fb9c5d2ebd
# ╠═7f861036-4707-4161-8dbd-b2320292168a
# ╠═d3e69cf6-61b1-42fc-9abd-42d1ae7d61b2
# ╟─e06d4e4a-146c-4dbd-b742-317f638a3bd8
# ╟─92e19f22-f37b-11ea-25f7-e321337e375e
# ╠═795eb2c4-f37b-11ea-01e1-1dbac3c80c13
# ╟─51df0c98-f3c5-11ea-25b8-af41dc182bac
# ╟─51e28596-f3c5-11ea-2237-2b72bbfaa001
# ╟─0a10acd8-f3c6-11ea-3e2f-7530a0af8c7f
# ╟─946b69a0-f3a2-11ea-2670-819a5dafe891
# ╟─48089a00-f321-11ea-1479-e74ba71df067
# ╟─6b4d6584-f3be-11ea-131d-e5bdefcc791b
# ╟─437ba6ce-f37d-11ea-1010-5f6a6e282f9b
# ╟─ef88c388-f388-11ea-3828-ff4db4d1874e
# ╟─ef26374a-f388-11ea-0b4e-67314a9a9094
# ╟─6bdbcf4c-f321-11ea-0288-fb16ff1ec526
# ╟─ffc17f40-f380-11ea-30ee-0fe8563c0eb1
# ╟─ffc40ab2-f380-11ea-2136-63542ff0f386
# ╟─ffceaed6-f380-11ea-3c63-8132d270b83f
# ╟─ffde44ae-f380-11ea-29fb-2dfcc9cda8b4
# ╟─ffe326e0-f380-11ea-3619-61dd0592d409
# ╟─fff5aedc-f380-11ea-2a08-99c230f8fa32
# ╟─00026442-f381-11ea-2b41-bde1fff66011
# ╟─fbf6b0fa-f3e0-11ea-2009-573a218e2460
# ╟─256edf66-f3e1-11ea-206e-4f9b4f6d3a3d
# ╟─00115b6e-f381-11ea-0bc6-61ca119cb628
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
