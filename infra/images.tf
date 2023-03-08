resource "docker_image" "img_python" {
  name = "python:3.11.2"
  keep_locally = true
}

resource "docker_image" "img_mysql" {
  name = "mysql:8.0-debian"
  keep_locally = true
}

resource "docker_image" "img_mongo" {
  name = "mongo:6.0.4"
  keep_locally = true
}

resource "docker_image" "img_trino" {
  name = "trinodb/trino:407"
  keep_locally = true
}