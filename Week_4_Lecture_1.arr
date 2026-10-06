use context dcic2024

include csv 

#filter-with

#compute-sum(2, 6)

#higher-order function, it takes a function as one of its arguments

#filter-with(function)

orders = table: time, amount
  row: "08:00", 10.50
  row: "09:30", 5.75 #index 2
  row: "10:15", 8.00 #index 3
  row: "11:00", 3.95 #index 4
  row: "14:00", 4.95
  row: "16:00", 12.00
end
orders 
fun is-high-value(o :: Row) -> Boolean:
  o["amount"] >= 8.0
where: 
  is-high-value(orders.row-n(2)) is true
  is-high-value(orders.row-n(4)) is false
end

fun compute-sum(f-number :: Number, s-number :: Number) -> Number:
  doc: "this fuction takes 2 numbers and compute their sum"
  f-number + s-number
where:
  compute-sum(2, 3) is 5
  compute-sum(9, 9) is 18
  compute-sum(6, 7) is 13
end

new-high-orders = filter-with(orders, is-high-value)

high-value-orders = table: time, amount
  row:"08:00", 10.50
  row:"10:15", 8.00
  row: "16:00", 12
end

check:
  new-high-orders is high-value-orders
end