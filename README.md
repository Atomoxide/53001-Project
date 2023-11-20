# 53001-Project

## Initial Draft 11-18-2023

Hybrid DB design with MySQL, MongoDB, and RedisDB

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
* shopping cart
* session management
* user browsing history

## Revision 1 11-19-2023

* Add product_variant entity in MySQL DB and MongoDB. Instead of using different product id for the same product with different
size, color, etc., adding a product_variant help reduce the data size and minimize redundant data
