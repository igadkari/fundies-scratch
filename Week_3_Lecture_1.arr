use context starter2024

check:
  true is true
  not(true) is false
  
  #and
  true and true is true
  false and true is false
  false and false is false
  (3 > 1) and ((4 * 2) == 8) is true
  (5 < 2) and ((2 + 3) == 5) is false
  
  #or
  true or false is true
  false or false is false
  ((3 * 7) == 21)  or ("a" == "b") is true
  
end
fun choose-hat(temp-in-C :: Number) -> String:
  doc: "determines appropriate head gear, with above 27C a sun hat, below nothing"
  if temp-in-C >= 27:
    "sun hat"
  else:
    "no hat"
  end
where: 
  choose-hat(25) is "no hat"
  choose-hat(35) is "sun hat"
  choose-hat(27) is "sun hat"
end

fun choose-hat-debug(temp-in-C :: Number) -> String:
  doc: "determines appropriate head gear, with above 27C a sun hat, below nothing"
  spy:
    temp-in-C,
    comparison: temp-in-C > 27
  end
  if temp-in-C >= 27:
    "sun hat"
  else:
    "no hat"
  end
where: 
  choose-hat-debug(25) is "no hat"
  choose-hat-debug(35) is "sun hat"
  choose-hat-debug(27) is "sun hat"
end

#|
   The full design recipe
   Four Steps: do them in this order, and write the code last
   1. Type annotation, what goes in, what comes out
   2. Docstring: one english sentence saying what it is for
   3. Examples: concrete input.output pairs in where:block
   4. Code: the body, written last
|#