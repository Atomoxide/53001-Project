CREATE DATABASE IF NOT EXISTS ecommerce;

USE ecommerce;

CREATE TABLE phone_number
(
    phone_number_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    phone_number    BIGINT UNSIGNED,
    active          BOOL,
    last_update     DATETIME
);

CREATE TABLE email
(
    email_id    INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    email       VARCHAR(100),
    active      BOOL,
    last_update DATETIME
);

CREATE TABLE user
(
    user_id         INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    user_name       VARCHAR(100) NOT NULL,
    hashed_password CHAR(60)     NOT NULL,
    email_id        INT UNSIGNED,
    phone_number_id INT UNSIGNED,
    CONSTRAINT FOREIGN KEY (email_id) REFERENCES email (email_id),
    CONSTRAINT FOREIGN KEY (phone_number_id) REFERENCES phone_number (phone_number_id)
);

CREATE TABLE country
(
    country_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(40)
);


CREATE TABLE city
(
    city_id            SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name               VARCHAR(40),
    country_id         TINYINT UNSIGNED,
    shipment_available BOOL,
    last_update        DATETIME,
    CONSTRAINT FOREIGN KEY (country_id) REFERENCES country (country_id)
);

CREATE TABLE address
(
    address_id      INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    address         VARCHAR(200),
    city_id         SMALLINT UNSIGNED,
    postal_zip_code VARCHAR(10),
    CONSTRAINT FOREIGN KEY (city_id) REFERENCES city (city_id)
);

CREATE TABLE company
(
    company_id      MEDIUMINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    company         VARCHAR(40),
    last_update     DATETIME,
    email_id        INT UNSIGNED,
    address_id      INT UNSIGNED,
    phone_number_id INT UNSIGNED,
    CONSTRAINT FOREIGN KEY (email_id) REFERENCES email (email_id),
    CONSTRAINT FOREIGN KEY (address_id) REFERENCES address (address_id),
    CONSTRAINT FOREIGN KEY (phone_number_id) REFERENCES phone_number (phone_number_id)
);

CREATE TABLE stock
(
    stock_id    SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    counter     SMALLINT UNSIGNED,
    last_update DATETIME,
    address_id  INT UNSIGNED,
    CONSTRAINT FOREIGN KEY (address_id) REFERENCES address (address_id)
);

CREATE TABLE product_variant
(
    product_variant_id MEDIUMINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    product_id         INT UNSIGNED,
    variant_type       VARCHAR(40)
);


CREATE TABLE product_stock
(
    product_stock_id   INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    product_variant_id MEDIUMINT UNSIGNED,
    stock_id           SMALLINT UNSIGNED,
    CONSTRAINT FOREIGN KEY (product_variant_id) REFERENCES product_variant (product_variant_id),
    CONSTRAINT FOREIGN KEY (stock_id) REFERENCES stock (stock_id)
);


CREATE TABLE category
(
    category_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    category    VARCHAR(40)
);

CREATE TABLE brand
(
    brand_id       MEDIUMINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    brand          VARCHAR(40),
    holder_company MEDIUMINT UNSIGNED,
    CONSTRAINT FOREIGN KEY (holder_company) REFERENCES company (company_id)
);

CREATE TABLE product
(
    product_id      INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    brand_id        MEDIUMINT UNSIGNED,
    category_id     SMALLINT UNSIGNED,
    retailer_id     MEDIUMINT UNSIGNED,
    manufacturer_id MEDIUMINT UNSIGNED,
    CONSTRAINT FOREIGN KEY (brand_id) REFERENCES brand (brand_id),
    CONSTRAINT FOREIGN KEY (category_id) REFERENCES category (category_id),
    CONSTRAINT FOREIGN KEY (retailer_id) REFERENCES company (company_id),
    CONSTRAINT FOREIGN KEY (manufacturer_id) REFERENCES company (company_id)
);


CREATE TABLE order_status
(
    order_status_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    status          VARCHAR(40),
    description     TEXT
);


CREATE TABLE return_status
(
    return_status_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    status           VARCHAR(40),
    description      TEXT
);


CREATE TABLE tracking_status
(
    tracking_status_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    status             VARCHAR(40),
    description        TEXT
);


CREATE TABLE shipping_method
(
    shipping_method_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    shipping_method    VARCHAR(40),
    service_company_id MEDIUMINT UNSIGNED,
    base_rate          TINYINT UNSIGNED,
    rate_per_100_km    TINYINT UNSIGNED,
    CONSTRAINT FOREIGN KEY (service_company_id) REFERENCES company (company_id)
);

CREATE TABLE payment_type
(
    payment_type_id     TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    payment_type        VARCHAR(40),
    processing_fee_rate DECIMAL(3, 3),
    service_company_id  MEDIUMINT UNSIGNED,
    CONSTRAINT FOREIGN KEY (service_company_id) REFERENCES company (company_id)
);

CREATE TABLE payment
(
    payment_id         INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    amount             INT UNSIGNED,
    receive_date       DATETIME,
    billing_address_id INT UNSIGNED,
    payment_type_id    TINYINT UNSIGNED,
    CONSTRAINT FOREIGN KEY (billing_address_id) REFERENCES address (address_id),
    CONSTRAINT FOREIGN KEY (payment_type_id) REFERENCES payment_type (payment_type_id)
);

CREATE TABLE shipment
(
    shipment_id         INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    expected_delivery   DATETIME,
    ship_to             VARCHAR(40),
    last_update         DATETIME,
    tracking_number     VARCHAR(40),
    shipping_method_id  TINYINT UNSIGNED,
    shipping_address_id INT UNSIGNED,
    contact_phone_id    INT UNSIGNED,
    tracking_status_id  TINYINT UNSIGNED,
    CONSTRAINT FOREIGN KEY (shipping_method_id) REFERENCES shipping_method (shipping_method_id),
    CONSTRAINT FOREIGN KEY (shipping_address_id) REFERENCES address (address_id),
    CONSTRAINT FOREIGN KEY (contact_phone_id) REFERENCES phone_number (phone_number_id),
    CONSTRAINT FOREIGN KEY (tracking_status_id) REFERENCES tracking_status (tracking_status_id)
);

CREATE TABLE customer_order
(
    order_id        INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    order_date      DATETIME,
    subtotal        INT UNSIGNED,
    ship_cost       INT UNSIGNED,
    processing_fee  INT UNSIGNED,
    estimated_tax   INT UNSIGNED,
    total_amount    INT UNSIGNED,
    user_id         INT UNSIGNED,
    shipment_id     INT UNSIGNED,
    payment_id      INT UNSIGNED,
    order_status_id TINYINT UNSIGNED,
    CONSTRAINT FOREIGN KEY (user_id) REFERENCES user (user_id),
    CONSTRAINT FOREIGN KEY (shipment_id) REFERENCES shipment (shipment_id),
    CONSTRAINT FOREIGN KEY (payment_id) REFERENCES payment (payment_id),
    CONSTRAINT FOREIGN KEY (order_status_id) REFERENCES order_status (order_status_id)
);

CREATE TABLE order_return
(
    return_id          INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    issue_date         DATETIME,
    refund_amount      INT UNSIGNED,
    ship_cost          INT UNSIGNED,
    user_id            INT UNSIGNED,
    shipment_id        INT UNSIGNED,
    return_status_id   TINYINT UNSIGNED,
    order_id           INT UNSIGNED,
    product_variant_id MEDIUMINT UNSIGNED,
    CONSTRAINT FOREIGN KEY (user_id) REFERENCES user (user_id),
    CONSTRAINT FOREIGN KEY (shipment_id) REFERENCES shipment (shipment_id),
    CONSTRAINT FOREIGN KEY (return_status_id) REFERENCES return_status (return_status_id),
    CONSTRAINT FOREIGN KEY (order_id) REFERENCES customer_order (order_id),
    CONSTRAINT FOREIGN KEY (product_variant_id) REFERENCES product_variant (product_variant_id)
);