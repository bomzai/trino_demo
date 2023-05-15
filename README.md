# Trino Demo
Query engine demonstration with Trino.

# :bangbang: Clone the projet :bangbang:

Use this command to clone this repo with all the submodules:

`git clone --recursive https://github.com/bomzai trino_demo.git`

Or if you have already cloned the project, you can use inside the *scripts/general_scripts* submodule:

```
git submodule init
git submodule update
```

# Run & Stop

## Requirements

Make sure to have [terraform](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform), make and [docker](https://www.docker.com) installed.

## How to run

Go to the project root and type

```
./run.sh
```

It will deploy a test environnement inside docker. You can then access trino via `localhost:8080`.

## How to delete

To stop and delete your deployed environnement do

```
./run.sh -d
```

# Infrastructure 

## Schema

Trino connected to MongoDB and MySQL inside private network. Instantiation using Terraform.

![infra](img/infra.png)

## Data model

![data model](img/datamodel.png)
