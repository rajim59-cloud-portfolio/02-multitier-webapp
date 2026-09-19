ভবিষ্যতে কাজ শুরুর আগে Project 1 (Landing Zone) চালু করা এবং কাজ শেষে সব রিসোর্স বন্ধ (Destroy) করে **$0 বিল (FinOps)** নিশ্চিত করার জন্য একটি আদর্শ SOP (Standard Operating Procedure) বা রানবুক টেমপ্লেট নিচে দেওয়া হলো।

এই চিটশিটটি সেভ করে রাখতে পারেন, যাতে প্রতিবার কাজ শুরু ও শেষের সময় এক নজরে দেখে কমান্ডগুলো চালাতে পারেন।

---

# 📋 Azure Daily Workflow SOP: Startup & Teardown Runbook

---

## 🟢 ধাপ ১: কাজ শুরুর সময় (Project 1 চালু করা)

Project 2-তে কাজ করার জন্য Project 1-এর নেটওয়ার্ক ও ব্যাকএন্ড থাকা আবশ্যক।

```powershell
# ১. Project 1-এর infra ডিরেক্টরিতে যান
cd F:\rajim59-cloud-portfolio\01-landing-zone-foundation\infra

# ২. Azure CLI লগইন এবং সাবস্ক্রিপশন নিশ্চিত করুন
az account show --query "{Name:name, SubscriptionId:id}" -o table

# ৩. ট্যাগ গভর্ন্যান্স প্রি-চেক চালান (প্রজেক্ট রুটে গিয়ে স্ক্রিপ্ট চালানো)
cd ..
.\scripts\validate-tags.ps1
cd infra

# ৪. Terraform Plan তৈরি করুন
terraform plan -out=tfplan

# ৫. রিসোর্সগুলো লাইভ প্রভিশন করুন (৫-৭ মিনিট সময় লাগতে পারে)
terraform apply tfplan

# ৬. সফল হলে সাবনেট ও নেটওয়ার্ক আউটপুটগুলো এক পলক দেখে নিন
terraform output

```

---

## 💻 ধাপ ২: Project 2-তে কাজ করা

Project 1 চালু হয়ে গেলে Project 2-এর কাজ শুরু করুন:

```powershell
# Project 2-এর infra ডিরেক্টরিতে যান
cd F:\rajim59-cloud-portfolio\02-multitier-webapp\infra

# গিট ব্রাঞ্চ নিশ্চিত করুন (সবসময় feature/developer)
git branch --show-current

# রিমোট স্টেট কানেকশন রিফ্রেশ করুন
terraform plan

# এরপর অ্যাপ সার্ভিস, ডেটাবেস বা কোডিংয়ের কাজ করুন

```

---

## 🔴 ধাপ ৩: কাজ শেষের সময় (সব রিসোর্স বন্ধ করা — $0 বিল নিশ্চিতকরণ)

কাজের সেশন শেষ হলে Azure-এর চার্জ পুরোপুরি বন্ধ করতে **সবসময় রিভার্স অর্ডারে (Project 2 আগে, তারপর Project 1)** রিসোর্স ডেস্ট্রয় করতে হবে। কারণ Project 2 যদি Project 1-এর সাবনেট ব্যবহার করে, তবে Project 1 আগে মুছতে গেলে আটকে যাবে।

### ৩.১: প্রথমে Project 2 ডেস্ট্রয় করা (যদি রিসোর্স তৈরি করা থাকে)

```powershell
cd F:\rajim59-cloud-portfolio\02-multitier-webapp\infra

# Project 2-এর রিসোর্স ক্লিনআপ
terraform destroy -auto-approve

```

### ৩.২: এরপর Project 1 ডেস্ট্রয় করা (ফায়ারওয়াল ও বাকি রিসোর্স বন্ধ)

```powershell
cd F:\rajim59-cloud-portfolio\01-landing-zone-foundation\infra

# প্রজেক্ট ১-এর অটোমেটেড ডেস্ট্রয় স্ক্রিপ্ট থাকলে সেটি রান করতে পারেন:
# ..\scripts\destroy.ps1

# অথবা সরাসরি Terraform Destroy কমান্ড চালান:
terraform destroy -auto-approve

```

---

## 🛡️ জরুরি সিকিউরিটি ও FinOps টিপস

| বিষয় | করণীয় |
| --- | --- |
| **অর্ডার অফ ডেস্ট্রাকশন** | আগে **Project 2 destroy**, তারপর **Project 1 destroy**। উল্টো করলে ডিপেন্ডেন্সি এরর আসবে। |
| **স্টেট স্টোরেজ অক্ষত** | `rg-tfstate` এবং `sttfstaterajim01` কখনোই ডিলিট হবে না; এগুলো পার্মানেন্ট থাকবে কারণ এগুলোতে কেবল স্টেট ফাইল থাকে (খরচ শূন্যের কাছাকাছি)। |
| **কাজ শেষে Azure পোর্টাল চেক** | টার্মিনালে `destroy complete` হওয়ার পর Azure Portal-এ গিয়ে একবার Resource Groups রিফ্রেশ করে নিশ্চিত হয়ে নেওয়া যে কোনো ফায়ারওয়াল বা ভি-নেট রানিং নেই। |

---