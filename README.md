# 53001-Project

## Name and CNetID

Name: Ziyang Yuan

Group: 17

CNetID: ziyangy

Email: ziyangy@uchicago.edu

This project is completed solely by Ziyang.

## Structure Overview

![alt text](https://github.com/Atomoxide/53001-Project/blob/main/structure%20diagram.png)

### MySQL for:
* user management
* product stock
* product category
* product brand/retailer/manufacturer
* order management
* shipment
* payment
* return
* phone numbers, addresses, emails

### MongoDB for:
* product attributes
* product image links

### RedisDB for:
* session management
* shopping cart
* user browsing history
* user searching history

## Relational Database: MySQL

### Schema
* Schema script can be found at [https://github.com/Atomoxide/53001-Project/blob/main/SQL/sql_schema.sql](https://github.com/Atomoxide/53001-Project/blob/main/SQL/sql_schema.sql)

### Table: Product, Product_variant, Product_stock, Stock
* Product table keep track of each product and its brand, retailer, manufacturer, and category. The product_id is shared with corresponding fields in RedisDB and MongoDB.
* product_variant store the variant of a product, such as color, size, etc. A variant_type field stores the description of variant (e.g. "White, XL"). product_variant_id is shared with the corresponding field in MongoDB. If every product must have one product variant. For those products that do not have customer options (color, size, etc.), a default product variant will be created.
* product_stock is the linker table between product_variant and stock.
* stock records the stock information of product_variant (instead of product!). A product variant can have multiple stock place, and a stock place can stock multiple product variants.


### Table: Category, Brand 
* Category stores the name of each product category ("headphone", "women dress", "decorate", etc.)
* Brand table stores the name and holding company for each brand. And every product should connect to one brand

### Table: Company
* Company table stores the information of each partner company. Partner companies include product manufacturer, branding company, retailer, shipper, credit/debit card company.
* Company inforamtion include email, phone, address, all foreign key referring to the corresponding tables

### Table: Email, Phone_number, Address, City, Country
* email table stores all email addresses used by the system. Including partner company's emails and user's emails
* phone_number table stores all phone numbers used by the system. Including partner company's numbers and user's numbers
* address table stores all addresses used by the system. Including partner company's address, shipping addresses, and billing addresses. city_id field is foreign key referring to city table
* city table stores the name of cities. It also record whether shipment is available in each city area. country_id refers to country table
* country table stores the name of countries


## Acknowledgement
This project is completed with the assistance of ChatGPT 3.5:
OpenAI. (2023). ChatGPT [Large language model]. https://chat.openai.com
https://chat.openai.com/share/9d7ca431-b671-40a3-ac79-3dda6f4537e7

ChatGPT listed the pros and cons of different databases and helped assigning each parts in the database of best fit.

## Revision History

### Initial Draft (11-18-2023)

Hybrid DB design with MySQL, MongoDB, and RedisDB


### Revision 1 (11-19-2023)

* Add product_variant entity in MySQL DB and MongoDB. Instead of using different product id for the same product with different
size, color, etc., adding a product_variant help reduce the data size and minimize redundant data

### Revision 2 (11-20-2023)
* Updat RedisDB part to use separate buckets for shopping cart, browsing history, browsing history timer, and searching history

### Revision 3 (11-21-2023)
* Update Return table from SQL DB
  - add order_id foreign key to associate return with certain order
  - add product_variant_id foreign key to associate return with certain product
* Update field names in multiple tables to keep consistant
* Add shipping_method table
* change table name "order" to "customer_order" to prevent naming conflict with MySQL command
* change table name "return" to "order_return" to prevent naming conflict with MySQL command

### Revision 4 (11-22-2023)
* Update Product collection from Document Database
  - add product variant id
  - move general attributes out from variant attributes
* re-formate structure diagram

### Revision 5 (11-29-2023)
* Update RedisDB bucket names. Now each bucket name is using colons [:] to specify keys
* Update RedisDB code: example_usage.txt to specify the purpose and usage of example.rediscmd
