use context dcic2024
include csv
include data-source

import math as M
import statistics as S


# Task 1: Plan

# input = flight data from the CSV file
# output = cleaned flights, duplicate counts, charts and statistics
# steps = load and clean data, create dedup_key, count duplicates,
# add airline names, filter outliers, create charts and calculate statistics


# Task 2: Load, clean and identify duplicate flights

# Load flight data

flights_53 = load-table:
  rownames :: Number,
  dep_time :: Number,
  sched_dep_time :: Number,
  dep_delay :: Number,
  arr_time :: Number,
  sched_arr_time :: Number,
  arr_delay :: Number,
  carrier :: String,
  flight :: Number,
  tailnum :: String,
  origin :: String,
  dest :: String,
  air_time :: Number,
  distance :: Number,
  hour :: Number,
  minute :: Number,
  time_hour :: String
  source: csv-table-file("flights_sample53.csv", default-options)
  sanitize rownames using num-sanitizer
  sanitize dep_time using num-sanitizer
  sanitize sched_dep_time using num-sanitizer
  sanitize dep_delay using num-sanitizer
  sanitize arr_time using num-sanitizer
  sanitize sched_arr_time using num-sanitizer
  sanitize arr_delay using num-sanitizer
  sanitize flight using num-sanitizer
  sanitize air_time using num-sanitizer
  sanitize distance using num-sanitizer
  sanitize hour using num-sanitizer
  sanitize minute using num-sanitizer
  sanitize carrier using string-sanitizer
  sanitize tailnum using string-sanitizer
  sanitize origin using string-sanitizer
  sanitize dest using string-sanitizer
  sanitize time_hour using string-sanitizer
end


# Replace missing tail numbers

flights-with-tailnum = transform-column(
  flights_53,
  "tailnum",
  lam(tail):
    if tail == "":
      "UNKNOWN"
    else:
      tail
    end
  end
)


# Fix negative departure delays

flights-clean-dep = transform-column(
  flights-with-tailnum,
  "dep_delay",
  lam(delay):
    if delay < 0:
      0
    else:
      delay
    end
  end
)


# Fix negative arrival delays

flights-clean = transform-column(
  flights-clean-dep,
  "arr_delay",
  lam(delay):
    if delay < 0:
      0
    else:
      delay
    end
  end
)


# Remove spaces from strings

fun trim(s :: String) -> String:
  doc: "removes spaces from a string"
  string-replace(s, " ", "")
where:
  trim(" b6 ") is "b6"
  trim("UA") is "UA"
  trim("") is ""
end


# Format departure time as HH:MM

fun format-time(t :: Number) -> String:
  doc: "converts a numeric time into HH:MM format"
  hours = num-floor(t / 100)
  minutes = t - (hours * 100)
  hour-text =
    if hours < 10:
      string-append("0", num-to-string(hours))
    else:
      num-to-string(hours)
    end
  minute-text =
    if minutes < 10:
      string-append("0", num-to-string(minutes))
    else:
      num-to-string(minutes)
    end
  string-append(
    string-append(hour-text, ":"),
    minute-text
  )
where:
  format-time(517) is "05:17"
  format-time(1800) is "18:00"
  format-time(45) is "00:45"
end


# Create dedup_key

flights-with-key = build-column(
  flights-clean,
  "dedup_key",
  lam(r):
    flight-text = num-to-string(r["flight"])
    carrier-text = string-to-upper(trim(r["carrier"]))
    time-text = format-time(r["dep_time"])
    string-append(
      string-append(
        string-append(flight-text, "-"),
        string-append(carrier-text, "-")
      ),
      time-text
    )
  end
)


# Group and count duplicate keys

grouped-flights = group(flights-with-key, "dedup_key")

duplicate-counts = count(flights-with-key, "dedup_key")

duplicates = filter-with(
  duplicate-counts,
  lam(r): r["count"] > 1 end
)


# Task 3: Add airline names and filter outliers

# Convert carrier codes to airline names

fun airline-name(carrier :: String) -> String:
  doc: "returns the full airline name for a carrier code"
  code = string-to-upper(trim(carrier))
  if code == "UA":
    "United Airlines"
  else if code == "AA":
    "American Airlines"
  else if code == "B6":
    "JetBlue"
  else if code == "DL":
    "Delta Air Lines"
  else if code == "EV":
    "ExpressJet"
  else if code == "WN":
    "Southwest Airlines"
  else if code == "OO":
    "SkyWest Airlines"
  else:
    "Other"
  end
where:
  airline-name("UA") is "United Airlines"
  airline-name(" b6 ") is "JetBlue"
  airline-name("WN") is "Southwest Airlines"
  airline-name("XX") is "Other"
end


# Add airline column

flights-with-airline = build-column(
  flights-with-key,
  "airline",
  lam(r):
    airline-name(r["carrier"])
  end
)


# Remove unrealistic distances and air times

flights-no-outliers = filter-with(
  flights-with-airline,
  lam(r):
    (r["distance"] <= 5000) and (r["air_time"] <= 500)
  end
)


# Task 4: Create charts and calculate statistics

# Chart of flights by airline

airline-chart = freq-bar-chart(
  flights-with-airline,
  "airline"
)


# Get the distance column

distance-list = flights-no-outliers.get-column("distance")


# Histogram of flight distances

distance-histogram = histogram(
  flights-no-outliers,
  "distance",
  10
)


# Scatter plot of air time versus distance

airtime-distance-plot = scatter-plot(
  flights-no-outliers,
  "air_time",
  "distance"
)


# Calculate total distance

fun my-sum(num-list :: List<Number>) -> Number block:
  doc: "calculates the total of a list of numbers"
  var total = 0
  for each(n from num-list):
    total := total + n
  end
  total
where:
  my-sum([list: 1, 2, 3]) is 6
  my-sum([list: ]) is 0
end

total-distance = my-sum(distance-list)


# Calculate average distance

average-distance = block:
  var total = 0
  for each(n from distance-list):
    total := total + n
  end
  if length(distance-list) > 0:
    total / length(distance-list)
  else:
    0
  end
end


# Find maximum distance

maximum-distance = block:
  var maximum = 0
  for each(n from distance-list):
    if n > maximum:
      maximum := n
    else:
      maximum := maximum
    end
  end
  maximum
end

# Checking if the duplicates run correctly
duplicates
total-distance
average-distance
maximum-distance