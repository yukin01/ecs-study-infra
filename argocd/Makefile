build:
	rm .install.yaml
	kubectl kustomize . > .install.yaml

deploy-file:
	kubectl apply -f .install.yaml

deploy:
	kubectl apply -k .

delete-file:
	kubectl delete -f .install.yaml

delete:
	kubectl delete -k .

get-pod-name:
	kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2

get-server-dns:
	kubectl get svc -n argocd -l app.kubernetes.io/name=argocd-server -o json | jq -r '.items[0].status.loadBalancer.ingress[0].hostname'
