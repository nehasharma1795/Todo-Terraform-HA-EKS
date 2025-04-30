eksctl utils associate-iam-oidc-provider \
  --region ap-south-1 \
  --cluster buddywise-eks \
  --approve

eksctl create iamserviceaccount \
  --cluster my-eks-cluster \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::aws:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
