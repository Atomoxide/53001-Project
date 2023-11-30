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


### Table: User
* stores the user data of each registered user, including username, hashed password, phone and email (foreign key)


### Table: customer_order, payment, order_return, shipment
* customer_order is the order table (named customer_order to avoid conflict in MySQL syntax). It stores the information for each order, including order date, subtotal, shipping cost, processing fee (credit card or any third party payment processing fee), estimated tax, and the total amount. Each order is also associated with an user, a shipment, a payment, and an order status as foreign keys
* payment table stores each payment with its amount and receive date. It also associates with a billing address and a payment type (Visa, Mastercard, Paypal, etc.) as foreign keys
* order_return is the return table (named order_return to avoid conflict in MySQL syntax). It stores the inforamtion for each return, including the return issue date, refund amount, shipping cost. Each return is also associated with a user, a shipment, a return status, an order id (the order that the returning item comes from), and the product variant of the returning item as foreign keys
* shipment table stores each shipment with its ship date, expected delivery, ship-to name (customer name to receive the package), last time of update, and tracking number. It also associates with a shipping method (e.g. over-night express, two-day express, ground, etc.), a shipping address, a contact phone number, and a tracking status (e.g. shipped, in transit, delivered) as foreign keys

### Table: order_status, payment_type, return_status, tracking_status, shipping_method
* order_status stores all possible status of an order, such as paid, shipped, delivered, returned with refund, canceled, etc. and their descriptions.
* payment_type stores all acceptable payment method, such as Visa, Mastercard, Paypal, etc. It also stores the processing fee and the service company (as a foreign key to company table) of the payment method
* return_status stores all possible status of a return, such as accepted, rejected, refunded, canceled, etc. and their descriptions.
* tracking stores all possible status of a shipment, such as shipped, arrive at facility, in transit, out for delivery, delivered, delayed, canceled, etc. and their descriptions.
* shipment_method stores all possible shipment methods, such as express, ground, over-night, etc. It also stores the shipment company (as a foreign key to company table), base rate, and rate per 100 km for each method.

 
### Benefit of Relational DB
* All data in the above field are stored in relational database to ensure ACID compliance (Atomicity, Consistency, Isolation, Durability), maintaining data integrity. Because all of these are critical data of the routine operation and they are not frequently accessed, the data integrity is more important than query speed.
* Due to the importance of data integrety, backup and recovery is easier for relational db.
* Scalability is another consideration. Relational databases can handle significant amounts of data and can scale effectively as the e-commerce website grows, in which case the amount of users, products, companies, addresses, phones, emails, etc. can expand very quickly.
* Relational database also provides the most flexible means of data querying. It can provide various type of querying for backend development and data analysis.


## Document Database: MongoDB

### Database and Example data document:
json data file and explanatory text can be found at [https://github.com/Atomoxide/53001-Project/tree/main/Document_DB](https://github.com/Atomoxide/53001-Project/tree/main/Document_DB)

### Collection: products
* each different product can have different types of attributes (properties), different number of variants, and many other different type of description on the product website.
```
collection: products
|__	products
	|__	"product_id"
	|__	"product_name"
	|__	"first_available"
	|__	"product_attributes"
	|	|__	"product_attribute_1"
	|	|__	"product_attribute_2"
	|	|__	...
	|__	"variant" (optional)
	|	|__	"variant_1"
	|	|	|__ "variant_id"
	|	|	|__	"variant_1_attribute"
	|	|	|	|__	"variant_1_attribute_1"
	|	|	|	|__	"variant_1_attribute_2"
	|	|	|	|__	...
	|	|	|__	"variant_1_image"
	|	|__	"varriant_2"
	|	|	|__ "variant_id"
	|	|	|__	"variant_2_attribute"
	|	|	|	|__	"variant_2_attribute_1"
	|	|	|	|__	"variant_2_attribute_2"
	|	|	|	|__	...
	|	|	|__	"variant_2_image"
	|	|__	...
	|__ "description"
	|__	"image"
```
* "product_id" should matches the corresponding product_id in the product table of the relational database. This means each product in the relational database has a counterpart here in the document database.
* "product_name": name of the product, e.g. "Beats Studio Pro"
* "first_available": the date of first_available
* "product_attributes": properties of the product itself, e.g. connection, weight, and battery life for headphones; material, care instruction of woman dresses; and dimensions, weight for vases.
	- each attribute (property) itself can contain multiple items too. For example, the dimensions property of vases contains length, height, width, and unit (inch) information. See the example for more details.
* "variant": the variant of a product (e.g. color and size of a dress). Not every product have a variant. For those that have, here stores all kinds of variant with the variant_id matching the product_variant table in the relational database.
	- each variant has its own attributes (properties) beside the product attributes, such as the color and the size, which are unique to each variant.
	- variant_image is a list of image URI for specific variant
* "description": text description of the product
* "image": a list of image URI for the product
* **Check out the example json data file linked above to see an actual instance**


## Key-stored Database: RedisDB

### Example Data Bucket and Usage file
* The example data bucket (filed script) and its explanatory usage text file can be found at: [https://github.com/Atomoxide/53001-Project/tree/main/key_value_DB](https://github.com/Atomoxide/53001-Project/tree/main/key_value_DB)

  

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
