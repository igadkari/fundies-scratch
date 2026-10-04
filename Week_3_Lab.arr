use context starter2024
# Problem 1
# Checks if a year is a leap year
fun leap-year(year :: Number) -> Boolean:
  doc: ```Returns true if the year is a leap year and false otherwise.```
  if num-modulo(year, 400) == 0:
    true
  else if num-modulo(year, 100) == 0:
    false
  else:
    num-modulo(year, 4) == 0
  end
where:
  leap-year(2000) is true
  leap-year(1900) is false
  leap-year(2024) is true
  leap-year(2023) is false
end


# Problem 2
# Returns the next second
fun tick(seconds :: Number) -> Number:
  doc: ```Returns the next second, or 0 after 59.```
  if seconds == 59:
    0
  else:
    seconds + 1
  end
where:
  tick(0) is 1
  tick(30) is 31
  tick(58) is 59
  tick(59) is 0
end


# Problem 3
# Determines the winner of rock-paper-scissors
fun rock-paper-scissors(player1 :: String, player2 :: String) -> String:
  doc: ```Returns the winner of a rock-paper-scissors game.```
  if player1 == "rock":
    if player2 == "rock":
      "tie"
    else if player2 == "scissors":
      "player 1"
    else if player2 == "paper":
      "player 2"
    else:
      "invalid choice"
    end
  else if player1 == "paper":
    if player2 == "paper":
      "tie"
    else if player2 == "rock":
      "player 1"
    else if player2 == "scissors":
      "player 2"
    else:
      "invalid choice"
    end
  else if player1 == "scissors":
    if player2 == "scissors":
      "tie"
    else if player2 == "paper":
      "player 1"
    else if player2 == "rock":
      "player 2"
    else:
      "invalid choice"
    end
  else:
    "invalid choice"
  end
where:
  rock-paper-scissors("rock", "rock") is "tie"
  rock-paper-scissors("rock", "scissors") is "player 1"
  rock-paper-scissors("scissors", "rock") is "player 2"
  rock-paper-scissors("paper", "rock") is "player 1"
  rock-paper-scissors("rock", "paper") is "player 2"
  rock-paper-scissors("banana", "rock") is "invalid choice"
end


# Problem 4
# Stores the distances of planets from the Sun
planets =
  table: Planet :: String, Distance :: Number
    row: "Mercury", 0.39
    row: "Venus", 0.72
    row: "Earth", 1
    row: "Mars", 1.52
    row: "Jupiter", 5.2
    row: "Saturn", 9.54
    row: "Uranus", 19.2
    row: "Neptune", 30.06
  end

# Extracts row 3
mars = planets.row-n(3)

# Gets the distance from Mars
mars-distance = mars["Distance"]