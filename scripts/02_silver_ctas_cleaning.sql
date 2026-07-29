-- CTAS Query for Silver Parquet
CREATE TABLE "customer_churn_db"."silver_customer_clean"
WITH (
    format = 'PARQUET',
    external_location = 's3://churn-s3-silver/cleaned-data/'
) AS
SELECT 
    customer_id,
    gender,
    COALESCE(age, 0) AS age,
    COALESCE(married, 'No') AS married,
    COALESCE(state, 'Unknown') AS state,
    COALESCE(number_of_referrals, 0) AS number_of_referrals,
    COALESCE(tenure_in_months, 0) AS tenure_in_months,
    COALESCE(NULLIF(value_deal, ''), 'None') AS value_deal,
    COALESCE(NULLIF(phone_service, ''), 'No') AS phone_service,
    COALESCE(NULLIF(multiple_lines, ''), 'No') AS multiple_lines,
    COALESCE(NULLIF(internet_service, ''), 'No') AS internet_service,
    COALESCE(NULLIF(internet_type, ''), 'None') AS internet_type,
    COALESCE(NULLIF(online_security, ''), 'No') AS online_security,
    COALESCE(NULLIF(online_backup, ''), 'No') AS online_backup,
    COALESCE(NULLIF(device_protection_plan, ''), 'No') AS device_protection_plan,
    COALESCE(NULLIF(premium_support, ''), 'No') AS premium_support,
    COALESCE(NULLIF(streaming_tv, ''), 'No') AS streaming_tv,
    COALESCE(NULLIF(streaming_movies, ''), 'No') AS streaming_movies,
    COALESCE(NULLIF(streaming_music, ''), 'No') AS streaming_music,
    COALESCE(NULLIF(unlimited_data, ''), 'No') AS unlimited_data,
    COALESCE(NULLIF(contract, ''), 'Month-to-Month') AS contract,
    COALESCE(NULLIF(paperless_billing, ''), 'No') AS paperless_billing,
    COALESCE(NULLIF(payment_method, ''), 'Unknown') AS payment_method,
    COALESCE(monthly_charge, 0.0) AS monthly_charge,
    COALESCE(total_charges, 0.0) AS total_charges,
    COALESCE(total_refunds, 0.0) AS total_refunds,
    COALESCE(total_extra_data_charges, 0.0) AS total_extra_data_charges,
    COALESCE(total_long_distance_charges, 0.0) AS total_long_distance_charges,
    COALESCE(total_revenue, 0.0) AS total_revenue,
    COALESCE(NULLIF(customer_status, ''), 'Stayed') AS customer_status,
    COALESCE(NULLIF(churn_category, ''), 'N/A') AS churn_category,
    COALESCE(NULLIF(churn_reason, ''), 'N/A') AS churn_reason
FROM "customer_churn_db"."churn_s3_bronze"
WHERE customer_id IS NOT NULL AND customer_id != '';