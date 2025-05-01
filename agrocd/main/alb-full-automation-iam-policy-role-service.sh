#!/bin/bash

set -e

# Variables
CLUSTER_NAME="my-eks-cluster"
REGION="ap-south-1"
NAMESPACE="kube-system"
SERVICE_ACCOUNT_NAME="aws-load-balancer-controller"
POLICY_NAME="AWSLoadBalancerControllerIAMPolicy"
ALB_CONTROLLER_VERSION="v2.6.2"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
OIDC_PROVIDER=$(aws eks describe-cluster --name $CLUSTER_NAME --region $REGION \
    --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")
VPC_ID=$(aws eks describe-cluster --name $CLUSTER_NAME --region $REGION \
    --query "cluster.resourcesVpcConfig.vpcId" --output text)

echo "Using OIDC Provider: $OIDC_PROVIDER"
echo "Using VPC ID: $VPC_ID"

# Step 1: Create IAM Policy if not exists
if ! aws iam get-policy --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/$POLICY_NAME > /dev/null 2>&1; then
  echo "Creating IAM policy..."
  curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
  aws iam create-policy \
    --policy-name $POLICY_NAME \
    --policy-document file://iam-policy.json
else
  echo "IAM policy $POLICY_NAME already exists. Skipping creation."
fi

# Step 2: Create IAM Role for Service Account (IRSA)
TRUST_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::$AWS_ACCOUNT_ID:oidc-provider/$OIDC_PROVIDER"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "$OIDC_PROVIDER:sub": "system:serviceaccount:$NAMESPACE:$SERVICE_ACCOUNT_NAME"
        }
      }
    }
  ]
}
EOF
)

ROLE_NAME="AmazonEKSLoadBalancerControllerRole"

if ! aws iam get-role --role-name $ROLE_NAME > /dev/null 2>&1; then
  echo "Creating IAM role $ROLE_NAME..."
  echo "$TRUST_POLICY" > trust-policy.json
  aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document file://trust-policy.json
else
  echo "IAM Role $ROLE_NAME already exists."
fi

echo "Attaching IAM policy to the role..."
aws iam attach-role-policy \
  --role-name $ROLE_NAME \
  --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/$POLICY_NAME

# Step 3: Create Kubernetes service account and annotate it with IAM role
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $SERVICE_ACCOUNT_NAME
  namespace: $NAMESPACE
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::$AWS_ACCOUNT_ID:role/$ROLE_NAME
EOF

# Step 4: Install AWS Load Balancer Controller via Helm
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --namespace $NAMESPACE \
  --set clusterName=$CLUSTER_NAME \
  --set serviceAccount.create=false \
  --set serviceAccount.name=$SERVICE_ACCOUNT_NAME \
  --set region=$REGION \
  --set vpcId=$VPC_ID

# Step 5: Verify ALB Controller
kubectl get deployment -n $NAMESPACE aws-load-balancer-controller

# Step 6: (Optional) Deploy your apps from Git (ArgoCD or kubectl apply)
echo "✅ ALB Controller setup complete."

echo "ℹ️ You can now deploy your frontend/backend apps with Ingress resources to expose them."
