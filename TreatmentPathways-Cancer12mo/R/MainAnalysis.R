###########################################################
# R script for creating SQL files (and sending the SQL    # 
# commands to the server) for the treatment pattern       #
# studies for these diseases:                             #
# - Hypertension (HTN)                                    #
# - Type 2 Diabetes (T2DM)                                #
# - Depression                                            #
#                                                         #
# Requires: R and Java 1.6 or higher                      #
###########################################################

# Install necessary packages if needed
install.packages("devtools")
library(devtools)
install_github("ohdsi/SqlRender")
install_github("ohdsi/DatabaseConnector")

# Load libraries
library(SqlRender)
library(DatabaseConnector)

###########################################################
# Parameters: Please change these to the correct values:  #
###########################################################

folder        = "C:/Users/rc3179/Documents/NCI/Treatment Pathways code/12mo" # Folder containing the R and SQL files, use forward slashes
minCellCount  = 1   # the smallest allowable cell count, 1 means all counts are allowed
cdmSchema     = "ohdsi_west_pending.dbo"
resultsSchema = "ohdsi_west_pending.results"
sourceName    = "txpath12mo_ca"
dbms          = "sql server"  	  # Should be "sql server", "oracle", "postgresql" or "redshift"

# If you want to use R to run the SQL and extract the results tables, please create a connectionDetails 
# object. See ?createConnectionDetails for details on how to configure for your DBMS.

server <- "nysgcdwdbdev.sis.nyp.org"

connectionDetails <- createConnectionDetails(dbms=dbms, 
                                              server=server, 
                                              schema=cdmSchema)


###########################################################
# End of parameters. Make no changes after this           #
###########################################################

setwd(folder)

source("HelperFunctions.R")

# Create the parameterized SQL files:
htnSqlFile <- renderStudySpecificSql("HTN12mo_ca",minCellCount,cdmSchema,resultsSchema,sourceName,dbms)
t2dmSqlFile <- renderStudySpecificSql("T2DM12mo_ca",minCellCount,cdmSchema,resultsSchema,sourceName,dbms)
depSqlFile <- renderStudySpecificSql("Depression12mo_ca",minCellCount,cdmSchema,resultsSchema,sourceName,dbms)

# Execute the SQL:
conn <- connect(connectionDetails)
executeSql(conn,readSql(htnSqlFile))
executeSql(conn,readSql(t2dmSqlFile))
executeSql(conn,readSql(depSqlFile))

# Extract tables to CSV files:
extractAndWriteToFile(conn, "summary", resultsSchema, sourceName, "HTN12mo_ca", dbms)
extractAndWriteToFile(conn, "person_cnt", resultsSchema, sourceName, "HTN12mo_ca", dbms)
extractAndWriteToFile(conn, "seq_cnt", resultsSchema, sourceName, "HTN12mo_ca", dbms)

extractAndWriteToFile(conn, "summary", resultsSchema, sourceName, "T2DM12mo_ca", dbms)
extractAndWriteToFile(conn, "person_cnt", resultsSchema, sourceName, "T2DM12mo_ca", dbms)
extractAndWriteToFile(conn, "seq_cnt", resultsSchema, sourceName, "T2DM12mo_ca", dbms)

extractAndWriteToFile(conn, "summary", resultsSchema, sourceName, "Depression12mo_ca", dbms)
extractAndWriteToFile(conn, "person_cnt", resultsSchema, sourceName, "Depression12mo_ca", dbms)
extractAndWriteToFile(conn, "seq_cnt", resultsSchema, sourceName, "Depression12mo_ca", dbms)

dbDisconnect(conn)

