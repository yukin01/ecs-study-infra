build:
	rm install.yaml
	kubectl kustomize . > install.yaml

deploy-file:
	kubectl apply -f install.yaml

deploy:
	kubectl apply -k .

delete-file:
	kubectl delete -f install.yaml

delete:
	kubectl delete -k .
