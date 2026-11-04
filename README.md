# 📚 StudySwap — Campus Peer-to-Peer Academic Marketplace

![.NET Framework](https://img.shields.io/badge/.NET%20Framework-4.7.2%20%7C%204.8-blue?style=for-the-badge&logo=dotnet)
![ASP.NET WebForms](https://img.shields.io/badge/ASP.NET-WebForms-512bd4?style=for-the-badge&logo=visual-studio)
![C#](https://img.shields.io/badge/C%23-239120?style=for-the-badge&logo=c-sharp&logoColor=white)
![SQL Server](https://img.shields.io/badge/MS%20SQL%20Server-CC292B?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Bootstrap 5](https://img.shields.io/badge/Bootstrap-5.3-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white)

> A sustainable, secure campus web application enabling university students to buy, sell, or barter syllabus-relevant textbooks, lab equipment, drafters, and calculators directly with peers.

---

## 🌟 Key Features

### 👨‍🎓 Student Portal
* **Verified Campus Community:** Student registration requires institutional College Roll Number and Student ID card upload.
* **Academic Catalog & Search:** Search textbooks and equipment filtered by Department, Course, Semester, and Category with condition ratings (*New*, *Like New*, *Good*, *Fair*).
* **Click-to-Chat on WhatsApp:** Instant direct chat generation (`wa.me`) with pre-filled greeting messages for quick campus meetups.
* **Seller Privacy Controls:** Sellers can toggle their contact visibility on or off to protect their phone number from public web scrapers.
* **Multi-Photo Uploads:** Up to 3 high-resolution photos per item with automatic server-side storage and naming.
* **Barter & Exchange Requests:** Item-for-item trade negotiations in addition to standard cash sales.
* **Secure 2-Step Forgot Password:** Multi-factor identity validation verifying registered Email and matching College Roll Number before unlocking SHA-256 password reset.

### 🛡️ Administrator Portal
* **Interactive Command Center:** Real-time metrics tracking registered students, active inventory, pending ID approvals, and disputes.
* **Student Verification Desk:** Inspect uploaded college ID proofs to approve or reject student onboarding.
* **Passout Cohort Management & Bulk Purge:** Categorize students by graduation year (1st–4th year). Allows administrators at year-end to cleanly wipe graduating cohorts across 7 database tables using an atomic `SqlTransaction` and permanently remove image files from disk to prevent storage bloating.
* **Content Moderation:** Monitor campus listings, manage institutional categories, departments, and resolve student dispute tickets.

---

## 🏗️ System Architecture & Tech Stack

```
Presentation Layer (UI)  --> ASP.NET Web Forms (.aspx), Bootstrap 5.3, FontAwesome 6, Custom CSS
Business Logic Layer     --> C# (.NET Framework 4.8), Code-Behind (.aspx.cs), SHA-256 Hashing
Data Access Layer        --> ADO.NET (System.Data.SqlClient), Parameterized Queries, SqlTransactions
Database Layer           --> Microsoft SQL Server (14 Normalized Relational Tables)
Web Server               --> Microsoft IIS / IIS Express
```

---

## 🚀 Getting Started Locally

### Prerequisites
* **Visual Studio 2019 or 2022** (with *.NET desktop development* and *ASP.NET and web development* workloads)
* **Microsoft SQL Server** (2016 or newer / SQL Server Express / Developer Edition)
* **SQL Server Management Studio (SSMS)**

---

### Step 1: Clone the Repository
```bash
git clone https://github.com/<your-username>/StudySwap.git
cd StudySwap
```

---

### Step 2: Set Up the Database
1. Open **SQL Server Management Studio (SSMS)** and connect to your local server (`.` or `localhost`).
2. Open the file **`StudySwap_Database.sql`** located in the root of this project.
3. Click **Execute** (or press `F5`).
   * *This will automatically create the `StudySwap` database, 14 normalized tables, foreign keys, and seed all initial master data, demo users, and listings.*

---

### Step 3: Verify the Connection String
Open `StudySwap/Web.config` and ensure the connection string points to your SQL Server instance:
```xml
<connectionStrings>
    <add name="LIS" connectionString="Data Source=.;Initial Catalog=StudySwap;Integrated Security=True" providerName="System.Data.SqlClient"/>
</connectionStrings>
```
*(If you are using SQL Server Express, change `Data Source=.` to `Data Source=.\SQLEXPRESS`)*.

---

### Step 4: Run the Application
1. Double-click **`StudySwap.sln`** to open the solution in Visual Studio.
2. In Visual Studio, set `StudySwap` as the StartUp Project.
3. Press **`Ctrl + F5`** (or click the green **IIS Express** button).
4. The application will launch in your browser at `http://localhost:62149/`.

---

## 🔑 Demo Credentials

| Role | Email / Username | Password | Notes |
| :--- | :--- | :--- | :--- |
| **System Admin** | `admin@gmail.com` | `admin123` | Full access to Admin Dashboard, student approvals, and batch purge. |
| **Verified Student (Demo)** | `demo@studyswap.com` | `demo123` | Aarav Sharma (3rd Year CSE, Roll: `CS-2024-001`). Pre-seeded with 5 listings and history. |
| **Passout Student (4th Year)** | `avinashgavhane49@gmail.com` | `avinash123` | Avinash Gavhane (4th Year IT). Used to demonstrate the Passout Cohort Purge feature. |

---

## 🔒 Security Implementations

* **Zero SQL Injection:** All database queries utilize parameterized ADO.NET commands (`cmd.Parameters.AddWithValue`).
* **Cryptographic Hashing:** Passwords are never stored in plaintext; hashed using **SHA-256 (256-bit Secure Hash Algorithm)**.
* **Defensive Session Guard:** Master pages intercept unauthenticated visits and safely redirect to `/Login.aspx` without throwing null reference exceptions.
* **Atomic Deletions:** Multi-table cascading operations are wrapped inside transactional boundaries (`SqlTransaction`) to maintain strict ACID compliance.

---

## 📄 License
This project was developed for academic evaluation and campus peer-to-peer sustainability. Distributed under the MIT License.
