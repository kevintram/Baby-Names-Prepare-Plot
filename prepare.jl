using Pkg
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

stmt = SQLite._Stmt(db, "INSERT INTO names VALUES(?, ?, ?, ?)")


zipReader = ZipFile.Reader(namesZipFile)

for file in zipReader.files
    if (contains(file.name,"yob"))
        year = file.name[4:7]
        csv = CSV.File(file; header = ["name", "sex", "num"])
        SQLite.transaction(db) do 
            for row in csv 
                SQLite.bind!(stmt, [year, row.name, row.sex, row.num])
                SQLite.sqlite3_step(stmt.handle)
                SQLite.sqlite3_reset(stmt.handle)
            end
        end

    end
end

close(zipReader)
DBInterface.close!(db)