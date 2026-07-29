CREATE OR REPLACE VIEW "customer_churn_db"."gold_v_customer_churn" AS
SELECT 
    customer_id,
    gender,
    age,
    CASE 
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        WHEN age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '65+'
    END AS age_group,
    married,
    state,
    number_of_referrals,
    tenure_in_months,
    CASE 
        WHEN tenure_in_months < 12 THEN '0-1 Year'
        WHEN tenure_in_months BETWEEN 12 AND 36 THEN '1-3 Years'
        ELSE '3+ Years'
    END AS tenure_cohort,
    value_deal,
    phone_service,
    multiple_lines,
    internet_service,
    internet_type,
    online_security,
    online_backup,
    device_protection_plan,
    premium_support,
    streaming_tv,
    streaming_movies,
    streaming_music,
    unlimited_data,
    contract,
    paperless_billing,
    payment_method,
    monthly_charge,
    total_charges,
    total_refunds,
    total_extra_data_charges,
    total_long_distance_charges,
    total_revenue,
    customer_status,
    CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END AS churn_flag,
    churn_category,
    churn_reason
FROM "customer_churn_db"."silver_customer_clean";