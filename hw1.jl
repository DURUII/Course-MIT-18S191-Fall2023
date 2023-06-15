### A Pluto.jl notebook ###
# v0.19.26

#> [frontmatter]
#> chapter = 1
#> section = 2.5
#> order = 2.5
#> homework_number = 1
#> title = "Images and Arrays"
#> layout = "layout.jlhtml"
#> tags = ["homework", "module1", "image", "track_julia", "track_math", "track_climate", "track_data", "programming", "interactive", "type", "matrix"]
#> description = "Practice Julia basics by working with arrays of colors. At the end of this homework, you can see all of your filters applied to your webcam image!"

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

# ╔═╡ 65780f00-ed6b-11ea-1ecf-8b35523a7ac0
begin
	import ImageMagick
	using Images
	using PlutoUI
	using HypertextLiteral
end

# ╔═╡ ac8ff080-ed61-11ea-3650-d9df06123e1f
md"""

# **Homework 1** - _images and arrays_
`18.S191`, Fall 2023

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

Feel free to ask questions!
"""

# ╔═╡ 5f95e01a-ee0a-11ea-030c-9dba276aba92
md"""
#### Initializing packages

_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ 540ccfcc-ee0a-11ea-15dc-4f8120063397
md"""
## **Exercise 1** - _Manipulating vectors (1D images)_

A `Vector` is a 1D array. We can think of that as a 1D image.

"""

# ╔═╡ 467856dc-eded-11ea-0f83-13d939021ef3
example_vector = [0.5, 0.4, 0.3, 0.2, 0.1, 0.0, 0.7, 0.0, 0.7, 0.9]

# ╔═╡ ad6a33b0-eded-11ea-324c-cfabfd658b56
md"""
$(html"<br>")
#### Exercise 1.1
👉 Make a random vector `random_vect` of length 10 using the `rand` function.
"""

# ╔═╡ f51333a6-eded-11ea-34e6-bfbb3a69bcb0
random_vect =  rand(Float64, 10) # replace `missing` with your code!

# ╔═╡ 5da8cbe8-eded-11ea-2e43-c5b7cc71e133
begin
	colored_line(x::Vector) = hcat(Gray.(Float64.(x)))'
	colored_line(x::Any) = nothing
end

# ╔═╡ 56ced344-eded-11ea-3e81-3936e9ad5777
colored_line(example_vector)

# ╔═╡ b18e2c54-edf1-11ea-0cbf-85946d64b6a2
colored_line(random_vect)

# ╔═╡ 77adb065-bfd4-4680-9c2a-ad4d92689dbf
md"#### Exercise 1.2
👉 Make a function `my_sum` using a `for` loop, which computes the total of a vector of numbers."

# ╔═╡ bd907ee1-5253-4cae-b5a5-267dac24362a
function my_sum(xs)
	# your code here!
	sum = 0
	
	for i in xs
		sum += i
	end
	
	return sum
end

# ╔═╡ 6640110a-d171-4b32-8d12-26979a36b718
my_sum([1,2,3])

# ╔═╡ cf738088-eded-11ea-2915-61735c2aa990
md"#### Exercise 1.3
👉 Use your `my_sum` function to write a function `mean`, which computes the mean/average of a vector of numbers."

# ╔═╡ 0ffa8354-edee-11ea-2883-9d5bfea4a236
function mean(xs)
	# your code here!
	return my_sum(xs)/length(xs)
end

# ╔═╡ 1f104ce4-ee0e-11ea-2029-1d9c817175af
mean([1, 2, 3])

# ╔═╡ 1f229ca4-edee-11ea-2c56-bb00cc6ea53c
md"👉 Define `m` to be the mean of `random_vect`."

# ╔═╡ 2a391708-edee-11ea-124e-d14698171b68
m = mean(random_vect) # replace `missing` with your code!

# ╔═╡ e2863d4c-edef-11ea-1d67-332ddca03cc4
md"""#### Exercise 1.4
👉 Write a function `demean`, which takes a vector `xs` and subtracts the mean from each value in `xs`. Use your `mean` function!"""

# ╔═╡ ea8d92f8-159c-4161-8c54-bab7bc00f290
md"""
> ### Note about _mutation_
> There are two ways to think about this exercise, you could _modify_ the original vector, or you can _create a new vector_. We often prefer the second version, so that the original data is preserved. We generally only use code of the first variant in the most performance-sensitive parts of a program, as it requires more care to write and use correctly. _**Be careful not to get carried away in optimizing code**, especially when learning a new language!_
> 
> There is a convention among Julians that functions that modify their argument have a `!` in their name. For example, `sort(x)` returns a sorted _copy_ of `x`, while `sort!(x)` _modifies_ `x` to be sorted.
> 
> #### Tips for writing non-mutating code
> 1. _Rewriting_ an existing mutating function to be non-mutating can feel like a 'tedious' and 'inefficient' process. Often, instead of trying to **rewrite** a mutating function, it's best to take a step back and try to think of your problem as _constructing something new_. Instead of a `for` loop, it might make more sense to use **descriptive** primitives like [broadcasting with the dot syntax](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized) (also for [math operators](https://docs.julialang.org/en/v1/manual/mathematical-operations/#man-dot-operators)), and [map and filter](https://www.youtube.com/watch?v=_O-HBDZMLrM).
> 
> 
> 2. If a mutating algorithm makes the most sense for your problem, then you can first use `copy` to create a copy of an array, and then modify that copy.
> 
> We will cover this topic more in the later exercises!

"""

# ╔═╡ ec5efe8c-edef-11ea-2c6f-afaaeb5bc50c
function demean(xs)
	# your code here!
	return xs .- mean(xs)
end

# ╔═╡ d6ddafdd-1a44-48c7-b49a-554073cdf331
test_vect = let
	
	# feel free to change your test case here!
	to_create = [-1.0, -1.5, 8.5]
	
	
	####
	# this cell is a bit funky to deal with a common pitfall from last year
	# it regenerates the vector if you accidentally wrote a mutating function
	
	# don't worry about how it works for this exercise!
	
	demean
	to_create
end

# ╔═╡ 29e10640-edf0-11ea-0398-17dbf4242de3
md"To verify our function, let's check that the mean of the `demean(test_vect)` is 0: (_Due to floating-point round-off error it may *not* be *exactly* 0._)"

# ╔═╡ 38155b5a-edf0-11ea-3e3f-7163da7433fb
demeaned_test_vect = demean(test_vect)

# ╔═╡ 1267e961-5b75-4b55-8080-d45316a03b9b
mean(demeaned_test_vect)

# ╔═╡ a5f8bafe-edf0-11ea-0da3-3330861ae43a
md"""
#### Exercise 1.5

👉 Generate a vector of 100 elements. Where:
- the center 20 elements are set to `1`, and
- all other elements are `0`.
"""

# ╔═╡ b6b65b94-edf0-11ea-3686-fbff0ff53d08
function create_bar()
	# your code here!
	vector = [0 for i in 1:100]
	vector[50-9:51+9] .= 1
	return vector
end

# ╔═╡ 4a5e9d2c-dd90-4bb0-9e31-3f5c834406b4
create_bar()

# ╔═╡ d862fb16-edf1-11ea-36ec-615d521e6bc0
colored_line(create_bar())

# ╔═╡ 59414833-a108-4b1e-9a34-0f31dc907c6e
url = "https://user-images.githubusercontent.com/6933510/107239146-dcc3fd00-6a28-11eb-8c7b-41aaf6618935.png" 

# ╔═╡ c5484572-ee05-11ea-0424-f37295c3072d
philip_filename = download(url) # download to a local file. The filename is returned

# ╔═╡ c8ecfe5c-ee05-11ea-322b-4b2714898831
philip = load(philip_filename)

# ╔═╡ e86ed944-ee05-11ea-3e0f-d70fc73b789c
md"_Hi there Philip_"

# ╔═╡ 6ccd8902-0dd9-4335-a11a-ee7f9a1a6c09
philip_head = philip[470:800, 140:410]

# ╔═╡ 15088baa-c337-405d-8885-19a6e2bfd6aa
md"""
Recall from [Section 1.1](https://computationalthinking.mit.edu/Spring21/week1/) that in Julia, an _image_ is just a 2D array of color objects:
"""

# ╔═╡ 7ad4f6bc-588e-44ab-8ca9-c87cd1048442
typeof(philip)

# ╔═╡ a55bb5ca-600b-4aa0-b95f-7ece20845c9b
md"""
Every pixel (i.e. _element of the 2D array_) is of the `RGB` type:
"""

# ╔═╡ c5dc0cc8-9305-47e6-8b20-a9f8ef867799
philip_pixel = philip[100,100]

# ╔═╡ de772e21-0bea-4fd2-868a-9a7d32550bc9
typeof(philip_pixel)

# ╔═╡ 21bdc692-91ee-474d-ae98-455913a2342e
md"""
To get the values of its individual color channels, use the `r`, `g` and `b` _attributes_:
"""

# ╔═╡ 2ae3f379-96ce-435d-b863-deba4586ec71
philip_pixel.r, philip_pixel.g, philip_pixel.b

# ╔═╡ c49ba901-d798-489a-963c-4cc113c7abfd
md"""
And to create an `RGB` object yourself:
"""

# ╔═╡ 93451c37-77e1-4d4f-9788-c2a3da1401ee
RGB(0.1, 0.4, 0.7)

# ╔═╡ f52e4914-2926-4a42-9e45-9caaace9a7db
md"""
#### Exercise 2.1
👉 Write a function **`get_red`** that takes a single pixel, and returns the value of its red channel.
"""

# ╔═╡ a8b2270a-600c-4f83-939e-dc5ab35f4735
function get_red(pixel::AbstractRGB)
	# your code here!
	return pixel.r
end

# ╔═╡ c320b39d-4cea-4fa1-b1ce-053c898a67a6
get_red(RGB(0.8, 0.1, 0.0))

# ╔═╡ d8cf9bd5-dbf7-4841-acf9-eef7e7cabab3
md"""
#### Exercise 2.2
👉 Write a function **`get_reds`** (note the extra `s`) that accepts a 2D color array called `image`, and returns a 2D array with the red channel value of each pixel. (The result should be a 2D array of _numbers_.) Use your function `get_red` from the previous exercise.
"""

# ╔═╡ ebe1d05c-f6aa-437d-83cb-df0ba30f20bf
function get_reds(image::AbstractMatrix)
	# your code here!
	return get_red.(image)
end

# ╔═╡ c427554a-6f6a-43f1-b03b-f83239887cee
get_reds(philip_head)

# ╔═╡ 4fd07e01-2f8b-4ec9-9f4f-8a9e5ff56fb6
md"""

Great! By extracting the red channel value of each pixel, we get a 2D array of numbers. We went from an image (2D array of RGB colors) to a matrix (2D array of numbers).

#### Exercise 2.3
Let's try to visualize this matrix. Right now, it is displayed in text form, but because the image is quite large, most rows and columns don't fit on the screen. Instead, a better way to visualize it is to **view a number matrix as an image**.

This is easier than you might think! We just want to map each number to an `RGB` object, and the result will be a 2D array of `RGB` objects, which Julia will display as an image.

First, let's define a function that turns a _number_ into a _color_.
"""

# ╔═╡ 97c15896-6d99-4292-b7d7-4fcd2353656f
function value_as_color(x)
	
	return RGB(x, 0, 0)
end

# ╔═╡ cbb9bf41-4c21-42c7-b0e0-fc1ce29e0eb1
value_as_color(0.0), value_as_color(0.6), value_as_color(1.0)

# ╔═╡ 3f1a670b-44c2-4cab-909c-65f4ae9ed14b
md"""
👉 Use the functions `get_reds` and `value_as_color` to visualize the red channel values of `philip_head`. Tip: Like in previous exercises, use broadcasting ('dot syntax') to apply a function _element-wise_.

Use the ➕ button at the bottom left of this cell to add more cells.
"""

# ╔═╡ 21ba6e75-55a2-4614-9b5d-ea6378bf1d98
value_as_color.(get_reds(philip_head))

# ╔═╡ f7825c18-ff28-4e23-bf26-cc64f2f5049a
md"""

#### Exercise 2.4
👉 Write four more functions, `get_green`, `get_greens`, `get_blue` and `get_blues`, to be the equivalents of `get_red` and `get_reds`. Use the ➕ button at the bottom left of this cell to add new cells.
"""

# ╔═╡ d994e178-78fd-46ab-a1bc-a31485423cad
begin 
	function get_green(pixel::AbstractRGB)
		return pixel.g
	end
	
	function get_greens(image::AbstractMatrix)
		return get_green.(image)
	end

	function get_blue(pixel::AbstractRGB)
		return pixel.b
	end
	
	function get_blues(image::AbstractMatrix)
		return get_blue.(image)
	end
end

# ╔═╡ c54ccdea-ee05-11ea-0365-23aaf053b7d7
md"""
#### Exercise 2.5
👉 Write a function **`mean_color`** that accepts an object called `image`. It should calculate the mean amounts of red, green and blue in the image and return the average color. Be sure to use functions from previous exercises!
"""

# ╔═╡ f6898df6-ee07-11ea-2838-fde9bc739c11
function mean_color(image)
	# your code here!
	return RGB(
		mean(get_reds(image)), 
		mean(get_greens(image)), 
		mean(get_blues(image))
	)
end

# ╔═╡ 5be9b144-ee0d-11ea-2a8d-8775de265a1d
mean_color(philip)

# ╔═╡ 5f6635b4-63ed-4a62-969c-bd4084a8202f
md"""
_At the end of this homework, you can see all of your filters applied to your webcam image!_
"""

# ╔═╡ 63e8d636-ee0b-11ea-173d-bd3327347d55
function invert(color::AbstractRGB)
	# your code here!
	f(n) = 1 - n
	return RGB(f(color.r), f(color.g), f(color.b))
end

# ╔═╡ 2cc2f84e-ee0d-11ea-373b-e7ad3204bb00
md"Let's invert some colors:"

# ╔═╡ b8f26960-ee0a-11ea-05b9-3f4bc1099050
color_black = RGB(0.0, 0.0, 0.0)

# ╔═╡ 5de3a22e-ee0b-11ea-230f-35df4ca3c96d
invert(color_black)

# ╔═╡ 4e21e0c4-ee0b-11ea-3d65-b311ae3f98e9
color_red = RGB(0.8, 0.1, 0.1)

# ╔═╡ 6dbf67ce-ee0b-11ea-3b71-abc05a64dc43
invert(color_red)

# ╔═╡ 846b1330-ee0b-11ea-3579-7d90fafd7290
md"👉 Can you invert the picture of Philip?"

# ╔═╡ 943103e2-ee0b-11ea-33aa-75a8a1529931
philip_inverted = invert.(philip) # replace `missing` with your code!

# ╔═╡ 55b138b7-19fb-4da1-9eb1-1e8304528251
md"""
_At the end of this homework, you can see all of your filters applied to your webcam image!_
"""

# ╔═╡ f68d4a36-ee07-11ea-0832-0360530f102e
md"""
#### Exercise 3.2
👉 Look up the documentation on the `floor` function. Use it to write a function `quantize(x::Number)` that takes in a value $x$ (which you can assume is between 0 and 1) and "quantizes" it into bins of width 0.1. For example, check that 0.267 gets mapped to 0.2.
"""

# ╔═╡ fbd1638d-8d7a-4d12-aff9-9c160cc3fd74
function quantize(x::Number)
	# your code here!
	return floor(x * 10) / 10
end

# ╔═╡ 7720740e-2d2b-47f7-98fd-500ed3eee479
md"""
#### Intermezzo: _multiple methods_

In Julia, we often write multiple methods for the same function. When a function is called, the method is chosen based on the input arguments. Let's look at an example:

These are two _methods_ to the same function, because they have 

> **the same name, but different input types**
"""

# ╔═╡ 90421bca-0804-4d6b-8bd0-3ddbd54cc5fe
function double(x::Number)
	
	return x * 2
end

# ╔═╡ b2329e4c-6204-453e-8998-2414b869b808
function double(x::Vector)
	
	return [x..., x...]
end

# ╔═╡ 23fcd65f-0182-41f3-80ec-d85b05136c47
md"""
When we call the function `double`, Julia will decide which method to call based on the given input argument!
"""

# ╔═╡ 5055b74c-b98d-41fa-a0d8-cb36200d82cc
double(24)

# ╔═╡ 8db17b2b-0cf9-40ba-8f6f-2e53be7b6355
double([1,2,37])

# ╔═╡ a8a597e0-a01c-40cd-9902-d56430afd938
md"""
We call this **multiple dispatch**, and it is one of Julia's key features. Throughout this course, you will see lots of real-world application, and learn to use multiple dispatch to create flexible and readable abstractions!
"""

# ╔═╡ f6b218c0-ee07-11ea-2adb-1968c4fd473a
md"""
#### Exercise 3.3
👉 Write the second **method** of the function `quantize`, i.e. a new *version* of the function with the *same* name. This method will accept a color object called `color`, of the type `AbstractRGB`. 
    
Here, `::AbstractRGB` is a **type annotation**. This ensures that this version of the function will be chosen when passing in an object whose type is a **subtype** of the `AbstractRGB` abstract type. For example, both the `RGB` and `RGBX` types satisfy this.

The method you write should return a new `RGB` object, in which each component ($r$, $g$ and $b$) are quantized. Use your previous method for `quantize`!
"""

# ╔═╡ 04e6b486-ceb7-45fe-a6ca-733703f16357
function quantize(color::AbstractRGB)
	# your code here!
	return RGB(quantize(color.r), quantize(color.g), quantize(color.b))
end

# ╔═╡ f6bf64da-ee07-11ea-3efb-05af01b14f67
md"""
#### Exercise 3.4
👉 Write a method `quantize(image::AbstractMatrix)` that quantizes an image by quantizing each pixel in the image. (You may assume that the matrix is a matrix of color objects.)
"""

# ╔═╡ 13e9ec8d-f615-4833-b1cf-0153010ccb65
function quantize(image::AbstractMatrix)
	# your code here!
	return quantize.(image)
end

# ╔═╡ f6a655f8-ee07-11ea-13b6-43ca404ddfc7
quantize(0.267), quantize(0.91)

# ╔═╡ 25dad7ce-ee0b-11ea-3e20-5f3019dd7fa3
md"Let's apply your method!"

# ╔═╡ 9751586e-ee0c-11ea-0cbb-b7eda92977c9
quantize(philip)

# ╔═╡ f6d6c71a-ee07-11ea-2b63-d759af80707b
md"""
#### Exercise 3.5
👉 Write a function `noisify(x::Number, s)` to add randomness of intensity $s$ to a value $x$, i.e. to add a random value between $-s$ and $+s$ to $x$. If the result falls outside the range $[0, 1]$ you should "clamp" it to that range. (Julia has a built-in `clamp` function, or you can write your own function.)
"""

# ╔═╡ f38b198d-39cf-456f-a841-1ba08f206010
function noisify(x::Number, s)
	# your code here!
	# 1 -> 2s, [0, 2s] -> [x-s, x+s]
	return clamp(x + rand() * s * 2 - s, 0, 1)
end

# ╔═╡ f6fc1312-ee07-11ea-39a0-299b67aee3d8
md"""
👉  Write the second method `noisify(c::AbstractRGB, s)` to add random noise of intensity $s$ to each of the $(r, g, b)$ values in a colour. 

Use your previous method for `noisify`. _(Remember that Julia chooses which method to use based on the input arguments. So to call the method from the previous exercise, the first argument should be a number.)_
"""

# ╔═╡ d56a7ebc-5874-45d8-b348-ec5b8c4f9b9c


# ╔═╡ db4bad9f-df1c-4640-bb34-dd2fe9bdce18
function noisify(x::AbstractRGB, s::Float64)
	# your code here!
	return RGB(noisify(x.r, s), noisify(x.g, s), noisify(x.b, s))
end

# ╔═╡ 0000b7f8-4c43-4dd8-8665-0dfe59e74c0a
md"""
Noise strength:
"""

# ╔═╡ 774b4ce6-ee1b-11ea-2b48-e38ee25fc89b
@bind color_noise Slider(0:0.01:1, show_value=true)

# ╔═╡ 48de5bc2-72d3-11eb-3fd9-eff2b686cb75
md"""
> ### Note about _array comprehension_
> At this point, you already know of a few ways to make a new array based on one that already exists.
> 1. you can use a for loop to go through a array
> 1. you can use function broadcasting over a array
> 1. you can use _**array comprehension**_!
>
> The third option you are about to see demonstrated below and following the following syntax:
>
> ```[function_to_apply(args) for args in some_iterable_of_your_choice]```
>
> This creates a new iterable that matches what you iterate through in the second part of the comprehension. Below is an example with `for` loops through two iterables that creates a 2-dimensional `Array`.
"""

# ╔═╡ f70823d2-ee07-11ea-2bb3-01425212aaf9
md"""
👉 Write the third method `noisify(image::AbstractMatrix, s)` to noisify each pixel of an image. This function should be a single line!
"""

# ╔═╡ 21a5885d-00ab-428b-96c3-c28c98c4ca6d
function noisify(image::AbstractMatrix, s)
	# your code here!
	return noisify.(image, s)
end

# ╔═╡ 1ea53f41-b791-40e2-a0f8-04e13d856829
noisify(0.5, 0.1) # edit this test case!

# ╔═╡ 7e4aeb70-ee1b-11ea-100f-1952ba66f80f
(original=color_red, with_noise=noisify(color_red, color_noise))

# ╔═╡ 8e848279-1b3e-4f32-8c0c-45693d12de96
[
	noisify(color_red, strength)
	for 
		strength in 0 : 0.05 : 1,
		row in 1:10
]'

# ╔═╡ d896b7fd-20db-4aa9-bbcf-81b1cd44ec46
md"""

#### Exercise 3.6
Move the slider below to set the amount of noise applied to the image of Philip.
"""

# ╔═╡ e70a84d4-ee0c-11ea-0640-bf78653ba102
@bind philip_noise Slider(0:0.01:5, show_value=true)

# ╔═╡ ac15e0d0-ee0c-11ea-1eaf-d7f88b5df1d7
noisify(philip_head, philip_noise)

# ╔═╡ 9604bc44-ee1b-11ea-28f8-7f7af8d0cbb2
if philip_noise == 1
	md"""
	> #### What's this?
	> 
	> The noise intensity is `1.0`, but we can still recognise Philip in the picture... 
	> 
	> 👉 Modify the definition of the slider to go further than `1.0`.
	"""
end

# ╔═╡ f714699e-ee07-11ea-08b6-5f5169861b57
md"""
👉 For which noise intensity does it become unrecognisable? 

You may need noise intensities larger than 1. Why?

"""

# ╔═╡ bdc2df7c-ee0c-11ea-2e9f-7d2c085617c1
answer_about_noise_intensity = md"""
The image is unrecognisable with intensity 4.

Noise intensities rendering image unrecognisable may be useful when we want to, for example, erase the individual privacy on the picture.
"""

# ╔═╡ e87e0d14-43a5-490d-84d9-b14ece472061
md"""
### Results
"""

# ╔═╡ d688c7e9-9f1e-4eb9-a71d-8709eab4e24e
function custom_filter(num::Number)
	# your code here!
	return clamp(num, 0.25, 0.75)
end

# ╔═╡ ee5f21fb-1076-42b6-8926-8bbb6ed0ad67
function custom_filter(pixel::AbstractRGB)
	# your code here!
	return RGB(
		custom_filter(pixel.r), 
		custom_filter(pixel.g), 
		custom_filter(pixel.b)
	)
end

# ╔═╡ 9e5a08dd-332a-486b-94ab-15c49e72e522
function custom_filter(image::AbstractMatrix)
	return custom_filter.(image)
end

# ╔═╡ 756d150a-b7bf-4bf5-b372-5b0efa80d987
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 4bc94bec-da39-4f8a-82ee-9953ed73b6a4
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ b1d5ca28-edf6-11ea-269e-75a9fb549f1d
md"""
You can find out more about any function (like `rand`) by clicking on the Live Docs in the bottom right of this Pluto window, and typing a function name in the top.

![image](https://user-images.githubusercontent.com/6933510/107848812-c934df80-6df6-11eb-8a32-663d802f5d11.png)


![image](https://user-images.githubusercontent.com/6933510/107848846-0f8a3e80-6df7-11eb-818a-7271ecb9e127.png)

We recommend that you leave the window open while you work on Julia code. It will continually look up documentation for anything you type!

#### Help, I don't see the Live Docs!

Try the following:

🙋 **Are you viewing a static preview?** The Live Docs only work if you _run_ the notebook. If you are reading this on our course website, then click the button in the top right to run the notebook.

🙋 **Is your screen too small?** Try resizing your window or zooming out.
""" |> hint

# ╔═╡ 24090306-7395-4f2f-af31-34f7486f3945
hint(md"""Check out this page for a refresher on basic Julia syntax:
	
	[Basic Julia Syntax](https://computationalthinking.mit.edu/Spring21/basic_syntax/)""")

# ╔═╡ aa1ff74a-4e78-4ef1-8b8d-3a60a168cf6d
hint(md"""
In [Section 1.1](https://computationalthinking.mit.edu/Spring21/week1/), we drew a red square on top of the image Philip with a simple command...
""")

# ╔═╡ 50e2b0fb-b06d-4ac1-bdfb-eab833466736
md"""
This exercise can be quite difficult if you use a `for` loop or list comprehension. 

Instead, you should use the [dot syntax](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized) to apply a function _element-wise_ to an array. For example, this is how you get the square root of `3`:

```
sqrt(3)
```

and this is how you get the square roots of 1, 2 and 3:

```
sqrt.([1, 2, 3])
```

""" |> hint

# ╔═╡ f6ef2c2e-ee07-11ea-13a8-2512e7d94426
hint(md"`rand()` generates a (uniformly) random floating-point number between $0$ and $1$.")

# ╔═╡ 8ce6ad06-819c-4af5-bed7-56ecc08c97be
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ dfa40e89-03fc-4a7a-825e-92d67ee217b2
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ 086ec1ff-b62d-4566-9973-5b2cc3353409
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ 2f6fb3a6-bb5d-4c7a-9297-84dd4b16c7c3
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ c22f688b-dc04-4a94-b541-fe06266c5446
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 09102183-f9fb-4d89-b4f9-5d76af7b8e90
let
	result = get_red(RGB(0.2, 0.3, 0.4))
	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Did you forget to write `return`?")
	elseif result == 0.2
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 63ac142e-6d9d-4109-9286-030a02c900b4
let
	test = [RGB(0.2, 0, 0)   RGB(0.6, 0, 0)]
	result = get_reds(test)
	
	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Did you forget to write `return`?")
	elseif result == [ 0.2  0.6 ]
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 80a4cb23-49c9-4446-a3ec-b2203128dc27
let
	result = invert(RGB(1.0, 0.5, 0.25)) # I chose these values because they can be represented exactly by Float64
	shouldbe = RGB(0.0, 0.5, 0.75)
	
	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Did you forget to write `return`?")
	elseif !(result isa AbstractRGB)
		keep_working(md"You need to return a _color_, i.e. an object of type `RGB`. Use `RGB(r, g, b)` to create a color with channel values `r`, `g` and `b`.")
	elseif !(result == shouldbe)
		keep_working()
	else
		correct()
	end
end

# ╔═╡ a6d9635b-85ed-4590-ad09-ca2903ea8f1d
let
	result = quantize(RGB(.297, .1, .0))

	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Did you forget to write `return`?")
	elseif !(result isa AbstractRGB)
		keep_working(md"You need to return a _color_, i.e. an object of type `RGB`. Use `RGB(r, g, b)` to create a color with channel values `r`, `g` and `b`.")
	elseif result != RGB(0.2, .1, .0)
		keep_working()
	else
		correct()
	end
end

# ╔═╡ 31ef3710-e4c9-4aa7-bd8f-c69cc9a977ee
let
	result = noisify(0, 0.5)

	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Did you forget to write `return`?")
	elseif result == 0.5
		
		results = [noisify(0.9, 0.1) for _ in 1:1000]
		
		if 0.8 ≤ minimum(results) < 0.81 && 0.99 ≤ maximum(results) ≤ 1
			result = noisify(5, 3)
			
			if result == 1
				correct()
			else
				keep_working(md"The result should be restricted to the range ``[0,1]``.")
			end
		else
			keep_working()
		end
	else
		keep_working(md"What should `noisify(0.5, 0)` be?")
		correct()
	end
end

# ╔═╡ ab3d1b70-88e8-4118-8d3e-601a8a68f72d
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 397941fc-edee-11ea-33f2-5d46c759fbf7
if !@isdefined(random_vect)
	not_defined(:random_vect)
elseif ismissing(random_vect)
	still_missing()
elseif !(random_vect isa Vector)
	keep_working(md"`random_vect` should be a `Vector`.")
elseif eltype(random_vect) != Float64
	almost(md"""
		You generated a vector of random integers. For the remaining exercises, we want a vector of `Float64` numbers. 
		
		The (optional) first argument to `rand` specifies the **type** of elements to generate. For example: `rand(Bool, 10)` generates 10 values that are either `true` or `false`. (Try it!)
		""")
elseif length(random_vect) != 10
	keep_working(md"`random_vect` does not have the correct size.")
elseif length(Set(random_vect)) != 10
	keep_working(md"`random_vect` is not 'random enough'")
else
	correct(md"Well done! You can run your code again to generate a new vector!")
end

# ╔═╡ e0bfc973-2808-4f84-b065-fb3d05401e30
if !@isdefined(my_sum)
	not_defined(:my_sum)
else
	let
		result = my_sum([1,2,3])
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != 6
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 38dc80a0-edef-11ea-10e9-615255a4588c
if !@isdefined(mean)
	not_defined(:mean)
else
	let
		result = mean([1,2,3])
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != 2
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 2b1ccaca-edee-11ea-34b0-c51659f844d0
if !@isdefined(m)
	not_defined(:m)
elseif ismissing(m)
	still_missing()
elseif !(m isa Number)
	keep_working(md"`m` should be a number.")
elseif m != mean(random_vect)
	keep_working()
else
	correct()
end

# ╔═╡ adf476d8-a334-4b35-81e8-cc3b37de1f28
if !@isdefined(mean)
	not_defined(:mean)
else
	let
		input = Float64[1,2,3]
		result = demean(input)
		
		if input === result
			almost(md"""
			It looks like you **modified** `xs` inside the function.
			
			It is preferable to avoid mutation inside functions, because you might want to use the original data again. For example, applying `demean` to a dataset of sensor readings would **modify** the original data, and the rest of your analysis would be erroneous.
			
			""")
		elseif ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa AbstractVector) || length(result) != 3
			keep_working(md"Return a vector of the same size as `xs`.")
		elseif abs(sum(result) / 3) < 1e-10
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ e3394c8a-edf0-11ea-1bb8-619f7abb6881
if !@isdefined(create_bar)
	not_defined(:create_bar)
else
	let
		result = create_bar()
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa Vector) || length(result) != 100
			keep_working(md"The result should be a `Vector` with 100 elements.")
		elseif result[[1,50,100]] != [0,1,0]
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 4d0158d0-ee0d-11ea-17c3-c169d4284acb
if !@isdefined(mean_color)
	not_defined(:mean_color)
else
	let
		input = reshape([RGB(1.0, 1.0, 1.0), RGB(1.0, 1.0, 0.0)], (2, 1))
		
		result = mean_color(input)
		shouldbe = RGB(1.0, 1.0, 0.5)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa AbstractRGB)
			keep_working(md"You need to return a _color_, i.e. an object of type `RGB`. Use `RGB(r, g, b)` to create a color with channel values `r`, `g` and `b`.")
		elseif !(result == shouldbe)
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ c905b73e-ee1a-11ea-2e36-23b8e73bfdb6
if !@isdefined(quantize)
	not_defined(:quantize)
else
	let
		result = quantize(.3)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != .3
			if quantize(0.35) == .3
				almost(md"What should quantize(`0.2`) be?")
			else
				keep_working()
			end
		else
			correct()
		end
	end
end

# ╔═╡ 8cb0aee8-5774-4490-9b9e-ada93416c089
todo(text) = HTML("""<div
	style="background: rgb(220, 200, 255); padding: 2em; border-radius: 1em;"
	><h1>TODO</h1>$(repr(MIME"text/html"(), text))</div>""")

# ╔═╡ 115ded8c-ee0a-11ea-3493-89487315feb7
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 54056a02-ee0a-11ea-101f-47feb6623bec
bigbreak

# ╔═╡ e083b3e8-ed61-11ea-2ec9-217820b0a1b4
md"""
 $(bigbreak)

## **Exercise 2** - _Manipulating images_

In this exercise we will get familiar with matrices (2D arrays) in Julia, by manipulating images.
Recall that in Julia images are matrices of `RGB` color objects.

Let's load a picture of Philip again.
"""

# ╔═╡ f6cc03a0-ee07-11ea-17d8-013991514d42
md"""
 $(bigbreak)

## Exercise 3 - _More filters_

In the previous exercises, we learned how to use Julia's _dot syntax_ to apply a function _element-wise_ to an array. In this exercise, we will use this to write more image filters, that you can then apply to your own webcam image!

#### Exercise 3.1
👉 Write a function `invert` that inverts a color, i.e. sends $(r, g, b)$ to $(1 - r, 1-g, 1-b)$.
"""

# ╔═╡ 4139ee66-ee0a-11ea-2282-15d63bcca8b8
md"""
$(bigbreak)
### Camera input
"""

# ╔═╡ 87dabfd2-461e-4769-ad0f-132cb2370b88
md"""
$(bigbreak)
### Write your own filter!
"""

# ╔═╡ 91f4778e-ee20-11ea-1b7e-2b0892bd3c0f
bigbreak

# ╔═╡ dfb7c6be-ee0d-11ea-194e-9758857f7b20
function camera_input(;max_size=200, default_url="https://i.imgur.com/SUmi94P.png")
"""
<span class="pl-image waiting-for-permission">
<style>
	
	.pl-image.popped-out {
		position: fixed;
		top: 0;
		right: 0;
		z-index: 5;
	}

	.pl-image #video-container {
		width: 250px;
	}

	.pl-image video {
		border-radius: 1rem 1rem 0 0;
	}
	.pl-image.waiting-for-permission #video-container {
		display: none;
	}
	.pl-image #prompt {
		display: none;
	}
	.pl-image.waiting-for-permission #prompt {
		width: 250px;
		height: 200px;
		display: grid;
		place-items: center;
		font-family: monospace;
		font-weight: bold;
		text-decoration: underline;
		cursor: pointer;
		border: 5px dashed rgba(0,0,0,.5);
	}

	.pl-image video {
		display: block;
	}
	.pl-image .bar {
		width: inherit;
		display: flex;
		z-index: 6;
	}
	.pl-image .bar#top {
		position: absolute;
		flex-direction: column;
	}
	
	.pl-image .bar#bottom {
		background: black;
		border-radius: 0 0 1rem 1rem;
	}
	.pl-image .bar button {
		flex: 0 0 auto;
		background: rgba(255,255,255,.8);
		border: none;
		width: 2rem;
		height: 2rem;
		border-radius: 100%;
		cursor: pointer;
		z-index: 7;
	}
	.pl-image .bar button#shutter {
		width: 3rem;
		height: 3rem;
		margin: -1.5rem auto .2rem auto;
	}

	.pl-image video.takepicture {
		animation: pictureflash 200ms linear;
	}

	@keyframes pictureflash {
		0% {
			filter: grayscale(1.0) contrast(2.0);
		}

		100% {
			filter: grayscale(0.0) contrast(1.0);
		}
	}
</style>

	<div id="video-container">
		<div id="top" class="bar">
			<button id="stop" title="Stop video">✖</button>
			<button id="pop-out" title="Pop out/pop in">⏏</button>
		</div>
		<video playsinline autoplay></video>
		<div id="bottom" class="bar">
		<button id="shutter" title="Click to take a picture">📷</button>
		</div>
	</div>
		
	<div id="prompt">
		<span>
		Enable webcam
		</span>
	</div>

<script>
	// based on https://github.com/fonsp/printi-static (by the same author)

	const span = currentScript.parentElement
	const video = span.querySelector("video")
	const popout = span.querySelector("button#pop-out")
	const stop = span.querySelector("button#stop")
	const shutter = span.querySelector("button#shutter")
	const prompt = span.querySelector(".pl-image #prompt")

	const maxsize = $(max_size)

	const send_source = (source, src_width, src_height) => {
		const scale = Math.min(1.0, maxsize / src_width, maxsize / src_height)

		const width = Math.floor(src_width * scale)
		const height = Math.floor(src_height * scale)

		const canvas = html`<canvas width=\${width} height=\${height}>`
		const ctx = canvas.getContext("2d")
		ctx.drawImage(source, 0, 0, width, height)

		span.value = {
			width: width,
			height: height,
			data: ctx.getImageData(0, 0, width, height).data,
		}
		span.dispatchEvent(new CustomEvent("input"))
	}
	
	const clear_camera = () => {
		window.stream.getTracks().forEach(s => s.stop());
		video.srcObject = null;

		span.classList.add("waiting-for-permission");
	}

	prompt.onclick = () => {
		navigator.mediaDevices.getUserMedia({
			audio: false,
			video: {
				facingMode: "environment",
			},
		}).then(function(stream) {

			stream.onend = console.log

			window.stream = stream
			video.srcObject = stream
			window.cameraConnected = true
			video.controls = false
			video.play()
			video.controls = false

			span.classList.remove("waiting-for-permission");

		}).catch(function(error) {
			console.log(error)
		});
	}
	stop.onclick = () => {
		clear_camera()
	}
	popout.onclick = () => {
		span.classList.toggle("popped-out")
	}

	shutter.onclick = () => {
		const cl = video.classList
		cl.remove("takepicture")
		void video.offsetHeight
		cl.add("takepicture")
		video.play()
		video.controls = false
		console.log(video)
		send_source(video, video.videoWidth, video.videoHeight)
	}
	
	
	document.addEventListener("visibilitychange", () => {
		if (document.visibilityState != "visible") {
			clear_camera()
		}
	})


	// Set a default image

	const img = html`<img crossOrigin="anonymous">`

	img.onload = () => {
	console.log("helloo")
		send_source(img, img.width, img.height)
	}
	img.src = "$(default_url)"
	console.log(img)
</script>
</span>
""" |> HTML
end

# ╔═╡ 20402780-426b-4caa-af8f-ff1e7787b7f9
@bind cam_data camera_input()

# ╔═╡ e15ad330-ee0d-11ea-25b6-1b1b3f3d7888

function process_raw_camera_data(raw_camera_data)
	# the raw image data is a long byte array, we need to transform it into something
	# more "Julian" - something with more _structure_.
	
	# The encoding of the raw byte stream is:
	# every 4 bytes is a single pixel
	# every pixel has 4 values: Red, Green, Blue, Alpha
	# (we ignore alpha for this notebook)
	
	# So to get the red values for each pixel, we take every 4th value, starting at 
	# the 1st:
	reds_flat = UInt8.(raw_camera_data["data"][1:4:end])
	greens_flat = UInt8.(raw_camera_data["data"][2:4:end])
	blues_flat = UInt8.(raw_camera_data["data"][3:4:end])
	
	# but these are still 1-dimensional arrays, nicknamed 'flat' arrays
	# We will 'reshape' this into 2D arrays:
	
	width = raw_camera_data["width"]
	height = raw_camera_data["height"]
	
	# shuffle and flip to get it in the right shape
	reds = reshape(reds_flat, (width, height))' / 255.0
	greens = reshape(greens_flat, (width, height))' / 255.0
	blues = reshape(blues_flat, (width, height))' / 255.0
	
	# we have our 2D array for each color
	# Let's create a single 2D array, where each value contains the R, G and B value of 
	# that pixel
	
	RGB.(reds, greens, blues)
end

# ╔═╡ ed9fb2ac-2680-42b7-9b00-591e45a5e105
cam_image = process_raw_camera_data(cam_data)

# ╔═╡ d38c6958-9300-4f7a-89cf-95ca9e899c13
mean_color(cam_image)

# ╔═╡ 82f1e006-60fe-4ad1-b9cb-180fafdeb4da
invert.(cam_image)

# ╔═╡ 54c83589-b8c6-422a-b5e9-d8e0ee72a224
quantize(cam_image)

# ╔═╡ 18e781f8-66f3-4216-bc84-076a08f9f3fb
noisify(cam_image, .5)

# ╔═╡ ebf3193d-8c8d-4425-b252-45067a5851d9
[
	invert.(cam_image)      quantize(cam_image)
	noisify(cam_image, .5)  custom_filter(cam_image)
]

# ╔═╡ 8917529e-fa7a-412b-8aea-54f92f6270fa
custom_filter(cam_image)

# ╔═╡ 83eb9ca0-ed68-11ea-0bc5-99a09c68f867
md"_homework 1, version 9_"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ImageMagick = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.4"
ImageMagick = "~1.2.2"
Images = "~0.25.3"
PlutoUI = "~0.7.51"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.1"
manifest_format = "2.0"
project_hash = "75d2f93f32f5de8fb60eb1a9959386a0e17ed014"

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
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils"]
git-tree-sha1 = "ca8d917903e7a1126b6583a097c5cb7a0bedeac1"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.2"

[[deps.ImageMagick_jll]]
deps = ["JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1c0a2295cca535fabaf2029062912591e9b61987"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.10-12+3"

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
# ╟─ac8ff080-ed61-11ea-3650-d9df06123e1f
# ╟─5f95e01a-ee0a-11ea-030c-9dba276aba92
# ╠═65780f00-ed6b-11ea-1ecf-8b35523a7ac0
# ╟─54056a02-ee0a-11ea-101f-47feb6623bec
# ╟─540ccfcc-ee0a-11ea-15dc-4f8120063397
# ╟─467856dc-eded-11ea-0f83-13d939021ef3
# ╠═56ced344-eded-11ea-3e81-3936e9ad5777
# ╟─ad6a33b0-eded-11ea-324c-cfabfd658b56
# ╠═f51333a6-eded-11ea-34e6-bfbb3a69bcb0
# ╟─b18e2c54-edf1-11ea-0cbf-85946d64b6a2
# ╟─397941fc-edee-11ea-33f2-5d46c759fbf7
# ╟─b1d5ca28-edf6-11ea-269e-75a9fb549f1d
# ╟─5da8cbe8-eded-11ea-2e43-c5b7cc71e133
# ╟─77adb065-bfd4-4680-9c2a-ad4d92689dbf
# ╠═bd907ee1-5253-4cae-b5a5-267dac24362a
# ╠═6640110a-d171-4b32-8d12-26979a36b718
# ╟─e0bfc973-2808-4f84-b065-fb3d05401e30
# ╟─24090306-7395-4f2f-af31-34f7486f3945
# ╟─cf738088-eded-11ea-2915-61735c2aa990
# ╠═0ffa8354-edee-11ea-2883-9d5bfea4a236
# ╠═1f104ce4-ee0e-11ea-2029-1d9c817175af
# ╟─38dc80a0-edef-11ea-10e9-615255a4588c
# ╟─1f229ca4-edee-11ea-2c56-bb00cc6ea53c
# ╠═2a391708-edee-11ea-124e-d14698171b68
# ╟─2b1ccaca-edee-11ea-34b0-c51659f844d0
# ╟─e2863d4c-edef-11ea-1d67-332ddca03cc4
# ╟─ea8d92f8-159c-4161-8c54-bab7bc00f290
# ╠═ec5efe8c-edef-11ea-2c6f-afaaeb5bc50c
# ╟─d6ddafdd-1a44-48c7-b49a-554073cdf331
# ╟─29e10640-edf0-11ea-0398-17dbf4242de3
# ╠═1267e961-5b75-4b55-8080-d45316a03b9b
# ╠═38155b5a-edf0-11ea-3e3f-7163da7433fb
# ╟─adf476d8-a334-4b35-81e8-cc3b37de1f28
# ╟─a5f8bafe-edf0-11ea-0da3-3330861ae43a
# ╠═b6b65b94-edf0-11ea-3686-fbff0ff53d08
# ╠═4a5e9d2c-dd90-4bb0-9e31-3f5c834406b4
# ╟─d862fb16-edf1-11ea-36ec-615d521e6bc0
# ╟─aa1ff74a-4e78-4ef1-8b8d-3a60a168cf6d
# ╟─e3394c8a-edf0-11ea-1bb8-619f7abb6881
# ╟─e083b3e8-ed61-11ea-2ec9-217820b0a1b4
# ╠═59414833-a108-4b1e-9a34-0f31dc907c6e
# ╠═c5484572-ee05-11ea-0424-f37295c3072d
# ╠═c8ecfe5c-ee05-11ea-322b-4b2714898831
# ╟─e86ed944-ee05-11ea-3e0f-d70fc73b789c
# ╠═6ccd8902-0dd9-4335-a11a-ee7f9a1a6c09
# ╟─15088baa-c337-405d-8885-19a6e2bfd6aa
# ╠═7ad4f6bc-588e-44ab-8ca9-c87cd1048442
# ╟─a55bb5ca-600b-4aa0-b95f-7ece20845c9b
# ╠═c5dc0cc8-9305-47e6-8b20-a9f8ef867799
# ╠═de772e21-0bea-4fd2-868a-9a7d32550bc9
# ╟─21bdc692-91ee-474d-ae98-455913a2342e
# ╠═2ae3f379-96ce-435d-b863-deba4586ec71
# ╟─c49ba901-d798-489a-963c-4cc113c7abfd
# ╠═93451c37-77e1-4d4f-9788-c2a3da1401ee
# ╟─f52e4914-2926-4a42-9e45-9caaace9a7db
# ╠═a8b2270a-600c-4f83-939e-dc5ab35f4735
# ╠═c320b39d-4cea-4fa1-b1ce-053c898a67a6
# ╟─09102183-f9fb-4d89-b4f9-5d76af7b8e90
# ╟─d8cf9bd5-dbf7-4841-acf9-eef7e7cabab3
# ╠═ebe1d05c-f6aa-437d-83cb-df0ba30f20bf
# ╟─c427554a-6f6a-43f1-b03b-f83239887cee
# ╟─63ac142e-6d9d-4109-9286-030a02c900b4
# ╟─50e2b0fb-b06d-4ac1-bdfb-eab833466736
# ╟─4fd07e01-2f8b-4ec9-9f4f-8a9e5ff56fb6
# ╠═97c15896-6d99-4292-b7d7-4fcd2353656f
# ╠═cbb9bf41-4c21-42c7-b0e0-fc1ce29e0eb1
# ╟─3f1a670b-44c2-4cab-909c-65f4ae9ed14b
# ╠═21ba6e75-55a2-4614-9b5d-ea6378bf1d98
# ╟─f7825c18-ff28-4e23-bf26-cc64f2f5049a
# ╠═d994e178-78fd-46ab-a1bc-a31485423cad
# ╟─c54ccdea-ee05-11ea-0365-23aaf053b7d7
# ╠═f6898df6-ee07-11ea-2838-fde9bc739c11
# ╠═5be9b144-ee0d-11ea-2a8d-8775de265a1d
# ╟─4d0158d0-ee0d-11ea-17c3-c169d4284acb
# ╟─5f6635b4-63ed-4a62-969c-bd4084a8202f
# ╟─f6cc03a0-ee07-11ea-17d8-013991514d42
# ╠═63e8d636-ee0b-11ea-173d-bd3327347d55
# ╟─80a4cb23-49c9-4446-a3ec-b2203128dc27
# ╟─2cc2f84e-ee0d-11ea-373b-e7ad3204bb00
# ╠═b8f26960-ee0a-11ea-05b9-3f4bc1099050
# ╠═5de3a22e-ee0b-11ea-230f-35df4ca3c96d
# ╠═4e21e0c4-ee0b-11ea-3d65-b311ae3f98e9
# ╠═6dbf67ce-ee0b-11ea-3b71-abc05a64dc43
# ╟─846b1330-ee0b-11ea-3579-7d90fafd7290
# ╠═943103e2-ee0b-11ea-33aa-75a8a1529931
# ╟─55b138b7-19fb-4da1-9eb1-1e8304528251
# ╟─f68d4a36-ee07-11ea-0832-0360530f102e
# ╠═fbd1638d-8d7a-4d12-aff9-9c160cc3fd74
# ╠═f6a655f8-ee07-11ea-13b6-43ca404ddfc7
# ╟─c905b73e-ee1a-11ea-2e36-23b8e73bfdb6
# ╟─7720740e-2d2b-47f7-98fd-500ed3eee479
# ╠═90421bca-0804-4d6b-8bd0-3ddbd54cc5fe
# ╠═b2329e4c-6204-453e-8998-2414b869b808
# ╟─23fcd65f-0182-41f3-80ec-d85b05136c47
# ╠═5055b74c-b98d-41fa-a0d8-cb36200d82cc
# ╠═8db17b2b-0cf9-40ba-8f6f-2e53be7b6355
# ╟─a8a597e0-a01c-40cd-9902-d56430afd938
# ╟─f6b218c0-ee07-11ea-2adb-1968c4fd473a
# ╠═04e6b486-ceb7-45fe-a6ca-733703f16357
# ╟─a6d9635b-85ed-4590-ad09-ca2903ea8f1d
# ╟─f6bf64da-ee07-11ea-3efb-05af01b14f67
# ╠═13e9ec8d-f615-4833-b1cf-0153010ccb65
# ╟─25dad7ce-ee0b-11ea-3e20-5f3019dd7fa3
# ╠═9751586e-ee0c-11ea-0cbb-b7eda92977c9
# ╟─f6d6c71a-ee07-11ea-2b63-d759af80707b
# ╠═f38b198d-39cf-456f-a841-1ba08f206010
# ╠═1ea53f41-b791-40e2-a0f8-04e13d856829
# ╟─31ef3710-e4c9-4aa7-bd8f-c69cc9a977ee
# ╟─f6ef2c2e-ee07-11ea-13a8-2512e7d94426
# ╟─f6fc1312-ee07-11ea-39a0-299b67aee3d8
# ╠═d56a7ebc-5874-45d8-b348-ec5b8c4f9b9c
# ╠═db4bad9f-df1c-4640-bb34-dd2fe9bdce18
# ╟─0000b7f8-4c43-4dd8-8665-0dfe59e74c0a
# ╠═774b4ce6-ee1b-11ea-2b48-e38ee25fc89b
# ╠═7e4aeb70-ee1b-11ea-100f-1952ba66f80f
# ╟─48de5bc2-72d3-11eb-3fd9-eff2b686cb75
# ╠═8e848279-1b3e-4f32-8c0c-45693d12de96
# ╟─f70823d2-ee07-11ea-2bb3-01425212aaf9
# ╠═21a5885d-00ab-428b-96c3-c28c98c4ca6d
# ╟─d896b7fd-20db-4aa9-bbcf-81b1cd44ec46
# ╠═e70a84d4-ee0c-11ea-0640-bf78653ba102
# ╠═ac15e0d0-ee0c-11ea-1eaf-d7f88b5df1d7
# ╟─9604bc44-ee1b-11ea-28f8-7f7af8d0cbb2
# ╟─f714699e-ee07-11ea-08b6-5f5169861b57
# ╟─bdc2df7c-ee0c-11ea-2e9f-7d2c085617c1
# ╟─4139ee66-ee0a-11ea-2282-15d63bcca8b8
# ╠═20402780-426b-4caa-af8f-ff1e7787b7f9
# ╟─ed9fb2ac-2680-42b7-9b00-591e45a5e105
# ╟─e87e0d14-43a5-490d-84d9-b14ece472061
# ╠═d38c6958-9300-4f7a-89cf-95ca9e899c13
# ╠═82f1e006-60fe-4ad1-b9cb-180fafdeb4da
# ╠═54c83589-b8c6-422a-b5e9-d8e0ee72a224
# ╠═18e781f8-66f3-4216-bc84-076a08f9f3fb
# ╠═ebf3193d-8c8d-4425-b252-45067a5851d9
# ╟─87dabfd2-461e-4769-ad0f-132cb2370b88
# ╠═8917529e-fa7a-412b-8aea-54f92f6270fa
# ╠═d688c7e9-9f1e-4eb9-a71d-8709eab4e24e
# ╠═ee5f21fb-1076-42b6-8926-8bbb6ed0ad67
# ╠═9e5a08dd-332a-486b-94ab-15c49e72e522
# ╟─91f4778e-ee20-11ea-1b7e-2b0892bd3c0f
# ╟─756d150a-b7bf-4bf5-b372-5b0efa80d987
# ╟─4bc94bec-da39-4f8a-82ee-9953ed73b6a4
# ╟─8ce6ad06-819c-4af5-bed7-56ecc08c97be
# ╟─dfa40e89-03fc-4a7a-825e-92d67ee217b2
# ╟─086ec1ff-b62d-4566-9973-5b2cc3353409
# ╟─2f6fb3a6-bb5d-4c7a-9297-84dd4b16c7c3
# ╟─c22f688b-dc04-4a94-b541-fe06266c5446
# ╟─ab3d1b70-88e8-4118-8d3e-601a8a68f72d
# ╟─8cb0aee8-5774-4490-9b9e-ada93416c089
# ╟─115ded8c-ee0a-11ea-3493-89487315feb7
# ╟─dfb7c6be-ee0d-11ea-194e-9758857f7b20
# ╟─e15ad330-ee0d-11ea-25b6-1b1b3f3d7888
# ╟─83eb9ca0-ed68-11ea-0bc5-99a09c68f867
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
