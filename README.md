# Java Web App (Spring Boot) — Starter

This repository contains:
- A minimal Spring Boot web application (Java 17)
- Dockerfile (multi-stage) to build a runnable image
- Jenkinsfile for CI/CD (example)
- Kubernetes manifests in `k8s/` for deployment

How to run locally:
1. Build with Maven:
   ```
   mvn -B clean package
   ```
2. Run the jar:
   ```
   java -jar target/java-web-app-1.0.0.jar
   ```
3. Open http://localhost:8080/api/hello

Customize:
- Replace `yourdockerhub` in Jenkinsfile and k8s/deployment.yaml with your registry.
- Add Jenkins credentials `dockerhub-creds` for Docker Hub push.
