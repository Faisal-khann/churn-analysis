# ChurnLens: Architecture & Environment Configuration

This document outlines the infrastructure naming conventions, storage buckets, database catalog setup, and dataset flow for the **ChurnLens** AWS pipeline.

---

## AWS Resource & Naming Mapping

### 1. Amazon S3 Bucket Hierarchy
| Layer | Bucket Name | Region | Description |
| :--- | :--- | :--- | :--- |
| **Bronze** | `churn-s3-bronze-ap-south-1-dev` | `ap-south-1` | Stores raw landing CSV dataset (`Customer_Data.csv`) |
| **Silver** | `churn-s3-silver-ap-south-1-dev` | `ap-south-1` | Stores cleaned, Snappy-compressed Parquet files |
| **Gold** | `churn-s3-gold-ap-south-1-dev` | `ap-south-1` | Stores aggregated analytical views and Athena query results |

---

### 2. AWS Glue & Catalog Configuration
* **AWS Glue Database:** `customer_churn_db`
* **Bronze Glue Crawler:** `churn-bronze-crawler`
* **Region:** `ap-south-1` (Mumbai)

---

### 3. Athena Data Catalog Objects (`customer_churn_db`)

| Object Name | Object Type | Storage Layer / Path | Description |
| :--- | :--- | :--- | :--- |
| **`churn_s3_bronze`** | External Table | `s3://churn-s3-bronze-ap-south-1-dev/` | Raw table automatically cataloged via `churn-bronze-crawler` |
| **`silver_customer_clean`** | Physical Table (Parquet) | `s3://churn-s3-silver-ap-south-1-dev/` | Transformed & cleaned data created via Athena CTAS queries |
| **`gold_v_customer_churn`** | Logical View | Derived from `silver_customer_clean` | Aggregated business metrics connected directly to Power BI via ODBC |

---

## End-to-End Execution Flow

1. **Raw Data Ingestion:**
   - Raw dataset uploaded to `s3://churn-s3-bronze-ap-south-1-dev/`.
   - `churn-bronze-crawler` scans the bucket, infers schema, and creates `churn_s3_bronze` inside the `customer_churn_db` database.

2. **Silver Transformation (CTAS):**
   - Transformed raw data into `silver_customer_clean` using Athena SQL.
   - Output stored as Snappy-compressed Parquet files in `s3://churn-s3-silver-ap-south-1-dev/`.
   - Handled missing data logic (~29.6%) and optimized storage size.

3. **Gold View Creation:**
   - Generated analytical view `gold_v_customer_churn` inside `customer_churn_db`.
   - Query outputs saved to `s3://churn-s3-gold-ap-south-1-dev/`.

4. **BI Connection:**
   - Integrated `gold_v_customer_churn` view into **Power BI** using the Simba Athena ODBC Driver.
