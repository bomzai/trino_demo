init:
	terraform init

validate:
	terraform validate

plan:
	terraform plan

apply:
	terraform apply -auto-approve

install: init validate plan apply

uninstall:
	terraform apply -destroy -auto-approve