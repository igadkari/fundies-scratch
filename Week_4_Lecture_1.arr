use context dcic2024
include csv
include data-source

#Filter-with

orders = table: time, amount
  row: "08:00", 10.50
  row: "09:30", 5.75
  row: "10:15", 8.00
  row: "11:00", 3.95
  row: "14:00", 4.95
  row: "16:00", 12.00
end

fun is-high-value(o :: Row) -> Boolean:
  o["amount"] >= 8.0
where:
  is-high-value(orders.row-n(2)) is true
  is-high-value(orders.row-n(4)) is false
end

fun compute-sum(f-number :: Number, s-number :: Number) -> Number:
  doc: "this function takes 2 numbers and computes their sum"
  f-number + s-number
where:
  compute-sum(2, 3) is 5
  compute-sum(9, 9) is 18
  compute-sum(6, 7) is 13
end

new-high-orders = filter-with(orders, is-high-value)

high-value-orders = table: time, amount
  row: "08:00", 10.50
  row: "10:15", 8.00
  row: "16:00", 12.00
end

check:
  new-high-orders is high-value-orders
end

filter-with(orders, lam(o):
  o["amount"] >= 8.0
end)


#Order-by

order-by(orders, "amount", true)
order-by(orders, "amount", false)


#Class Exercises 

fun is-morning(o :: Row) -> Boolean:
  o["time"] < "12:00"
end

morning-orders = filter-with(orders, is-morning)

morning-orders-2 = filter-with(orders, lam(o):
  o["time"] < "12:00"
end)

latest-orders = order-by(orders, "time", false)

morning-orders-sorted = order-by(morning-orders, "time", false)

latest-morning = morning-orders-sorted.row-n(0)["amount"]


#Loading Data 

photos = load-table:
  Date :: String,
  Location :: String,
  Subject :: String
  source: csv-table-url("https://raw.githubusercontent.com/NU-London/LCSCI4207-datasets/refs/heads/main/photos.csv")
end

# Forest photos
forest-photos = filter-with(photos, lam(r):
  r["Subject"] == "Forest"
end)

# Order Forest photos by date
forest-by-date = order-by(forest-photos, "Date", false)

# Location of most recent Forest photo
most-recent-location = forest-by-date.row-n(0)["Location"]

# Count photos at each location
location-counts = photos.count("Location")

# Order locations by number of photos
most-photos = order-by(location-counts, "count", false)

# Frequency bar chart
frequency-bar-chart(photos, "Location")
