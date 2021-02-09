using Pkg
using SQLite
using ZipFile

inputFile = ARGS[1]
outputFile = ARGS[2]

zipReader = ZipFile.Reader(inputFile)
println(zipReader)

db = SQLite.DB()
DBInterface.execute(db,"CREATE TABLE names (name TEXT);")

DBInterface.execute(db, "INSERT INTO names VALUES ('BOB');")

DBInterface.execute(db, "SELECT name FROM names;")