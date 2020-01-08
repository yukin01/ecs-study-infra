build:
	rm install.yaml
	kubectl kustomize . > install.yaml

deploy-file:
	kubectl apply -f install.yaml

deploy:
	kubectl apply -k .
