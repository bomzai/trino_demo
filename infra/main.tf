resource "docker_network" "private_network" {
  name = "vnet"
  ipam_config {
    subnet = "10.10.0.1/16"
  }
}

resource "docker_volume" "shared_volume_mongo" {
  name = "shared_volume_mongo"
  driver = "local"
  driver_opts = {
    device = "${path.cwd}"
    type = "tmpfs"
    o = "rw"
  }
}

resource "docker_volume" "shared_volume_mysql" {
  name = "shared_volume_mysql"
  driver = "local"
  driver_opts = {
    device = path.cwd
    type = "tmpfs"
    o = "rw"
  }
}

resource "docker_container" "mongodb" {
  name  = "mongodb"
  image = docker_image.img_mongo.image_id

  volumes {
    container_path = var.MONGODB_DATA_PATH
    volume_name = docker_volume.shared_volume_mongo.id
  }

  networks_advanced {
    name         = "vnet"
    ipv4_address = "10.10.0.2"
  }

  ports {
    internal = var.MONGODB_PORT
    external = var.MONGODB_PORT
  }

  env = [
    "MONGO_INITDB_ROOT_USERNAME=${var.MONGODB_USER}",
    "MONGO_INITDB_ROOT_PASSWORD=${var.MONGODB_PASSWORD}",
    "MONGODB_USER=${var.MONGODB_USER}",
    "MONGODB_PASSWORD=${var.MONGODB_PASSWORD}",
    "MONGO_INITDB_DATABASE=${var.DATABASE}",
    "MONGODB_ZIP_DATA_PATH=${var.MONGODB_ZIP_DATA_PATH}",
    "MONGODB_DATA_PATH=${var.MONGODB_DATA_PATH}",
    "PYTHON_MONGODB_EOF=${var.PYTHON_MONGODB_EOF}",
    "BASICS_TABLE_FILE=${var.BASICS_TABLE_FILE_RECENT}",
    "RATINGS_TABLE_FILE=${var.RATINGS_TABLE_FILE_RECENT}",
    "DATES_TABLE_FILE=${var.DATES_TABLE_FILE_RECENT}",
  ]

  upload {
    file = "./docker-entrypoint-initdb.d/mongodb_import.sh"
    source = "../scripts/mongodb_import.sh"
  }

  depends_on = [
    docker_network.private_network
  ]
}

resource "docker_container" "mysql" {
  name  = "mysql"
  image = docker_image.img_mysql.image_id

  volumes {
    container_path = var.MYSQL_DATA_PATH
    volume_name = docker_volume.shared_volume_mysql.id
  }

  command = [ 
    "--secure-file-priv=${var.MYSQL_DATA_PATH}"
  ]

  networks_advanced {
    name         = "vnet"
    ipv4_address = "10.10.0.3"
  }

  ports {
    internal = var.MYSQL_PORT
    external = var.MYSQL_PORT
  }
  
  env = [
    "MYSQL_ROOT_PASSWORD=${var.MYSQL_PASSWORD}",
    "MYSQL_DATABASE=${var.DATABASE}",
    "MYSQL_CUSTOM_USER=${var.MYSQL_CUSTOM_USER}",
    "MYSQL_PASSWORD=${var.MYSQL_PASSWORD}",
    "DATABASE=${var.DATABASE}",
    "MYSQL_DATA_PATH=${var.MYSQL_DATA_PATH}",
    "MYSQL_ZIP_DATA_PATH=${var.MYSQL_ZIP_DATA_PATH}",
    "EXPORT_PATH=${var.EXPORT_PATH}",
    "BASICS_TABLE=${var.BASICS_TABLE}",
    "BASIC_TABLE_FILE=${var.BASICS_TABLE_FILE}",
    "RATINGS_TABLE=${var.RATINGS_TABLE}",
    "RATINGS_TABLE_FILE=${var.RATINGS_TABLE_FILE}",
    "DATES_TABLE=${var.DATES_TABLE}",
    "DATES_TABLE_FILE=${var.DATES_TABLE_FILE}",
    "PYTHON_MYSQL_EOF=${var.PYTHON_MYSQL_EOF}"
  ]

  depends_on = [
    docker_network.private_network
  ]

  upload {
    file   = "./docker-entrypoint-initdb.d/create_mysql_db.sql"
    source = "../scripts/create_mysql_db.sql"
  }

  upload {
    file = "./docker-entrypoint-initdb.d/mysql_import.sh"
    source = "../scripts/mysql_import.sh"
  }
}


resource "docker_container" "trinodb" {
  name  = "trinodb"
  image = docker_image.img_trino.image_id
  networks_advanced {
    name         = "vnet"
    ipv4_address = "10.10.0.4"
  }

  ports {
    internal = "8080"
    external = "8080"
  }

  upload {
    file   = "/etc/trino/catalog/mysql.properties"
    source = "connector/mysql.properties"
  }
  upload {
    file   = "/etc/trino/catalog/mongodb.properties"
    source = "connector/mongodb.properties"
  }

  depends_on = [
    docker_network.private_network
  ]
}

resource "docker_container" "python" {
  image = docker_image.img_python.image_id
  name = "python"

  volumes {
    from_container = docker_container.mongodb.id
    host_path = var.MONGODB_DATA_PATH
  }

  volumes {
    from_container = docker_container.mysql.id
    host_path =var.MYSQL_DATA_PATH
  }

  networks_advanced {
    name = "vnet"
    ipv4_address = "10.10.0.5"
  }

  upload {
    file = "zip_data.py"
    source = "../scripts/zip_data.py"
    executable = true
  }

  upload {
    file = "requirements.txt"
    source = "../scripts/requirements_etl.txt"
  }

  upload {
    file = "${var.EXPORT_PATH}/data_insert_time.tsv"
    source = "../data/data_insert_time.tsv"
  }

  upload {
    file = "${var.EXPORT_PATH}/title_basics_truncated.tsv"
    source = "../data/title_basics_truncated.tsv"
  }

  upload {
    file = "${var.EXPORT_PATH}/title_ratings_truncated.tsv"
    source = "../data/title_ratings_truncated.tsv"
  }

  upload {
    file = "start.sh"
    source = "../scripts/start.sh"
  }

  command = [ "bash", "start.sh" ]

  env = [
    "BASICS_TABLE_UNPROCESS_FILE=${var.BASICS_TABLE_UNPROCESS_FILE}",
    "RATINGS_TABLE_UNPROCESS_FILE=${var.RATINGS_TABLE_UNPROCESS_FILE}",
    "DATES_TABLE_UNPROCESS_FILE=${var.DATES_TABLE_UNPROCESS_FILE}",
    "INSERTION_DATE=${var.INSERTION_DATE}",
    "FILE_FORMAT=${var.FILE_FORMAT}",
    "PYTHON_MYSQL_TEMP_FOLDER=${var.PYTHON_MYSQL_TEMP_FOLDER}",
    "PYTHON_MONGODB_TEMP_FOLDER=${var.PYTHON_MONGODB_TEMP_FOLDER}",
    "EXPORT_PATH=${var.EXPORT_PATH}",
    "MYSQL_ZIP_DATA_PATH=${var.MYSQL_ZIP_DATA_PATH}",
    "MONGODB_ZIP_DATA_PATH=${var.MONGODB_ZIP_DATA_PATH}",
    "PYTHON_MYSQL_EOF=${var.PYTHON_MYSQL_EOF}",
    "PYTHON_MONGODB_EOF=${var.PYTHON_MONGODB_EOF}",
  ]

  depends_on = [
    docker_network.private_network
  ]
}


resource "docker_container" "python_trino" {
  image = docker_image.img_python.image_id
  name = "python_trino"

  volumes {
    from_container = docker_container.mongodb.id
    host_path = var.MONGODB_DATA_PATH
  }

  volumes {
    from_container = docker_container.mysql.id
    host_path =var.MYSQL_DATA_PATH
  }

  networks_advanced {
    name = "vnet"
    ipv4_address = "10.10.0.6"
  }

  upload {
    file = "trino_queries.py"
    source = "../scripts/trino_queries.py"
  }

  upload {
    file = "requirements.txt"
    source = "../scripts/requirements_trino.txt"
  }

  upload {
    file = "trino_queries.sh"
    source = "../scripts/trino_queries.sh"
  }

  command = [ "bash", "trino_queries.sh" ]

  env = [
    "EXPORT_PATH=${var.EXPORT_PATH}",
    "PYTHON_MYSQL_EOF=${var.PYTHON_MYSQL_EOF}",
    "PYTHON_MONGODB_EOF=${var.PYTHON_MONGODB_EOF}",
    "TRINO_USER=${var.TRINO_USER}",
    "TRINO_ADDRESS=${var.TRINO_ADDRESS}",
    "TRINO_PORT=${var.TRINO_PORT}",
  ]

  depends_on = [
    docker_network.private_network,
    docker_container.python_trino
  ]
}