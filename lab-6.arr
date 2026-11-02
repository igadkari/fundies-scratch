use context dcic2024

#Task 1 - Expressions (Week 1)
# 1. The cost of a 25-minute ride at £0.15 a minute
# i think this will give 3.75
25 * 0.15

# 2. Joining the strings
# i think this will give "Electric bike"
"Electric" + " " + "bike"

# 3. Finding the length of "handlebar"
# I think this will give 9
string-length("handlebar")

# check it
check: 
  25 * 0.15 is 3.75
  "Electric" + " " + "bike" is "Electric bike"
  string-length("handlebar") is 9
end




#Task 2 - Definitions and Functions (Week 2)
# 1. Define minute-rate
minute-rate :: Number = 0.15

# 2. Design ride-cost
# ride-cost: Number Number -> Number
# This will calculate the total cost of a ride using minutes and price per minute.
fun ride-cost(minutes, rate):
  doc: "This will calculate the total cost of a ride using minutes and price per minute"
  minutes * rate
where:
  ride-cost(25, 0.15) is 3.75
  ride-cost(30, minute-rate) is 4.5
  ride-cost(40, minute-rate) is 6
end




#Task 3 - Conditionals and Tests (Week 3) 
# ride-discount: Number -> Number
# This will give the discount based on the length of the ride
fun ride-discount(minutes):
  doc: "this will return the discount based on the length of the rides"
  if minutes < 30:
    0
  else if minutes < 60:
    0.1
  else:
    0.2
  end
where:
  ride-discount(29) is 0
  ride-discount(30) is 0.1
  ride-discount(59) is 0.1
  ride-discount(60) is 0.2
end



#Task 4 - Tables (Weeks 3 and 4)
#Below is the table that was asked to be copied
rides = table: rider, minutes, rate
  row: "Ella", 20, 0.15
  row: "Farid", 45, 0.10
  row: "Grace", 70, 0.10
  row: "Hugo", 10, 0.20
end

# 1. Add a column for the cost
rides-with-cost = build-column(rides, "cost", lam(row):
  row["minutes"] * row["rate"]
end)
rides-with-cost

# 2. make a filter using filter-with to show only the rides that are longer than 30 minutes. 
long-rides = filter-with(rides-with-cost, lam(row):
  row["minutes"] >= 30
end)
long-rides



#Task 5 - Lists, Loops, and Fold (Week 5)
# 1. Get the minutes column as a list
minutes-list = rides.get-column("minutes")

# 2. Add up a list using a loop
# total-minutes-loop: List<Number> -> Number
# Adds all the numbers in a list using a loop.
fun total-minutes-loop(numbers):
  doc: "Adds all numbers in a list using a loop"
  block:
    var total = 0
    for each(n from numbers):
      total := total + n
    end
    total
  end
where:
  total-minutes-loop([list: 20, 45, 70, 10]) is 145
end

# 3. Add up a list using fold
# total-minutes-fold: List<Number> -> Number
# Adds all the numbers in a list using fold.
fun total-minutes-fold(numbers):
  doc: "Adds all the numbers in a list using a fold"
  fold(lam(n, total): n + total end, 0, numbers)
where:
  total-minutes-fold([list: 20, 45, 70, 10]) is 145
end

# 4. Check that both give the same answer
check:
  total-minutes-loop(minutes-list) is total-minutes-fold(minutes-list)
end





#Task 6 - Structured Data and Recurstion (Week 6)
#Below is the pasted code from the assignment for the data definition
data Ride:
  | pedal-bike(minutes :: Number)
  | e-bike(minutes :: Number, has-pass :: Boolean)
end

# 1. Design function that returns battery fee in pounds
# battery-fee: Ride -> Number
# Calculates the battery fee for an e-bike without monthly pass.
fun battery-fee(ride):
  cases (Ride) ride:
    | pedal-bike(minutes) => 0
    | e-bike(minutes, has-pass) =>
      if has-pass:
        0
      else:
        minutes * 0.05
      end
  end
where:
  battery-fee(pedal-bike(20)) is 0
  battery-fee(e-bike(30, false)) is 1.5
  battery-fee(e-bike(30, true)) is 0
end

# 2. Design function that adds up a list using recursion. 
# total-minutes-rec: List<Number> -> Number
# Adds all the numbers in a list using recursion.
fun total-minutes-rec(numbers):
  cases (List) numbers:
    | empty => 0
    | link(first, rest) =>
      first + total-minutes-rec(rest)
  end
where:
  total-minutes-rec(empty) is 0
  total-minutes-rec([list: 20, 45, 70, 10]) is 145
end