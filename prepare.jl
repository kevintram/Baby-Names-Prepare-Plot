using Pkg
using SQLite
using ZipFile

namesZipFile = ARGS[1]
dbFile = ARGS[2]

zipReader = ZipFile.Reader(namesZipFile)
println(zipReader)

db = SQLite.DB(dbFile)

SQLite.execute(db, "SELECT name FROM names;")