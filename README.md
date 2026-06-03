### Lab 2: Azure Storage Public Data Exposure (Unauthenticated Information Disclosure)


Welcome to Lab 2 of the AzureHackMe series. This lab demonstrates how a series of small, overly permissive cloud configurations can chain together to cause a catastrophic leak of highly sensitive proprietary data (like production database backups and customer information) onto the public internet.

🎯 Lab Objectives
Deploy an insecure Azure Storage Account using modular Terraform files.

Host real sample assets (prod_dump.sql and customer_data.csv) inside a publicly accessible container.

Verify and exploit the misconfiguration anonymously using standard command-line tools without any cloud credentials.

Learn how to remediate the risk by transitioning to a secure baseline.

🗂️ Repository Structure
Your project directory should look exactly like this before you begin:


### 🏗️ 1. Deployment (The Vulnerable Environment)

Prerequisites
 * Terraform installed locally.
 * Azure CLI authenticated to a non-production testing environment.
 * An active Azure Subscription.

 Execution Steps
Open your terminal, navigate into the vulnerability/ folder, and log into your Azure subscription:

```bash
az login
```

2. Initialize the backend and download the required cloud providers:

```bash
terrafrom init
```

3. Provision the vulnerable target architecture:
``` bash
terraform apply -auto-approve
```

4. Once the deployment finishes, look at your terminal screen. Terraform will automatically generate your target exploitation URLs under Outputs:


### 🔓 2. Verification & Exploration

To confirm the vulnerability, simulate a malicious internet actor scanning the web looking for open cloud assets. You will attempt to download these sensitive documents completely anonymously (without passing any Azure tokens or session cookies).

Open a clean terminal window (or an incognito web browser) and send unauthenticated HTTP requests using your unique output URLs:

## Test Asset 1: The SQL Database Dump

```bash
curl -i "<YOUR_vulnerable_sql_url>"
```
Expected Result: You will receive an HTTP/1.1 200 OK header followed immediately by full database queries, tables, and credentials (CREATE TABLE users...) dumped on your screen.

## Test Asset 2: The Customer CSV File

```bash
curl -i "<YOUR_vulnerable_csv_url>"
```

Expected Result: The server will respond with 200 OK and display plain-text customer records, names, emails, and mock credit card strings directly.