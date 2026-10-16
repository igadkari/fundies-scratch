use context dcic2024

include csv
include data-source
#|
   plan a task before coding it 
   find and cleaning dirty data 
   visualization
   
|#

#Task plan is a to-do list you can check off

#| input= the columns you start from
   output= a concrete example of what you want at the end
   steps=small enough that each one is a single funcition or a table operatin
   tools=the operation for each step; filter-wiht, transform-column
|#

#load voters data

voter-data = load-table: VoterID, DOB, Party, Address, City, County, Postcode
  source: csv-table-url("https://raw.githubusercontent.com/NU-London/LCSCI4207-datasets/refs/heads/main/voters.csv", default-options)
end

filter-with(voter-data, lam(r): r["Party"] == "Labour" end).length() # => 4

voter-data.row-n(3)["Party"] # => Labour

order-by(count(voter-data, "Party"), "count", false)

#reading open value with get-column

fun get-column(r :: Row, colname :: String):
  doc: "returns the value in row r for the column colname"
  r[colname]
where:
  get-column(voter-data.row-n(3), "Party") is "Labuor"
  get-column(voter-data.row-n(0), "VoterID") is "1"
end

filter-with(voter-data, lam(r) : get-column(r, "Party") == "Labour" end)
get-column(voter-data.row-n(3), "Party")

with-year = build-column(voter-data, "BirthYear", lam(r): string-substring(get-column(r, "DOB"), 6, 10)end)

get-column(with-year.row-n(0), "BirthYear") # => 1980


#fixing typo

fun fix-labour(s :: String) -> String:
  doc: "corrects the one known miss-spelling of Labour"
  if s == "Labuor" : "Labour" #Misspelling of labour party
  else if s == "" : "No Party" #fill in missing values with "No Party"
  else: s
end
 
where:
  fix-labour("Labuor") is "Labour"
  #fix-labour("") is "None"
  fix-labour("Green Party") is "Green Party" 
end

# try ising transform-column

fixed = tranform-column(voter-data, "Party", fix-labour)

freq-bar-char(fixed, "Party")