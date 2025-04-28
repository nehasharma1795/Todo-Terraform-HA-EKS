resource "kubernetes_secret" "argocd_cluster_secret" {
  metadata {
    name      = "my-eks-cluster"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }

  data = {
    name   = base64encode("my-eks-cluster")
    server = base64encode("https://${aws_eks_cluster.main.endpoint}")
    config = base64encode(jsonencode({
      bearerToken     = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjM4ZjFlNmU0ZTE4YzI5NzI0YmE1MTE3NDI5MWE0MTU3ODdjZDIwYjAifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjIl0sImV4cCI6MTc0NTg2MjM4NCwiaWF0IjoxNzQ1ODU4Nzg0LCJpc3MiOiJodHRwczovL29pZGMuZWtzLmFwLXNvdXRoLTEuYW1hem9uYXdzLmNvbS9pZC81NUEzNjlGRjRFRkIxQ0VBOTY1Q0VBNTI1OTE3RUJERiIsImp0aSI6IjE5ZDU4M2E3LWVhZGItNGY2NS1iNjVjLTEyMjVhOTRmYTljMCIsImt1YmVybmV0ZXMuaW8iOnsibmFtZXNwYWNlIjoiYXJnb2NkIiwic2VydmljZWFjY291bnQiOnsibmFtZSI6ImFyZ29jZC1tYW5hZ2VyIiwidWlkIjoiYjRlNTZkODgtZGFiMy00MmNkLTk4MjctZTY1YzUwYWJiN2E5In19LCJuYmYiOjE3NDU4NTg3ODQsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDphcmdvY2Q6YXJnb2NkLW1hbmFnZXIifQ.TYjUfJncuQGXs-79TJlUHquR0fv77ro3uoWsjFXt5ZX8Ozqiu3KzoEOqF3uX6PU4YU3KEx0aCzTfbm0fh7UFSuWal5CZ8MNxXM-s5BQG5FeC6SXD_eVBvD0rGYWhxs47bmKYSQ_cZZ6jGNaAxqMbQcpmrWDMRqkmS7DAE86HW3kIjDazQYVmQtiHu7K41-Mo6pptZexpJryRdRqvrxnOb_H1y83ayYIePzbN-CaarfQ4hHqOovnhy7Go8WaiihliCIJ4-y-MxpfAJavr07MNNG6silbKgsxADCELw71ruYlYlv694dxFMkRG4T4CMZ4IskBkmclsG6lzAMWlS9u8yg"
      tlsClientConfig = {
        insecure = false
      }
    }))
  }

  type = "Opaque"
}
