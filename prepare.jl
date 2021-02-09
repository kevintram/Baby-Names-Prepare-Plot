using Pkg

Pkg.add("SQLite")
Pkg.add("DataFrames")
Pkg.add("ZipFile")
Pkg.add("CSV")

using SQLite
using DataFrames
using ZipFile
using CSV

namesZipFile = ARGS[1]
dbFile = ARGS[2]

db = SQLite.DB(dbFile)

DBInterface.execute(db, 
"CREATE TABLE names (
    year INTEGER, 
    name TEXT,
    sex TEXT,
    num INTEGER
    );"
)

preparedStatement = DBInterface.prepare(db, "INSERT INTO names VALUES(?, ?, ?, ?)")

zipReader = ZipFile.Reader(namesZipFile)

for file in zipReader.files
    if (contains(file.name,"yob"))
        year = file.name[4:7]
        csv = CSV.File(file; header = ["name", "sex", "num"])

        for row in csv
            DBInterface.execute(preparedStatement, (year, row.name, row.sex, row.num))
        end
    end
end

DBInterface.close!(preparedStatement)
close(zipReader)