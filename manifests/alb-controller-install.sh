helm repo add eks https://aws.github.io/eks-charts
helm repo update

kubectl create ns kube-system

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=my-eks-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=ap-south-1 \
  --set vpcId=aws_vpc.main.id \
  --set image.tag="v2.6.2"
