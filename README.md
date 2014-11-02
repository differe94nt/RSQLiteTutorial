What is SQL
-----------

-   Structured Query Language
-   Relational Database Management System (RDBMS)

SQLite vs SQL
-------------

-   "Lite" verison of SQL
-   Supports most of the SQL syntax
-   Only allow single writer at a time
-   No user management
-   Best for mobile applications, testing
-   **NOT** for big-scale data
-   **NOT** for enterprises due to security reasons

Basic Definitions
-----------------

-   Table: collection of related data entries
-   Field: column names, eqv to header in `R`
-   Column
-   Row
-   Supported data types: **NULL**, **INTEGER**, **TEXT**, **BLOB**

RSQLite: Installation
---------------------

    install.packages(RSQLite, dependencies = T)

-   The source includes SQLite engine
-   Depends on DBI package

RSQLite: Create a table
-----------------------

    library(RSQLite)
    db = dbConnect(SQLite(), dbname="Test.sqlite")
    dbSendQuery(conn = db,
           "CREATE TABLE BASEBALL
           (Team_ID INTEGER,
             Team_Name TEXT,
            Leage TEXT,
            Payroll REAL,
            Wins INTEGER)")

RSQLite: Enter data manually:
-----------------------------

    dbSendQuery(conn = db,
             "INSERT INTO BASEBALL
             VALUES (1, 'Twins', 'American League', '54641175','1020')")
    dbSendQuery(conn = db,
             "INSERT INTO BASEBALL
             VALUES (2, 'Giants', 'American League', '82288960','1033')")
    dbSendQuery(conn = db,
             "INSERT INTO BASEBALL
             VALUES (3, 'Royals', 'National League', '49816557','803')")

RSQLite: Check the content of the table
---------------------------------------

    ## The tables in the database
    dbListTables(db) 

    [1] "BASEBALL"

    ## The columns in a table
    dbListFields(db, "BASEBALL")   

    [1] "Team_ID"   "Team_Name" "Leage"     "Payroll"   "Wins"     

    ## The data in a table
    head(dbReadTable(db, "BASEBALL"))

      Team_ID Team_Name           Leage  Payroll Wins
    1       1     Twins American League 54641175 1020
    2       2    Giants American League 82288960 1033
    3       3    Royals National League 49816557  803

RSQLite: Read data from csv file
--------------------------------

-   Windows and UNIX uses different End of Line
-   Always use `read.csv` to read csv into `R` dataframe first

<!-- -->

    bball = read.csv('bball.csv')
    db.bball = dbConnect(SQLite(), dbname="bball.sqlite")
    dbWriteTable(conn = db.bball, name = "BASEBALL", bball, overwrite=T,
                 row.names=FALSE)

    tmp = dbReadTable(db.bball, "BASEBALL")

       League Division      Team   Payroll  RSW  RSL  RSWP PSW PSL  PSWP
    1      NL     East   Marlins  37630735  955  987 0.492  11   6 0.647
    2      NL  Central   Pirates  42725187  816 1124 0.421   0   0 0.000
    3      AL     East      Rays  44626279  859 1082 0.443  10  11 0.476
    4      NL     East Nationals  47886266  848 1095 0.436   0   0 0.000
    5      AL  Central    Royals  49816557  803 1140 0.413   0   0 0.000
    6      AL     West Athletics  53392335 1058  884 0.545  11  16 0.407
    7      AL  Central     Twins  54641175 1020  923 0.525   5  22 0.185
    8      NL     West    Padres  55895437  933 1012 0.480   1   6 0.143
    9      NL  Central   Brewers  58434278  892 1050 0.459   1   3 0.250
    10     NL  Central      Reds  58856196  938 1007 0.482   0   3 0.000
    11     NL     West   Rockies  65904890  924 1021 0.475   8   7 0.533
    12     AL  Central   Indians  67017220  982  962 0.505  10  11 0.476
    13     AL     East Blue Jays  69897229  974  969 0.501   0   0 0.000
    14     AL     East   Orioles  74561126  842 1100 0.434   0   0 0.000
    15     AL  Central White Sox  76245629 1020  924 0.525  12   7 0.632
    16     NL     West   D-Backs  76256203  970  974 0.499  15  16 0.484
    17     AL     West   Rangers  79969827  961  983 0.494   8  11 0.421
    18     NL  Central    Astros  81639036 1005  938 0.517  14  19 0.424
    19     AL  Central    Tigers  82093735  879 1064 0.452   8   5 0.615
    20     NL     West    Giants  82288960 1033  908 0.532  23  17 0.575
    21     AL     West  Mariners  86805804  977  967 0.503   9  10 0.474
    22     NL  Central Cardinals  88025605 1074  868 0.553  33  31 0.516
    23     NL     East  Phillies  88495136 1024  919 0.527  25  16 0.610
    24     NL     East    Braves  90945750 1086  856 0.559  19  29 0.396
    25     AL     West    Angels  91856756 1050  894 0.540  21  24 0.467
    26     NL  Central      Cubs  96340928  949  993 0.489   6  12 0.333
    27     NL     West   Dodgers 106759507 1019  925 0.524   9  14 0.391
    28     NL     East      Mets 109724991  991  952 0.510  19  15 0.559
    29     AL     East   Red Sox 122952275 1103  840 0.568  38  29 0.567
    30     AL     East   Yankees 174493964 1158  781 0.597  68  46 0.596

RSQLite: make queries
---------------------

-   A query: which teams are in National League?
-   Select all columns

<!-- -->

    dbGetQuery(db.bball, "select * from BASEBALL where League='NL'")[1:2,]

      League Division    Team  Payroll RSW  RSL  RSWP PSW PSL  PSWP
    1     NL     East Marlins 37630735 955  987 0.492  11   6 0.647
    2     NL  Central Pirates 42725187 816 1124 0.421   0   0 0.000

-   Select some columns

<!-- -->

    dbGetQuery(db.bball, "select League, Team, RSW from BASEBALL
               where League='NL'")[1:2,]

      League    Team RSW
    1     NL Marlins 955
    2     NL Pirates 816

RSQLite: more complicated queries
---------------------------------

-   SQL logical operators: AND, OR, NOT
-   which American League teams has regular season wins less than 810?

<!-- -->

    dbGetQuery(db.bball, "select * from BASEBALL where League='AL' and RSW<810")

      League Division   Team  Payroll RSW  RSL  RSWP PSW PSL PSWP
    1     AL  Central Royals 49816557 803 1140 0.413   0   0    0

Questions?

Download all the code from
[GitHub](https://github.com/ysquared2/RSQLiteTutorial)
