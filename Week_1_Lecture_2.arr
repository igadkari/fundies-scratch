use context starter2024

a = 'Hello World'
b = a + ' '

string-length(a)
string-repeat(a, 3)


"CS" + "2000"

# to convert all string characters to upper case
string-to-upper("hello CS2000!") # -> HELLO CS2000!
string-toupper("Hello CS2000!") # -> HELLO CS2000!

# to convert all string characters to lower case
string-to-lower("WELCOME TO CS2000!")

# to get a substring 
string-substring("Welcome to London", 0, 7) # -> Welcome

sample_string = "My name is Ira, and I am from Southern California"

# to check if certain characters exist in a string
string-contains(sample_string, "Ira")
string-contains(sample_string, "ira")

#practice changing a string to upper/lower, then seeing if the string contains something
sample_string_Turbo = "Hello, Turbo is a black lab and he is 2 years old"
upper_string = string-toupper(sample_string_Turbo)
string-contains(upper_string, "TURBO")

# Create shapes with different colors, sizes, and opacity
circle(30, "solid", 'blue')
rectangle(20,40, "solid", "yellow")
triangle(30,"outline","orange")

#composition, each of these would take 2 images and gives back 1 image

#overlay((first image), (second image))
overlay(circle(30, "solid", "blue"), rectangle(80,60, "solid", "yellow"))

#above((first image), (second image))
above(circle(40, "outline", "orange"), triangle(40, "solid", "pink"))

#below((first image), (second image))
below(square(30, "solid", "purple"), circle(40, "solid", "white"))

#beside((first image), (second image))
beside(rectangle(40,90, "solid", "blue"), triangle(40, "outline", "green"))

#create a stop sign
#regular-polygon(side-length, side-count, mode, color)
overlay-align("middle", "middle",text("STOP", 30, "white"), overlay(regular-polygon(40, 8, "solid", "red"), regular-polygon(46, 8, "solid", "white")))