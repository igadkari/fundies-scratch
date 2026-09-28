use context starter2024
# t-shirt cost

#cost of 5 shirts 
(12 * 5) + 3
#cost of 7 shirts
(12 * 7) + 3

# Rectangular Poster
#perimeter
perimeter = 2 * (420 + 592)
# cost
perimeter * 0.10
#if you forget the parenthesis, it will double only the width. 

# String Surprises
string-Tagline = "Designs for everyone!"
string-Tagline

# Color Inventory
string-red = "red"
string-blue = "blue"
string-color = "red" + "blue"
string-color
# if you add a '+' in between the colors, it combines the names of the colors, it doesn't mix them as you would expect. 

#string-number-color = 1 + "blue"
#string-number-color
# you cannot have a number and a string together. I turned it into a comment after I ran it so that I can continue with the Lab assignment. 

# Traffic Light

above(
  overlay-align("middle", "middle",
    above(
      circle(15, "solid", "red"), 
      above(circle(15, "solid", "yellow"), 
        circle(15, "solid", "green"))
      ),
    rectangle(40, 100, "solid", "black")
    ),
  rectangle(10, 60, "solid", "gray")
  )

#Broken Code
# Goal: A rectangle with width 50 and height 20, solid black
rectangle(50,20, "solid", "black")

circle(30, "solid", "red")


#Flag
place-image-align(
  star(20,"solid","red"),
  0,0,"left","top",
  place-image-align(
    rectangle(20,100,"solid","yellow"),
    150,0,"right","top",
    rectangle(150,100, "solid", "green")))

#shield
overlay(star(30,"solid","gold"),rotate(45, square(100, "solid", "gray")))