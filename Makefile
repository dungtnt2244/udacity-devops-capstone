CLUSTER_NAME=hello-cluster
REGION_NAME=us-east-1
KEYPAIR_NAME=key-pair-us-east-1
DEPLOYMENT_NAME=hello-app
NEW_IMAGE_NAME=registry.hub.docker.com/dungtnt2244/hello-app:latest
CONTAINER_PORT=80
HOST_PORT=8080
KUBECTL=./bin/kubectl

setup:
	python3 -m venv ~/.devops-capstone
	# source ~/.devops-capstone/bin/activate 

install:
	pip install --upgrade pip && pip install -r src/requirements.txt
	pytest --version
	pwd
	ls
	./scripts/install_shellcheck.sh
	./scripts/install_hadolint.sh
	./scripts/install_kubectl.sh
	./scripts/install_eksctl.sh
	
lint:
	./bin/shellcheck -Cauto -a ./scripts/*.sh
	./bin/hadolint src/Dockerfile
	pylint --output-format=colorized --disable=C src/app.py

run-app:
	python3 src/app.py

build-docker:
	./scripts/build_docker.sh

run-docker: build-docker
	./scripts/run_docker.sh

upload-docker: build-docker
	./scripts/upload_docker.sh

ci-validate:
	circleci config validate

k8s-deployment: eks-create-cluster
	./scripts/k8s_deployment.sh

port-forwarding: 
	${KUBECTL} port-forward service/${DEPLOYMENT_NAME} ${HOST_PORT}:${CONTAINER_PORT}

rolling-update:
	${KUBECTL} get deployments -o wide
	${KUBECTL} set image deployments/${DEPLOYMENT_NAME} ${DEPLOYMENT_NAME}=${NEW_IMAGE_NAME}
	${KUBECTL} get deployments -o wide
	${KUBECTL} describe pods | grep -i image
	${KUBECTL} get pods -o wide

rollout-status:
	${KUBECTL} rollout status deployment ${DEPLOYMENT_NAME}
	${KUBECTL} get deployments -o wide

rollback:
	${KUBECTL} get deployments -o wide
	${KUBECTL} rollout undo deployment ${DEPLOYMENT_NAME}
	${KUBECTL} describe pods | grep -i image
	${KUBECTL} get pods -o wide
	${KUBECTL} get deployments -o wide

k8s-cleanup-resources:
	./scripts/k8s_cleanup_resources.sh

eks-create-cluster:
	./scripts/eks_create_cluster.sh

eks-delete-cluster:
	./scripts/eksctl delete cluster --name "${CLUSTER_NAME}" --region "${REGION_NAME}"