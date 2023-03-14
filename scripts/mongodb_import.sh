MONGODB_USER="root"
MONGODB_PASS="toto"
EXPORT_PATH="/export"
MONGODB_DATA="${EXPORT_PATH}/mongodb"
ZIP_MONGODB_DATA_PATH="${MONGODB_DATA}/export_mongodb.tar"

DATABASE="films"
BASICS_TABLE="basics"
BASIC_TABLE_FILE="recent_basics_table"
RATINGS_TABLE="ratings"
RATINGS_TABLE_FILE="recent_ratings_table"
DATES_TABLE="dates"
DATES_TABLE_FILE="recent_titles_date"

# Waiting for the EOF
echo "Waiting for the data"
while [ ! -f "${MONGODB_DATA}/EOF" ]; do sleep 1; done
echo "Zipepd data uploaded"

#Unzip the data
#chmod 755 "${EXPORT_PATH}"
tar -xvf "${ZIP_MONGODB_DATA_PATH}" -C "${MONGODB_DATA}"

# Load data into MongoDB
mongoimport --db=films --collection=basics --type=tsv --file='/${MONGODB_DATA}/${BASIC_TABLE_FILE}' --headerline --username=root --password=toto --authenticationDatabase=admin
mongoimport --db=films --collection=ratings --type=tsv --file='/${MONGODB_DATA}/${RATINGS_TABLE_FILE}' --headerline --username=root --password=toto --authenticationDatabase=admin
mongoimport --db=films --collection=basics --type=tsv --file='/${MONGODB_DATA}/${DATES_TABLE_FILE}' --headerline --username=root --password=toto --authenticationDatabase=admin

