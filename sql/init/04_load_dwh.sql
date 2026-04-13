WITH cleaned AS (
    SELECT
        NULLIF(trim(id), '')::integer AS row_id,
        trim(customer_first_name) AS customer_first_name,
        trim(customer_last_name) AS customer_last_name,
        NULLIF(trim(customer_age), '')::integer AS customer_age,
        NULLIF(trim(customer_email), '') AS customer_email,
        NULLIF(trim(customer_country), '') AS customer_country,
        NULLIF(trim(customer_postal_code), '') AS customer_postal_code,
        NULLIF(trim(customer_pet_type), '') AS customer_pet_type,
        NULLIF(trim(customer_pet_name), '') AS customer_pet_name,
        NULLIF(trim(customer_pet_breed), '') AS customer_pet_breed,
        trim(seller_first_name) AS seller_first_name,
        trim(seller_last_name) AS seller_last_name,
        NULLIF(trim(seller_email), '') AS seller_email,
        NULLIF(trim(seller_country), '') AS seller_country,
        NULLIF(trim(seller_postal_code), '') AS seller_postal_code,
        trim(product_name) AS product_name,
        NULLIF(trim(product_category), '') AS product_category,
        NULLIF(trim(product_price), '')::numeric(12, 2) AS product_price,
        NULLIF(trim(product_quantity), '')::integer AS product_quantity,
        to_date(NULLIF(trim(sale_date), ''), 'MM/DD/YYYY') AS sale_date,
        NULLIF(trim(sale_customer_id), '')::integer AS sale_customer_id,
        NULLIF(trim(sale_seller_id), '')::integer AS sale_seller_id,
        NULLIF(trim(sale_product_id), '')::integer AS sale_product_id,
        NULLIF(trim(sale_quantity), '')::integer AS sale_quantity,
        NULLIF(trim(sale_total_price), '')::numeric(12, 2) AS sale_total_price,
        trim(store_name) AS store_name,
        COALESCE(NULLIF(trim(store_location), ''), '') AS store_location,
        COALESCE(NULLIF(trim(store_city), ''), '') AS store_city,
        COALESCE(NULLIF(trim(store_state), ''), '') AS store_state,
        NULLIF(trim(store_country), '') AS store_country,
        COALESCE(NULLIF(trim(store_phone), ''), '') AS store_phone,
        COALESCE(NULLIF(trim(store_email), ''), '') AS store_email,
        NULLIF(trim(pet_category), '') AS pet_category,
        NULLIF(trim(product_weight), '')::numeric(10, 2) AS product_weight,
        NULLIF(trim(product_color), '') AS product_color,
        NULLIF(trim(product_size), '') AS product_size,
        NULLIF(trim(product_brand), '') AS product_brand,
        NULLIF(trim(product_material), '') AS product_material,
        NULLIF(product_description, '') AS product_description,
        NULLIF(trim(product_rating), '')::numeric(3, 1) AS product_rating,
        NULLIF(trim(product_reviews), '')::integer AS product_reviews,
        to_date(NULLIF(trim(product_release_date), ''), 'MM/DD/YYYY') AS product_release_date,
        to_date(NULLIF(trim(product_expiry_date), ''), 'MM/DD/YYYY') AS product_expiry_date,
        COALESCE(NULLIF(trim(supplier_name), ''), '') AS supplier_name,
        COALESCE(NULLIF(trim(supplier_contact), ''), '') AS supplier_contact,
        COALESCE(NULLIF(trim(supplier_email), ''), '') AS supplier_email,
        COALESCE(NULLIF(trim(supplier_phone), ''), '') AS supplier_phone,
        COALESCE(NULLIF(trim(supplier_address), ''), '') AS supplier_address,
        COALESCE(NULLIF(trim(supplier_city), ''), '') AS supplier_city,
        NULLIF(trim(supplier_country), '') AS supplier_country
    FROM staging.mock_data_raw
),
all_countries AS (
    SELECT customer_country AS country_name FROM cleaned
    UNION
    SELECT seller_country AS country_name FROM cleaned
    UNION
    SELECT store_country AS country_name FROM cleaned
    UNION
    SELECT supplier_country AS country_name FROM cleaned
)
INSERT INTO dwh.dim_country (country_name)
SELECT DISTINCT country_name
FROM all_countries
WHERE country_name IS NOT NULL
ON CONFLICT (country_name) DO NOTHING;

WITH cleaned AS (
    SELECT
        NULLIF(trim(customer_pet_type), '') AS customer_pet_type,
        NULLIF(trim(customer_pet_breed), '') AS customer_pet_breed,
        NULLIF(trim(pet_category), '') AS pet_category,
        NULLIF(trim(product_category), '') AS product_category,
        NULLIF(trim(product_brand), '') AS product_brand,
        NULLIF(trim(product_material), '') AS product_material,
        NULLIF(trim(product_color), '') AS product_color,
        NULLIF(trim(product_size), '') AS product_size
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_pet_type (pet_type_name)
SELECT DISTINCT customer_pet_type
FROM cleaned
WHERE customer_pet_type IS NOT NULL
ON CONFLICT (pet_type_name) DO NOTHING;

WITH cleaned AS (
    SELECT NULLIF(trim(customer_pet_breed), '') AS customer_pet_breed
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_pet_breed (pet_breed_name)
SELECT DISTINCT customer_pet_breed
FROM cleaned
WHERE customer_pet_breed IS NOT NULL
ON CONFLICT (pet_breed_name) DO NOTHING;

WITH cleaned AS (
    SELECT NULLIF(trim(pet_category), '') AS pet_category
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_pet_category (pet_category_name)
SELECT DISTINCT pet_category
FROM cleaned
WHERE pet_category IS NOT NULL
ON CONFLICT (pet_category_name) DO NOTHING;

WITH cleaned AS (
    SELECT NULLIF(trim(product_category), '') AS product_category
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_product_category (product_category_name)
SELECT DISTINCT product_category
FROM cleaned
WHERE product_category IS NOT NULL
ON CONFLICT (product_category_name) DO NOTHING;

WITH cleaned AS (
    SELECT NULLIF(trim(product_brand), '') AS product_brand
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_product_brand (product_brand_name)
SELECT DISTINCT product_brand
FROM cleaned
WHERE product_brand IS NOT NULL
ON CONFLICT (product_brand_name) DO NOTHING;

WITH cleaned AS (
    SELECT NULLIF(trim(product_material), '') AS product_material
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_product_material (product_material_name)
SELECT DISTINCT product_material
FROM cleaned
WHERE product_material IS NOT NULL
ON CONFLICT (product_material_name) DO NOTHING;

WITH cleaned AS (
    SELECT NULLIF(trim(product_color), '') AS product_color
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_product_color (product_color_name)
SELECT DISTINCT product_color
FROM cleaned
WHERE product_color IS NOT NULL
ON CONFLICT (product_color_name) DO NOTHING;

WITH cleaned AS (
    SELECT NULLIF(trim(product_size), '') AS product_size
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_product_size (product_size_name)
SELECT DISTINCT product_size
FROM cleaned
WHERE product_size IS NOT NULL
ON CONFLICT (product_size_name) DO NOTHING;

WITH cleaned AS (
    SELECT DISTINCT to_date(NULLIF(trim(sale_date), ''), 'MM/DD/YYYY') AS sale_date
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_date (
    date_id,
    date_actual,
    day_of_month,
    month_of_year,
    quarter_of_year,
    year_number
)
SELECT
    to_char(sale_date, 'YYYYMMDD')::integer AS date_id,
    sale_date AS date_actual,
    extract(day from sale_date)::smallint AS day_of_month,
    extract(month from sale_date)::smallint AS month_of_year,
    extract(quarter from sale_date)::smallint AS quarter_of_year,
    extract(year from sale_date)::integer AS year_number
FROM cleaned
WHERE sale_date IS NOT NULL
ON CONFLICT (date_id) DO NOTHING;

WITH cleaned AS (
    SELECT
        trim(customer_first_name) AS customer_first_name,
        trim(customer_last_name) AS customer_last_name,
        NULLIF(trim(customer_age), '')::integer AS customer_age,
        NULLIF(trim(customer_email), '') AS customer_email,
        NULLIF(trim(customer_postal_code), '') AS customer_postal_code,
        NULLIF(trim(customer_country), '') AS customer_country,
        NULLIF(trim(sale_customer_id), '')::integer AS sale_customer_id
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_customer (
    source_customer_id,
    first_name,
    last_name,
    age,
    email,
    postal_code,
    country_id
)
SELECT DISTINCT
    c.sale_customer_id AS source_customer_id,
    c.customer_first_name AS first_name,
    c.customer_last_name AS last_name,
    c.customer_age AS age,
    c.customer_email AS email,
    c.customer_postal_code AS postal_code,
    dc.country_id
FROM cleaned c
LEFT JOIN dwh.dim_country dc
    ON dc.country_name = c.customer_country
WHERE c.sale_customer_id IS NOT NULL
ON CONFLICT (source_customer_id) DO NOTHING;

WITH cleaned AS (
    SELECT
        trim(seller_first_name) AS seller_first_name,
        trim(seller_last_name) AS seller_last_name,
        NULLIF(trim(seller_email), '') AS seller_email,
        NULLIF(trim(seller_postal_code), '') AS seller_postal_code,
        NULLIF(trim(seller_country), '') AS seller_country,
        NULLIF(trim(sale_seller_id), '')::integer AS sale_seller_id
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_seller (
    source_seller_id,
    first_name,
    last_name,
    email,
    postal_code,
    country_id
)
SELECT DISTINCT
    c.sale_seller_id AS source_seller_id,
    c.seller_first_name AS first_name,
    c.seller_last_name AS last_name,
    c.seller_email AS email,
    c.seller_postal_code AS postal_code,
    dc.country_id
FROM cleaned c
LEFT JOIN dwh.dim_country dc
    ON dc.country_name = c.seller_country
WHERE c.sale_seller_id IS NOT NULL
ON CONFLICT (source_seller_id) DO NOTHING;

WITH cleaned AS (
    SELECT
        trim(store_name) AS store_name,
        COALESCE(NULLIF(trim(store_location), ''), '') AS store_location,
        COALESCE(NULLIF(trim(store_city), ''), '') AS store_city,
        COALESCE(NULLIF(trim(store_state), ''), '') AS store_state,
        NULLIF(trim(store_country), '') AS store_country,
        COALESCE(NULLIF(trim(store_phone), ''), '') AS store_phone,
        COALESCE(NULLIF(trim(store_email), ''), '') AS store_email
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_store (
    store_name,
    store_location,
    store_city,
    store_state,
    country_id,
    store_phone,
    store_email
)
SELECT DISTINCT
    c.store_name,
    c.store_location,
    c.store_city,
    c.store_state,
    dc.country_id,
    c.store_phone,
    c.store_email
FROM cleaned c
LEFT JOIN dwh.dim_country dc
    ON dc.country_name = c.store_country
ON CONFLICT ON CONSTRAINT uq_dim_store DO NOTHING;

WITH cleaned AS (
    SELECT
        COALESCE(NULLIF(trim(supplier_name), ''), '') AS supplier_name,
        COALESCE(NULLIF(trim(supplier_contact), ''), '') AS supplier_contact,
        COALESCE(NULLIF(trim(supplier_email), ''), '') AS supplier_email,
        COALESCE(NULLIF(trim(supplier_phone), ''), '') AS supplier_phone,
        COALESCE(NULLIF(trim(supplier_address), ''), '') AS supplier_address,
        COALESCE(NULLIF(trim(supplier_city), ''), '') AS supplier_city,
        NULLIF(trim(supplier_country), '') AS supplier_country
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_supplier (
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    country_id
)
SELECT DISTINCT
    c.supplier_name,
    c.supplier_contact,
    c.supplier_email,
    c.supplier_phone,
    c.supplier_address,
    c.supplier_city,
    dc.country_id
FROM cleaned c
LEFT JOIN dwh.dim_country dc
    ON dc.country_name = c.supplier_country
ON CONFLICT ON CONSTRAINT uq_dim_supplier DO NOTHING;

WITH cleaned AS (
    SELECT
        NULLIF(trim(customer_pet_name), '') AS customer_pet_name,
        NULLIF(trim(customer_pet_type), '') AS customer_pet_type,
        NULLIF(trim(customer_pet_breed), '') AS customer_pet_breed,
        NULLIF(trim(pet_category), '') AS pet_category
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_pet (
    pet_name,
    pet_type_id,
    pet_breed_id,
    pet_category_id
)
SELECT DISTINCT
    c.customer_pet_name AS pet_name,
    dpt.pet_type_id,
    dpb.pet_breed_id,
    dpc.pet_category_id
FROM cleaned c
LEFT JOIN dwh.dim_pet_type dpt
    ON dpt.pet_type_name = c.customer_pet_type
LEFT JOIN dwh.dim_pet_breed dpb
    ON dpb.pet_breed_name = c.customer_pet_breed
LEFT JOIN dwh.dim_pet_category dpc
    ON dpc.pet_category_name = c.pet_category
WHERE c.customer_pet_name IS NOT NULL
ON CONFLICT ON CONSTRAINT uq_dim_pet DO NOTHING;

WITH cleaned AS (
    SELECT
        NULLIF(trim(sale_product_id), '')::integer AS sale_product_id,
        trim(product_name) AS product_name,
        NULLIF(trim(product_category), '') AS product_category,
        NULLIF(trim(product_brand), '') AS product_brand,
        NULLIF(trim(product_material), '') AS product_material,
        NULLIF(trim(product_color), '') AS product_color,
        NULLIF(trim(product_size), '') AS product_size,
        NULLIF(product_description, '') AS product_description,
        NULLIF(trim(product_weight), '')::numeric(10, 2) AS product_weight,
        NULLIF(trim(product_rating), '')::numeric(3, 1) AS product_rating,
        NULLIF(trim(product_reviews), '')::integer AS product_reviews,
        to_date(NULLIF(trim(product_release_date), ''), 'MM/DD/YYYY') AS product_release_date,
        to_date(NULLIF(trim(product_expiry_date), ''), 'MM/DD/YYYY') AS product_expiry_date
    FROM staging.mock_data_raw
)
INSERT INTO dwh.dim_product (
    source_product_id,
    product_name,
    product_category_id,
    product_brand_id,
    product_material_id,
    product_color_id,
    product_size_id,
    product_description,
    product_weight,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date
)
SELECT DISTINCT
    c.sale_product_id AS source_product_id,
    c.product_name,
    dpc.product_category_id,
    dpb.product_brand_id,
    dpm.product_material_id,
    dpc2.product_color_id,
    dps.product_size_id,
    c.product_description,
    c.product_weight,
    c.product_rating,
    c.product_reviews,
    c.product_release_date,
    c.product_expiry_date
FROM cleaned c
LEFT JOIN dwh.dim_product_category dpc
    ON dpc.product_category_name = c.product_category
LEFT JOIN dwh.dim_product_brand dpb
    ON dpb.product_brand_name = c.product_brand
LEFT JOIN dwh.dim_product_material dpm
    ON dpm.product_material_name = c.product_material
LEFT JOIN dwh.dim_product_color dpc2
    ON dpc2.product_color_name = c.product_color
LEFT JOIN dwh.dim_product_size dps
    ON dps.product_size_name = c.product_size
WHERE c.sale_product_id IS NOT NULL
ON CONFLICT (source_product_id) DO NOTHING;

WITH cleaned AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY (SELECT 1))::bigint AS row_id,
        to_date(NULLIF(trim(sale_date), ''), 'MM/DD/YYYY') AS sale_date,
        NULLIF(trim(sale_customer_id), '')::integer AS sale_customer_id,
        NULLIF(trim(sale_seller_id), '')::integer AS sale_seller_id,
        NULLIF(trim(sale_product_id), '')::integer AS sale_product_id,
        NULLIF(trim(sale_quantity), '')::integer AS sale_quantity,
        NULLIF(trim(sale_total_price), '')::numeric(12, 2) AS sale_total_price,
        NULLIF(trim(product_price), '')::numeric(12, 2) AS product_price,
        NULLIF(trim(product_quantity), '')::integer AS product_quantity,
        trim(store_name) AS store_name,
        COALESCE(NULLIF(trim(store_location), ''), '') AS store_location,
        COALESCE(NULLIF(trim(store_city), ''), '') AS store_city,
        COALESCE(NULLIF(trim(store_state), ''), '') AS store_state,
        COALESCE(NULLIF(trim(store_phone), ''), '') AS store_phone,
        COALESCE(NULLIF(trim(store_email), ''), '') AS store_email,
        COALESCE(NULLIF(trim(supplier_name), ''), '') AS supplier_name,
        COALESCE(NULLIF(trim(supplier_email), ''), '') AS supplier_email,
        COALESCE(NULLIF(trim(supplier_phone), ''), '') AS supplier_phone,
        COALESCE(NULLIF(trim(supplier_address), ''), '') AS supplier_address,
        NULLIF(trim(customer_pet_name), '') AS customer_pet_name,
        NULLIF(trim(customer_pet_type), '') AS customer_pet_type,
        NULLIF(trim(customer_pet_breed), '') AS customer_pet_breed,
        NULLIF(trim(pet_category), '') AS pet_category
    FROM staging.mock_data_raw
)
INSERT INTO dwh.fact_sales (
    source_row_id,
    sale_date_id,
    customer_id,
    seller_id,
    product_id,
    store_id,
    supplier_id,
    pet_id,
    sale_quantity,
    sale_total_price,
    product_price,
    product_quantity
)
SELECT
    c.row_id AS source_row_id,
    to_char(c.sale_date, 'YYYYMMDD')::integer AS sale_date_id,
    dc.customer_id,
    ds.seller_id,
    dp.product_id,
    dst.store_id,
    dsu.supplier_id,
    dpet.pet_id,
    c.sale_quantity,
    c.sale_total_price,
    c.product_price,
    c.product_quantity
FROM cleaned c
INNER JOIN dwh.dim_customer dc
    ON dc.source_customer_id = c.sale_customer_id
INNER JOIN dwh.dim_seller ds
    ON ds.source_seller_id = c.sale_seller_id
INNER JOIN dwh.dim_product dp
    ON dp.source_product_id = c.sale_product_id
INNER JOIN dwh.dim_store dst
    ON dst.store_name = c.store_name
   AND dst.store_location = c.store_location
   AND dst.store_city = c.store_city
   AND dst.store_state = c.store_state
   AND dst.store_phone = c.store_phone
   AND dst.store_email = c.store_email
INNER JOIN dwh.dim_supplier dsu
    ON dsu.supplier_name = c.supplier_name
   AND dsu.supplier_email = c.supplier_email
   AND dsu.supplier_phone = c.supplier_phone
   AND dsu.supplier_address = c.supplier_address
INNER JOIN dwh.dim_pet dpet
    ON dpet.pet_name = c.customer_pet_name
INNER JOIN dwh.dim_pet_type dpt
    ON dpt.pet_type_id = dpet.pet_type_id
   AND dpt.pet_type_name = c.customer_pet_type
INNER JOIN dwh.dim_pet_breed dpb
    ON dpb.pet_breed_id = dpet.pet_breed_id
   AND dpb.pet_breed_name = c.customer_pet_breed
INNER JOIN dwh.dim_pet_category dpc
    ON dpc.pet_category_id = dpet.pet_category_id
   AND dpc.pet_category_name = c.pet_category
WHERE c.row_id IS NOT NULL
ON CONFLICT (source_row_id) DO NOTHING;
