#######################################################
## Use RSQLite package
## below is an example of how to enter query manually
#######################################################
library(RSQLite)
db = dbConnect(SQLite(), dbname="Test.sqlite")

dbSendQuery(conn = db,
       "CREATE TABLE BASEBALL
       (Team_ID INTEGER,
       	Team_Name TEXT,
        Leage TEXT,
        Payroll REAL,
        Wins INTEGER)")

dbSendQuery(conn = db,
         "INSERT INTO BASEBALL
         VALUES (1, 'Twins', 'American League', '54641175','1020')")
dbSendQuery(conn = db,
         "INSERT INTO BASEBALL
         VALUES (2, 'Giants', 'American League', '82288960','1033')")
dbSendQuery(conn = db,
         "INSERT INTO BASEBALL
         VALUES (3, 'Royals', 'National League', '49816557','803')")


dbListTables(db)              # The tables in the database
dbListFields(db, "BASEBALL")    # The columns in a table
dbReadTable(db, "BASEBALL")     # The data in a table
 
#dbRemoveTable(db, "BASEBALL") 



############################################
## from csv
############################################

## the reason we want to start from read.csv() is that different csv file may have different line break
## e.g., windows uses CR+LF, UNIX alike uses LF
## reading csv files directly using dbWriteTable may cause trouble
## safest way is to read .csv file into R dataframe first

## read csv file
bball = read.csv('bball.csv')

## first create an empty database 
db.bball = dbConnect(SQLite(), dbname="bball.sqlite")


## write the csv data into database
dbWriteTable(conn = db.bball, name = "BASEBALL", bball, overwrite=T, row.names = FALSE)

## check the content of the database
dbReadTable(db.bball, "BASEBALL") 



########################################################
## How to make queries from DB?
########################################################

## select all the National League teams, all columns selected
dbGetQuery(db.bball, "select * from BASEBALL where League='NL'")
## select all the National League teams, some columns selected
dbGetQuery(db.bball, "select League, Team, RSW from BASEBALL where League='NL'")

## SQL logical operators: AND, OR, NOT
## which American League teams has regular season wins less than 810?
dbGetQuery(db.bball, "select League, Division, Team, RSW, RSL from BASEBALL where League='AL' and RSW<810")




