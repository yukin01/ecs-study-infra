MANIFEST_URL=https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-yaml-templates/quickstart/cwagent-fluentd-quickstart.yaml
CLUSTER_NAME=$(PREFIX)-cluster
REGION_NAME=ap-northeast-1

quickstart-apply:
	curl $(MANIFEST_URL) | sed "s/{{cluster_name}}/$(CLUSTER_NAME)/;s/{{region_name}}/$(REGION_NAME)/" | kubectl apply -f -

delete:
	kubectl delete namespace amazon-cloudwatch
