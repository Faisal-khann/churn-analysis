# AWS Churn Analytics Pipeline

[![AWS S3](https://img.shields.io/badge/AWS-S3-orange?logo=amazon-s3)](https://aws.amazon.com/s3/)
[![AWS Glue](https://img.shields.io/badge/AWS-Glue-blue?logo=amazonaws)](https://aws.amazon.com/glue/)
[![Amazon Athena](https://img.shields.io/badge/AWS-Athena-purple?logo=amazonaws)](https://aws.amazon.com/athena/)
[![Power BI](https://img.shields.io/badge/PowerBI-Dashboard-yellow?logo=powerbi)](https://powerbi.microsoft.com/)

An end-to-end enterprise data analytics solution designed using the **Medallion Lakehouse Architecture** on **AWS**. The project ingests raw customer data, cleans and optimizes storage formats, builds aggregate analytical views, and delivers high-impact executive insights via a two-page dynamic **Power BI Dashboard**.

---

## Overview
<Em> In today’s competitive business environment, retaining customers is crucial for long-term success. Churn analysis is a key technique used to understand and reduce this customer attrition. It involves examining customer data to identify patterns and reasons behind customer departures. By using advanced data analytics and machine learning, businesses can predict which customers are at risk of leaving and understand the factors driving their decisions. This knowledge allows companies to take proactive steps to improve customer satisfaction and loyalty.</em>

## Who is the Target Audience
<p>Although this project focuses on churn analysis for a telecom firm, the techniques and insights are applicable across various industries. From retail and finance to healthcare and beyond, any business that values customer retention can benefit from churn analysis. We will explore the methods, tools, and best practices for reducing churn and improving customer loyalty, transforming data into actionable insights for sustained success.</p>
---

## Architecture & Data Pipeline Flow

```text
[ Raw CSV Files ]
        │
        ▼
[ S3 Bronze Bucket ] ──► [ AWS Glue Crawler ] ──► [ AWS Glue Data Catalog ]
                                                              │
                                                              ▼
[ S3 Silver Bucket ] ◄── [ Athena SQL Transformations ] ◄─────┘
   (Parquet Format)
        │
        ▼
[ Athena Gold Views ] ──► [ Simba ODBC Driver ] ──► [ Power BI Dashboard ]
```

---

## 📂 Medallion Architecture Setup

### 1. Storage Layer (Amazon S3)

- **Bronze Layer** (`churn-s3-bronze-ap-south-1-dev`): Stores raw landing CSV files (`Customer_Data.csv`) in `ap-south-1`.
- **Silver Layer** (`churn-s3-silver-ap-south-1-dev`): Stores transformed, cleaned, and Snappy-compressed columnar Apache Parquet files to minimize Athena query scanning costs.
- **Gold Layer** (`churn-s3-gold-ap-south-1-dev`): Stores business-ready aggregated outputs and Athena query result logs.

### 2. Metadata & Processing (AWS Glue & Athena)

- **Database Catalog:** `customer_churn_db`
- **Crawler Name:** `churn-bronze-crawler`
- **Bronze Table:** `churn_s3_bronze`
- **Silver Table:** `silver_customer_clean` (Created via SQL CTAS)
- **Gold Analytical View:** `gold_v_customer_churn`

---

## Key DAX Measures & Formulas

Below are the core DAX measures created in Power BI for executive reporting:

```dax
-- 1. Total Customers
Total Customers = COUNT(gold_v_customer_churn[customer_id])

-- 2. Churned Customers
Churned Customers = SUM(gold_v_customer_churn[churn_flag])

-- 3. Overall Churn Rate (%)
Churn Rate % = AVERAGE(gold_v_customer_churn[churn_flag])

-- 4. Churn Revenue Loss ($)
Churn Revenue Loss = 
CALCULATE(
    SUM(gold_v_customer_churn[total_charges]), 
    gold_v_customer_churn[churn_flag] = 1
)

-- 5. Fiber Optic Churn %
Fiber Optic Churn % = 
CALCULATE(
    AVERAGE(gold_v_customer_churn[churn_flag]),
    gold_v_customer_churn[internet_type] = "Fiber Optic"
)
```

---

## Power BI Dashboard Visuals

The dashboard is structured into 2 analytical pages to separate executive strategy from operational root-cause analysis.

### Page 1: Executive Churn Overview

- **Top KPIs:** Total Customers (6,418), Active Customers (4,686), Churned Customers (1,732), Churn Rate (27.0%), Revenue Loss ($2.66M).
- **Contract Risk:** Month-to-Month contracts account for 46.5% of churn.
- **Tenure Risk:** Customers in the `< 6 Months` and `>= 24 Months` groups show specific tenure drop-off behavior.
- **Demographics:** Age groups > 50 have the highest churn rate at 31.0%.

### Page 2: Service & Root Cause Analysis

- **Primary Cause:** Competitor offers drive the largest share of attrition (761 churned customers).
- **Tech Vulnerability:** Fiber Optic accounts for 65.59% of all churned internet subscribers.
- **Geographic Hotspots:** States like Jammu & Kashmir (57.2%) and Assam (38.1%) represent critical high-churn regions.

---

## Tech Stack Used

| Category | Tools |
|---|---|
| **Cloud Services** | AWS S3, AWS Glue Crawler, AWS Glue Data Catalog, Amazon Athena |
| **Query Language** | SQL (Athena DDL/DML, CTAS queries) |
| **Data Storage Formats** | CSV, Snappy-Compressed Parquet |
| **BI & Integration** | Power BI Desktop, Simba Athena ODBC Driver, DAX |
| **Documentation & Modeling** | Medallion Lakehouse Architecture |

---

## How to Run / Reproduce

1. **Upload Dataset:** Land the raw CSV file in your S3 Bronze bucket (`s3://churn-s3-bronze-ap-south-1-dev/`).
2. **Run Glue Crawler:** Execute `churn-bronze-crawler` to register metadata into `customer_churn_db`.
3. **Execute Athena CTAS:** Run the Silver SQL transformation script to generate clean Parquet tables in `churn-s3-silver-ap-south-1-dev`.
4. **Create Gold Views:** Run the Gold view SQL scripts to prepare dynamic business metrics.
5. **Connect Power BI:** Setup Simba Athena ODBC, import `gold_v_customer_churn`, and refresh the `.pbix` dashboard.
