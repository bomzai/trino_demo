variable "DATABASE" {
    type = string
    description = "Database name"
}

variable "BASICS_TABLE" {
    type = string
    description = "Basics table name"
}

variable "BASICS_TABLE_FILE" {
    type = string
    description = "Basics table data file name"
}

variable "BASICS_TABLE_FILE_RECENT" {
    type = string
    description = "Recent basics table"
}

variable "RATINGS_TABLE" {
    type = string
    description = "Ratings table name"
}

variable "RATINGS_TABLE_FILE" {
    type = string
    description = "Ratings table data file name"
}

variable "RATINGS_TABLE_FILE_RECENT" {
    type = string
    description = "Recent ratings table"
}

variable "DATES_TABLE" {
    type = string
    description = "Dates table name"
}

variable "DATES_TABLE_FILE" {
    type = string
    description = "Dates table data file name"
}

variable "DATES_TABLE_FILE_RECENT" {
    type = string
    description = "Recent dates table"
}

variable "EXPORT_PATH" {
    type = string
    description = "Path where all the unstructured data is stored"
}

variable "MYSQL_ADDRESS" {
    type = string
    description = "MySQL private IP adreess"
}

variable "MYSQL_PORT" {
    type = number
    description = "MySQL port"
}

variable "MYSQL_CUSTOM_USER" {
    type = string
    description = "MySQL username"
}

variable "MYSQL_PASSWORD" {
    type = string
    description = "MySQL password"
}

variable "MYSQL_URL" {
    type = string
    description = "MySQL connection url"
}

variable "MYSQL_DATA_PATH" {
    type = string
    description = "Path where MySQL data to import is stored"
}

variable "MYSQL_ZIP_DATA_PATH" {
    type = string
    description = "MySQL archive data path"
}

variable "MONGODB_ADDRESS" {
    type = string
    description = "MongoDB private IP adress"
}

variable "MONGODB_PORT" {
    type = number
    description = "MongoDB running port"
}

variable "MONGODB_USER" {
    type = string
    description = "MongoDB username"
}

variable "MONGODB_PASSWORD" {
    type = string
    description = "MongoDB password"
}

variable "MONGODB_DATA_PATH" {
    type = string
    description = "MongoDB data folder path"
}

variable "MONGODB_ZIP_DATA_PATH" {
    type = string
    description = "MongoDB archive data path"
}

variable "PYTHON_MYSQL_TEMP_FOLDER" {
    type = string
    description = "Python ETL temp data folder for MySQL"
}

variable "PYTHON_MONGODB_TEMP_FOLDER" {
    type = string
    description = "Python ETL temp data folder for MongoDB"
}

variable "PYTHON_MYSQL_EOF" {
    type = string
    description = "Python ETL EOF file name and path for MySQL. EOF is used to tell when the data transfer is done"
}

variable "PYTHON_MONGODB_EOF" {
    type = string
    description = "Python ETL EOF file name and path for MongoDB. EOF is used to tell when the data transfer is done"
}

variable "BASICS_TABLE_UNPROCESS_FILE" {
    type = string
    description = "Unprocess data for basics table"
}

variable "RATINGS_TABLE_UNPROCESS_FILE" {
    type = string
    description = "Unprocess data for ratings table"
}

variable "DATES_TABLE_UNPROCESS_FILE" {
    type = string
    description = "Unprocess data for dates table"
}

variable "FILE_FORMAT" {
    type = string
    description = "Format of the exported data"
}

variable "INSERTION_DATE" {
    type = string
    description = "Median date to use for splitting data between MySQL and MongoDB"
}

variable "TRINO_PORT" {
    type = number
    description = "Trino port"
}

variable "TRINO_ADDRESS" {
    type = string
    description = "Trino private IP adress"
}

variable "TRINO_USER" {
    type = string
    description = "Trino usernamee"
}
