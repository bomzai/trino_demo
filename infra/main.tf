resource "docker_network" "private_network" {
  name = "vnet"
  ipam_config {
    subnet = "10.10.0.1/16"
  }
}

resource "docker_volume" "shared_volume_mongo" {
  name = "shared_volume_mongo"
}

resource "docker_volume" "shared_volume_mysql" {
  name = "shared_volume_mysql"
}

resource "docker_container" "mongodb" {
  name  = "mongodb"
  image = docker_image.img_mongo.image_id

  volumes {
    container_path = "/data/export/mongodb"
    volume_name = docker_volume.shared_volume_mongo.id
  }

  networks_advanced {
    name         = "vnet"
    ipv4_address = "10.10.0.2"
  }

  ports {
    internal = "27017"
    external = "27017"
  }

  env = [
    "MONGO_INITDB_ROOT_USERNAME=root",
    "MONGO_INITDB_ROOT_PASSWORD=toto",
    "MONGO_INITDB_DATABASE=films"
  ]

  depends_on = [
    docker_network.private_network
  ]
}

resource "docker_container" "mysql" {
  name  = "mysql"
  image = docker_image.img_mysql.image_id

  volumes {
    container_path = "/data/export/mysql"
    volume_name = docker_volume.shared_volume_mysql.id
  }

  command = [ 
    "--secure-file-priv=/data"
  ]

  networks_advanced {
    name         = "vnet"
    ipv4_address = "10.10.0.3"
  }

  ports {
    internal = "3306"
    external = "3306"
  }

  env = [
    "MYSQL_ROOT_PASSWORD=root",
    "MYSQL_DATABASE=films"
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
    host_path = "/data/export/mongodb"
  }

  volumes {
    from_container = docker_container.mysql.id
    host_path = "/data/export/mysql"
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
    source = "../scripts/requirements.txt"
  }

  upload {
    file = "data/data_insert_time.tsv"
    source = "../data/data_insert_time.tsv"
  }

  upload {
    file = "data/title_basics_truncated.tsv"
    source = "../data/title_basics_truncated.tsv"
  }

  upload {
    file = "data/title_ratings_truncated.tsv"
    source = "../data/title_ratings_truncated.tsv"
  }

  upload {
    file = "start.sh"
    source = "../scripts/start.sh"
  }

  command = [ "bash", "start.sh" ]

  depends_on = [
    docker_network.private_network
  ]
}