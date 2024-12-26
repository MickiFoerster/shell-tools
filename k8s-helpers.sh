function k8s-pod() {
	cat <<EOM
apiVersion: v1
kind: Pod
metadata:
  name: my-nginx-pod
  labels:
    app: nginx
spec:
  containers:
    - name: nginx
      image: nginx:latest
      ports:
        - containerPort: 80
EOM
}

function k8s-service() {
	cat <<EOM
apiVersion: v1
kind: Service
metadata:
  name: my-service
  labels:
    service: "true"
spec:
  selector:
    app: nginx
  ports:
    - port: 8080     # service port
      targetPort: 80 # target port on the container
      protocol: TCP
EOM
}

function k8s-service-local() {
	cat <<EOM
apiVersion: v1
kind: Service
metadata:
  name: my-service
  labels:
    service: "true"
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - port: 8080     # service port
      targetPort: 80 # target port on the container
      nodePort: 30001 # port on local machine
      protocol: TCP

# testing with a node port: 
# curl http://\$(minikube ip):<nodeport>
# or with the cluster IP:
# kubectl run tmp-shell --rm -i --tty --image nicolaka/netshoot -- /bin/bash
# tmp-shell:~# curl http://<cluster service IP>:<service port>
# service port will connect to <pod IP address>:<target port>
EOM
}

function k8s-deployment() {
cat <<EOM
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-deployment
spec:
  replicas: 3 # Number of desired pods
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app-container
        image: nginx:latest  # Replace with your image
        ports:
        - containerPort: 80
EOM
}
