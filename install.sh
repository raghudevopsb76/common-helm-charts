aws eks update-kubeconfig --name dev-eks
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade -i  nginx-ingress ingress-nginx/ingress-nginx -f nginx-ingress/values.yaml

kubectl create namespace argocd
#kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f argocd/argocd.yaml


#

DNS=$(kubectl get svc | grep LoadBalancer | awk '{print $4}')

for i in argocd ; do
echo '{
  "Comment": "Created Server - Private IP address - IPADDRESS , DNS Record - COMPONENT-dev.DOMAIN_NAME",
  "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "APPNAME.rdevopsb72.online",
      "Type": "CNAME",
      "TTL": 30,
      "ResourceRecords": [{ "Value": "DNSNAME"}]
    }}]
}' | sed -e "s/APPNAME/$i/" -e "s/DNSNAME/$DNS/" >/tmp/record.json

aws route53 change-resource-record-sets --hosted-zone-id Z0021413JFIQEJP9ZO9Z --change-batch file:///tmp/record.json | jq
done
