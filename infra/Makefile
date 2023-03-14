init:
	terraform init

validate:
	terraform validate

plan:
	terraform plan

apply:
	terraform apply -auto-approve

run: plan apply

install: init validate

uninstall:
	terraform apply -destroy -auto-approve