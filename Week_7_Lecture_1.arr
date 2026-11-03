use context dcic2024
week-temps = [list: 28, 31, 34, 29, 30, 26, 32]
co2 = [list: 411.65, 414.21, 416.41, 418.53, 421.08, 424.61, 427.35]

# selection by value: the hot days
fun hot-days(temps :: List<Number>) -> List<Number>:
  doc: "Keeps temperatures of 30 or higher"
  cases (List) temps:
    | empty => empty
    | link(f, r) =>
      if f >= 30:
        link(f, hot-days(r))
      else:
        hot-days(r)
      end
  end
where:
  hot-days(week-temps) is [list: 31, 34, 30, 32]
  hot-days([list: 29, 25]) is [list: ]
  hot-days([list: ]) is [list: ]
end

# selection by position: how much did CO2 rise each year?
fun yearly-rise(levels :: List<Number>) -> List<Number>:
  doc: "Calculates how much each level rose from the one before it"
  cases (List) levels:
    | empty => empty
    | link(f, r) =>
      cases (List) r:
        | empty => empty
        | link(next-year, rest) =>
          link(next-year - f, yearly-rise(r))
      end
  end
where:
  yearly-rise(co2) is [list: 2.56, 2.2, 2.12, 2.55, 3.53, 2.74]
  yearly-rise([list: 411.65, 414.21, 416.41]) is [list: 2.56, 2.2]
  yearly-rise([list: 400]) is [list: ]
  yearly-rise([list: ]) is [list: ]
  yearly-rise([list: 5, 6, 8, 14, 10]) is [list: 1, 2, 6, -4]
end

#relaxed domain: the hottest day
fun hottest(temps :: List<Number>) -> Number:
  doc: "the highest temperature in a list; not defined for an empty list"
  cases (List) temps:
    | empty => raise("no temperatures given")
    |link(f, r) =>
      cases (List) r:
        | empty => f
        | else => num-max(f, hottest(r))
      end
  end
where:
  hottest(week-temps) is 34
  hottest([list: -3, -1, -5]) is -1
  hottest([list: 15]) is 15
  hottest(empty) raises "no temperatures"
end

# an accumulator
fun rain-acc(total :: Number, days :: List<Number>) -> List<Number>:
  doc: "the running totals of days, starting from total"
  cases (List) days:
    | empty => empty
    | link(f, r) =>
      new-total = total + f
      link(new-total, rain-acc(new-total, r))
  end
end

fun rain-so-far(days :: List<Number>) -> List<Number>:
  doc: "the rain so far, in mm, at the end of each day"
  rain-acc(0, days)
where:
  rain-so-far([list: 2, 0, 5, 1]) is [list: 2, 2, 7, 8]
  rain-so-far([list: ]) is [list: ]
  rain-so-far([list: 5]) is [list: 5]
end