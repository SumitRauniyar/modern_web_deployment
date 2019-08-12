# modern_web_deployment
Deploy a Flask python app using Docker, Ansible, Terraform to Kubernetes Cluster at GCP
Steps for Deploying a web app to Kubernetes
#################################

DOCKER BUILD

1.docker build -t gcr.io/cloud-data-migrator/flask-application-image -f Dockerfile .

############################

1. kubectl config current-context : To ensure the kubectl config file is created after you have deployed clusters. If you havent deployed and youa re trying to access it.

2. gcloud container clusters get-credentials my-cluster --zone ""
		gcloud container clusters get-credentials "k8s-cluster" --zone "us-west1"

3. kubectl create deployment modern-web --image=gcr.io/cloud-data-migrator/flask-application-image

4. kubectl get pods

5. kubectl expose deployment modern-web --type=LoadBalancer  --port=5380 --target-port=8080