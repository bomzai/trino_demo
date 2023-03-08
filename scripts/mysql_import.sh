MYSQL_USER='root'
MYSQL_PASS='root'
SHARED_VOLUME_PATH="/data"
EXPORT_PATH="${SHARED_VOLUME_PATH}/export"
MYSQL_DATA="${EXPORT_PATH}/mysql"
ZIP_MYSQL_DATA_PATH="./${MYSQL_DATA}/export_mysql.tar"

DATABASE="films"
BASICS_TABLE="basics"
BASIC_TABLE_FILE="old_basics_table.tsv"
RATINGS_TABLE="ratings"
RATINGS_TABLE_FILE="old_ratings_table.tsv"
DATES_TABLE="dates"
DATES_TABLE_FILE="old_titles_dates.tsv"

# Wait for mysqld to be initalized
echo "Waiting for mysqld"
while ! mysqladmin ping -h localhost --user=${MYSQL_USER} --password=${MYSQL_PASS} 2> /dev/null; do
    echo "..."
    sleep 1
done
echo -e "\nmysqld ready !"

# Wait for the data
echo "Waiting for data"
while [ ! -f "${MYSQL_DATA}/EOF" ]; do sleep 1; done
echo "Zipepd data uploaded"

# Unzip data
chmod 755 "/${EXPORT_PATH}"/*
tar -xvf "${ZIP_MYSQL_DATA_PATH}" -C "${MYSQL_DATA}"

IMPORT_REQUEST="""LOAD DATA INFILE '/${MYSQL_DATA}/${DATES_TABLE_FILE}'
INTO TABLE ${DATES_TABLE}
IGNORE 1 ROWS
SET dataInsertTime = str_to_date(dataInsertTime, '%Y-%m-%d');

LOAD DATA INFILE '/${MYSQL_DATA}/${BASIC_TABLE_FILE}'
INTO TABLE ${BASICS_TABLE}
IGNORE 1 ROWS;

LOAD DATA INFILE '/${MYSQL_DATA}/${RATINGS_TABLE_FILE}'
INTO TABLE ${RATINGS_TABLE}
IGNORE 1 ROWS;
"""

# Load data into mysql
mysql -D ${DATABASE} --user=${MYSQL_USER} --password=${MYSQL_PASS} -e "${IMPORT_REQUEST}"
