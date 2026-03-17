

## ⚙️ ขั้นตอนการทำ (Step-by-Step)

---

# 🧩 Part 1: เตรียมเครื่องมือ

## 1. ติดตั้ง Terraform

ดาวน์โหลดจาก: https://developer.hashicorp.com/terraform/downloads

ตรวจสอบ:

```bash
terraform -v
```

---

## 2. ติดตั้ง AWS CLI

```bash
aws configure
```

กรอก:

* Access Key
* Secret Key
* Region: ap-southeast-7

---

# ☁️ Part 2: Provision Infrastructure ด้วย Terraform

## 3. Clone โปรเจค

```bash
git clone https://github.com/suthasinee66/devops68-text-to-morse.git
cd devops68-text-to-morse
```

---

## 4. เตรียม Key Pair

⚠️ สำคัญ: ต้องมีไฟล์ `.pem` ก่อนใช้งาน

---

## 5. Initialize Terraform

```bash
terraform init
```

---

## 6. ตรวจสอบ Plan

```bash
terraform plan
```

---

## 7. Deploy Infrastructure

```bash
terraform apply
```

พิมพ์:

```text
yes
```

---

## ✅ output
app_public_url = "http://<PUBLIC_IP>:3030"

