resource "docker_network" "private_network" {
  name = "vnet"
  ipam_config {
    subnet = "10.10.0.1/16"
  }
}

resource "docker_container" "mongodb" {
  name  = "mongodb"
  image = "mongo:4.4.19-rc2"
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
    "MONGO_INITDB_ROOT_PASSWORD=toto"
  ]

  depends_on = [
    docker_network.private_network
  ]
}

resource "docker_container" "mysql" {
  name  = "mysql"
  image = "mysql:8.0-debian"
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
  ]

  depends_on = [
    docker_network.private_network
  ]
}


resource "docker_container" "trinodb" {
  name  = "trinodb"
  image = "trinodb/trino:407"
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
