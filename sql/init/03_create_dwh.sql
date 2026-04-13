DROP SCHEMA IF EXISTS dwh CASCADE;
CREATE SCHEMA dwh;

CREATE TABLE dwh.dim_country (
    country_id bigserial PRIMARY KEY,
    country_name text NOT NULL UNIQUE
);

CREATE TABLE dwh.dim_pet_type (
    pet_type_id bigserial PRIMARY KEY,
    pet_type_name text NOT NULL UNIQUE
);

CREATE TABLE dwh.dim_pet_breed (
    pet_breed_id bigserial PRIMARY KEY,
    pet_breed_name text NOT NULL UNIQUE
);

CREATE TABLE dwh.dim_pet_category (
    pet_category_id bigserial PRIMARY KEY,
    pet_category_name text NOT NULL UNIQUE
);

CREATE TABLE dwh.dim_product_category (
    product_category_id bigserial PRIMARY KEY,
    product_category_name text NOT NULL UNIQUE
);

CREATE TABLE dwh.dim_product_brand (
    product_brand_id bigserial PRIMARY KEY,
    product_brand_name text NOT NULL UNIQUE
);

CREATE TABLE dwh.dim_product_material (
    product_material_id bigserial PRIMARY KEY,
    product_material_name text NOT NULL UNIQUE
);

CREATE TABLE dwh.dim_product_color (
    product_color_id bigserial PRIMARY KEY,
    product_color_name text NOT NULL UNIQUE
);

CREATE TABLE dwh.dim_product_size (
    product_size_id bigserial PRIMARY KEY,
    product_size_name text NOT NULL UNIQUE
);

CREATE TABLE dwh.dim_date (
    date_id integer PRIMARY KEY,
    date_actual date NOT NULL UNIQUE,
    day_of_month smallint NOT NULL,
    month_of_year smallint NOT NULL,
    quarter_of_year smallint NOT NULL,
    year_number integer NOT NULL
);

CREATE TABLE dwh.dim_customer (
    customer_id bigserial PRIMARY KEY,
    source_customer_id integer NOT NULL UNIQUE,
    first_name text NOT NULL,
    last_name text NOT NULL,
    age integer,
    email text,
    postal_code text,
    country_id bigint REFERENCES dwh.dim_country(country_id)
);

CREATE TABLE dwh.dim_seller (
    seller_id bigserial PRIMARY KEY,
    source_seller_id integer NOT NULL UNIQUE,
    first_name text NOT NULL,
    last_name text NOT NULL,
    email text,
    postal_code text,
    country_id bigint REFERENCES dwh.dim_country(country_id)
);

CREATE TABLE dwh.dim_supplier (
    supplier_id bigserial PRIMARY KEY,
    supplier_name text NOT NULL,
    supplier_contact text NOT NULL,
    supplier_email text NOT NULL,
    supplier_phone text NOT NULL,
    supplier_address text NOT NULL,
    supplier_city text NOT NULL,
    country_id bigint REFERENCES dwh.dim_country(country_id),
    CONSTRAINT uq_dim_supplier UNIQUE (supplier_name, supplier_email, supplier_phone, supplier_address)
);

CREATE TABLE dwh.dim_store (
    store_id bigserial PRIMARY KEY,
    store_name text NOT NULL,
    store_location text NOT NULL,
    store_city text NOT NULL,
    store_state text NOT NULL,
    country_id bigint REFERENCES dwh.dim_country(country_id),
    store_phone text NOT NULL,
    store_email text NOT NULL,
    CONSTRAINT uq_dim_store UNIQUE (store_name, store_location, store_city, store_state, store_phone, store_email)
);

CREATE TABLE dwh.dim_pet (
    pet_id bigserial PRIMARY KEY,
    pet_name text NOT NULL,
    pet_type_id bigint REFERENCES dwh.dim_pet_type(pet_type_id),
    pet_breed_id bigint REFERENCES dwh.dim_pet_breed(pet_breed_id),
    pet_category_id bigint REFERENCES dwh.dim_pet_category(pet_category_id),
    CONSTRAINT uq_dim_pet UNIQUE (pet_name, pet_type_id, pet_breed_id, pet_category_id)
);

CREATE TABLE dwh.dim_product (
    product_id bigserial PRIMARY KEY,
    source_product_id integer NOT NULL UNIQUE,
    product_name text NOT NULL,
    product_category_id bigint REFERENCES dwh.dim_product_category(product_category_id),
    product_brand_id bigint REFERENCES dwh.dim_product_brand(product_brand_id),
    product_material_id bigint REFERENCES dwh.dim_product_material(product_material_id),
    product_color_id bigint REFERENCES dwh.dim_product_color(product_color_id),
    product_size_id bigint REFERENCES dwh.dim_product_size(product_size_id),
    product_description text,
    product_weight numeric(10, 2),
    product_rating numeric(3, 1),
    product_reviews integer,
    product_release_date date,
    product_expiry_date date
);

CREATE TABLE dwh.fact_sales (
    sales_id bigserial PRIMARY KEY,
    source_row_id bigint NOT NULL UNIQUE,
    sale_date_id integer NOT NULL REFERENCES dwh.dim_date(date_id),
    customer_id bigint NOT NULL REFERENCES dwh.dim_customer(customer_id),
    seller_id bigint NOT NULL REFERENCES dwh.dim_seller(seller_id),
    product_id bigint NOT NULL REFERENCES dwh.dim_product(product_id),
    store_id bigint NOT NULL REFERENCES dwh.dim_store(store_id),
    supplier_id bigint NOT NULL REFERENCES dwh.dim_supplier(supplier_id),
    pet_id bigint NOT NULL REFERENCES dwh.dim_pet(pet_id),
    sale_quantity integer NOT NULL,
    sale_total_price numeric(12, 2) NOT NULL,
    product_price numeric(12, 2),
    product_quantity integer
);
