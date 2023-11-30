# 53001-Project

## Hybrid Databse Design Structure

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
* Update RedisDB bucket names
* Update RedisDB code
