# Step 3.3: Create Ingress Resources for ALB

kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: backend-ingress
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/backend-protocol: HTTP
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
    alb.ingress.kubernetes.io/group.name: "backend-group"
    alb.ingress.kubernetes.io/group.order: '1'
spec:
  rules:
  - host: buddywise.example.com
    http:
      paths:
      - path: /frontend
        pathType: Prefix
        backend:
          service:
            name: backend-service
            port:
              number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: frontend-ingress
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/backend-protocol: HTTP
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
    alb.ingress.kubernetes.io/group.name: "frontend-group"
    alb.ingress.kubernetes.io/group.order: '2'
spec:
  rules:
  - host: buddywise.example.com
    http:
      paths:
      - path: /frontend
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
EOF

# Step 4: Verify the ALB and Ingress are working

kubectl get ingress backend-ingress
kubectl get ingress frontend-ingress

echo "ALB Ingress for Backend and Frontend has been successfully deployed."
echo "Backend Ingress is available at: http://backend.your-domain.com"
echo "Frontend Ingress is available at: http://frontend.your-domain.com"

# Step 5: Monitor logs (optional)
kubectl logs -n kube-system deployment/aws-load-balancer-controller
