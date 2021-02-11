using Pkg
using SQLite
using DataFrames
using Gadfly

dbFile = ARGS[1]
name = String([i == 1 ? uppercase(c) : lowercase(c) for (i, c) in enumerate(ARGS[2])])
sex = uppercase(ARGS[3])

db = SQLite.DB(dbFile)

query = DBInterface.execute(db, "SELECT year, num FROM names WHERE name == ? AND sex == ?",[name, sex]) |> DataFrame

function getYearRange(firstYear, lastYear)
    roundTo(n,x) = round(Int, x / n) * n # rounds x to the nearest multiple of n

    firstYearRounded = roundTo(5, firstYear)
    lastYearRounded = roundTo(5, lastYear)

    range = collect(firstYearRounded:10:lastYearRounded)

    range[1] = firstYear
    range[lastindex(range)] = lastYear

    return range
end

firstYear = DataFrames.first(query).year
lastYear = DataFrames.last(query).year
yearRange = getYearRange(firstYear, lastYear)

println("Plotting...")

p = Gadfly.plot(
    query, 
    x=:year,
    y=:num, 
    (nrow(query) == 1) ? Gadfly.Geom.point : Gadfly.Geom.line,
    Gadfly.Guide.Title("Number of $sex $name Per Year"), 
    Gadfly.Guide.xticks(ticks = (lastYear - firstYear > 10) ? yearRange : :auto)
)

img = Gadfly.SVG("plot.svg",8inch, 4inch)
Gadfly.draw(img, p)

println("Finished plotting. Open plot.svg to see.")