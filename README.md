# 🚀 Déploiement d'un site web avec Terraform sur AWS

## 📌 Objectif

Ce projet a pour objectif d'automatiser le déploiement d'une instance EC2 sur AWS à l'aide de Terraform, afin d'héberger un site web statique (comme [LUGX Gaming](https://gitlab.com/collection4devops/website_lugx_gaming)).

---

## ☁️ Technologies utilisées

- **Terraform** : Infrastructure as Code (IaC)
- **AWS EC2** : Service de machine virtuelle (Instance t2.micro)
- **AWS IAM** : Gestion des credentials d’accès
- **Git** : Pour cloner le site web depuis un dépôt distant
- **Apache (httpd)** : Serveur web pour héberger les fichiers

---

## 🛠️ Prérequis

- Un compte AWS avec les droits nécessaires
- Une **clé d'accès IAM (Access key & secret)** configurée avec `aws configure` ou variables d'environnement
- **Terraform** installé sur votre machine (`terraform -v`)
- Une paire de **clés SSH** (`atome-key.pem`) pour accéder à l’instance EC2
- Le dépôt du site : [website_lugx_gaming](https://gitlab.com/collection4devops/website_lugx_gaming)

---

## 📂 Structure du projet

```bash
website_lugx_gaming/
│
├── terraform/
│   ├── main.tf
│   └── variables.tf (optionnel)
├── assets/
├── index.html
└── ...
```

---

## 📄 main.tf – Description

Ce fichier Terraform :

- Initialise le provider AWS (`us-east-1`)
- Crée un groupe de sécurité avec les ports 22 (SSH) et 80 (HTTP) ouverts
- Déploie une instance EC2 avec une AMI Amazon Linux 2
- Exécute un **script d’initialisation** (user_data) pour :
  - Installer Apache et Git
  - Cloner le dépôt Git
  - Déplacer les fichiers dans `/var/www/html`

---

## 🧾 Exemple de script user_data

```bash
#!/bin/bash
yum update -y
yum install httpd git -y
systemctl start httpd
systemctl enable httpd
cd /var/www/html
git clone https://gitlab.com/collection4devops/website_lugx_gaming.git
mv website_lugx_gaming/* .
```

---

## 🌐 Accès au site

Après exécution de `terraform apply`, vous obtiendrez une **adresse IPv4 publique** comme :

```
instance_public_ip = "54.210.118.183"
```

👉 Accédez au site via [http://54.210.118.183](http://54.210.118.183)

---

## ✅ Commandes utiles

```bash
terraform init       # Initialiser le projet Terraform
terraform plan       # Afficher le plan d'exécution
terraform apply      # Appliquer la configuration (répondre "yes")
terraform destroy    # Supprimer les ressources AWS créées
```

---

## 🔐 Sécurité

- La clé `atome-key.pem` doit être sécurisée et **jamais poussée sur Git**
- Le groupe de sécurité ouvre les ports 22 et 80 à `0.0.0.0/0` → à restreindre en production

---

## 🧼 Nettoyage

Pour éviter les coûts AWS inutiles, pense à exécuter :

```bash
terraform destroy
```

---

## 📦 Auteur

Projet réalisé dans le cadre d’un TP de virtualisation & cloud (Ingénierie système).  
Encadré par : [Nom du professeur, si applicable]  
Réalisé par : **Osama Rahim** & **Yassine Merniss**
