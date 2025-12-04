#!/bin/bash

# ---------- Git конфигурация ----------
git config --global user.name "Askar Kozhakhmet"
git config --global user.email "kozhahmet772@gmail.com"

# ---------- Жаңа репо директория ----------
mkdir -p ~/askar && cd ~/askar

# ---------- README және Node.js файлы ----------
echo "# askar" > README.md
npm init -y
echo "console.log('Hello World');" > index.js

# ---------- Dockerfile ----------
cat <<EOL > Dockerfile
FROM node:20
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "index.js"]
EOL

# ---------- GitHub Actions workflow ----------
mkdir -p .github/workflows
cat <<EOL > .github/workflows/ci-cd.yml
name: CI/CD Pipeline
on:
  push:
    branches: [main]
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: docker/setup-buildx-action@v2
      - uses: docker/login-action@v2
        with:
          username: \${{ secrets.DOCKER_USERNAME }}
          password: \${{ secrets.DOCKER_PASSWORD }}
      - run: docker build -t askar-app:latest .
      - run: docker tag askar-app:latest \${{ secrets.DOCKER_USERNAME }}/askar-app:latest
      - run: docker push \${{ secrets.DOCKER_USERNAME }}/askar-app:latest
EOL

# ---------- Git репо жасау ----------
git init
git add .
git commit -m "Initial commit with CI/CD + Docker setup"
git branch -M main
git remote add origin git@github.com:kozhahmetaskar772-design/askar.git
git push -u origin main

echo "✅ Setup finished! GitHub Actions workflow and Docker CI/CD pipeline are ready."
