use context dcic2024

include csv
include data-source

# load the flights table
flights = load-table:
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
  source: csv-table-file("flights.csv", default-options)
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
end


# exercise 1
fun is_long_flight(row :: Row) -> Boolean:
  doc: "Checks whether a flight travels at least 1500 miles."
  row["distance"] >= 1500
end

long_flights = filter-with(flights, is_long_flight)

# sort by airtime, longest first
long_flights_sorted = order-by(long_flights, "air_time", false)

longest_flight = long_flights_sorted.row-n(0)

longest_carrier = longest_flight["carrier"]
longest_origin = longest_flight["origin"]
longest_dest = longest_flight["dest"]


# exercise 2
fun is_delayed_departure(row :: Row) -> Boolean:
  doc: "Checks whether departure was delayed by at least 30 minutes."
  row["dep_delay"] >= 30
end

fun is_morning_sched_dep(row :: Row) -> Boolean:
  doc: "Checks whether scheduled departure is before noon."
  row["sched_dep_time"] < 1200
end

# filter delayed flights
delayed_flights = filter-with(
  flights,
  lam(row): row["dep_delay"] >= 30 end
)

# keep morning flights
morning_delayed_flights = filter-with(
  delayed_flights,
  lam(row): row["sched_dep_time"] < 1200 end
)

# keep flights over 500 miles
long_morning_delays = filter-with(
  morning_delayed_flights,
  lam(row): row["distance"] > 500 end
)

# sort by delay, worst first
worst_delays = order-by(long_morning_delays, "dep_delay", false)

worst_delayed_flight = worst_delays.row-n(0)

worst_flight_number = worst_delayed_flight["flight"]
worst_flight_origin = worst_delayed_flight["origin"]
worst_flight_delay = worst_delayed_flight["dep_delay"]


# exercise 3

# replace negative departure delays with 0
cleaned_departure_delays = transform-column(
  flights,
  "dep_delay",
  lam(delay :: Number):
    if delay < 0:
      0
    else:
      delay
    end
  end
)

# replace negative arrival delays with 0
cleaned_flights = transform-column(
  cleaned_departure_delays,
  "arr_delay",
  lam(delay :: Number):
    if delay < 0:
      0
    else:
      delay
    end
  end
)

# calculate effective speed
flights_with_speed = build-column(
  cleaned_flights,
  "effective_speed",
  lam(row :: Row):
    if row["air_time"] > 0:
      row["distance"] / (row["air_time"] / 60)
    else:
      0
    end
  end
)

# sort by speed, fastest first
fastest_flights = order-by(
  flights_with_speed,
  "effective_speed",
  false
)

fastest_flight = fastest_flights.row-n(0)

fastest_carrier = fastest_flight["carrier"]
fastest_origin = fastest_flight["origin"]
fastest_dest = fastest_flight["dest"]


# exercise 4
fun apply-arrival-discount(t :: Table) -> Table:
  doc: "Reduces arrival delays by 20% when the delay is between 0 and 45 minutes."
  transform-column(
    t,
    "arr_delay",
    lam(delay :: Number):
      if (delay >= 0) and (delay <= 45):
        delay * 0.8
      else:
        delay
      end
    end
  )
where:
  test-table = table:
    arr_delay :: Number
    row: -10
    row: 0
    row: 30
    row: 60
  end

  apply-arrival-discount(test-table) is table:
    arr_delay :: Number
    row: -10
    row: 0
    row: 24
    row: 60
  end
end

# apply the discount to flights
discounted_flights = apply-arrival-discount(flights)

# calculate the on-time score
# treat negative delays as 0
flights_with_score = build-column(
  discounted_flights,
  "on_time_score",
  lam(row :: Row):
    dep =
      if row["dep_delay"] < 0:
        0
      else:
        row["dep_delay"]
      end

    arr =
      if row["arr_delay"] < 0:
        0
      else:
        row["arr_delay"]
      end

    score = 100 - (dep - arr) - (row["air_time"] / 30)

    if score < 0:
      0
    else:
      score
    end
  end
)

# sort by distance first, then score
score_sorted = order-by(
  order-by(flights_with_score, "distance", true),
  "on_time_score",
  false
)

# get the top two flights
top_flight_1 = score_sorted.row-n(0)
top_flight_2 = score_sorted.row-n(1)

top_carrier_1 = top_flight_1["carrier"]
top_flight_number_1 = top_flight_1["flight"]
top_origin_1 = top_flight_1["origin"]
top_dest_1 = top_flight_1["dest"]

top_carrier_2 = top_flight_2["carrier"]
top_flight_number_2 = top_flight_2["flight"]
top_origin_2 = top_flight_2["origin"]
top_dest_2 = top_flight_2["dest"]


# optional question
# I don't think this is completely fair because longer flights
# lose more points from the airtime part of the formula.
# One alternative is to score delays as a percentage of the
# flight time, so short and long flights can be compared more fairly.