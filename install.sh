helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade -i  nginx-ingress ingress-nginx/ingress-nginx -f nginx-ingress/values.yaml

