-- Create Schema
CREATE SCHEMA ecommerce;

-- Set Schema
SET CURRENT SCHEMA ecommerce;

-- 1. Create Users Table
CREATE TABLE Users (
    user_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    address VARCHAR(255),
    phone_number VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create Categories Table
CREATE TABLE Categories (
    category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Create Products Table
CREATE TABLE Products (
    product_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- 4. Create Orders Table
CREATE TABLE Orders (
    order_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,
    order_status VARCHAR(50) DEFAULT 'pending',
    total_amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 5. Create Order_Items Table
CREATE TABLE Order_Items (
    order_item_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 6. Create Payments Table
CREATE TABLE Payments (
    payment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(50) DEFAULT 'pending',
    amount_paid DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- 7. Create Shipping Table
CREATE TABLE Shipping (
    shipping_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INT NOT NULL,
    shipping_address VARCHAR(255) NOT NULL,
    shipping_status VARCHAR(50) DEFAULT 'pending',
    shipped_at TIMESTAMP,
    delivered_at TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- 8. Create Reviews Table
CREATE TABLE Reviews (
    review_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment VARCHAR(255),
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 9. Create Shopping_Carts Table
CREATE TABLE Shopping_Carts (
    cart_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 10. Create Cart_Items Table
CREATE TABLE Cart_Items (
    cart_item_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cart_id) REFERENCES Shopping_Carts(cart_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert Sample Data
-- Insert Users
INSERT INTO Users (username, email, password_hash, first_name, last_name, address, phone_number)
VALUES 
('johndoe', 'johndoe@example.com', 'hashedpassword1', 'John', 'Doe', '123 Main St', '555-1234'),
('janedoe', 'janedoe@example.com', 'hashedpassword2', 'Jane', 'Doe', '456 Oak St', '555-5678');

-- Insert Categories
INSERT INTO Categories (name, description) 
VALUES 
('Electronics', 'Devices, gadgets, and electronics'),
('Books', 'Books of all genres');

-- Insert Products
INSERT INTO Products (name, description, price, stock_quantity, category_id)
VALUES 
('Smartphone', 'Latest model smartphone', 699.99, 50, 1),
('Laptop', 'High-performance laptop', 999.99, 20, 1),
('Novel', 'Bestselling fiction novel', 19.99, 100, 2);

-- Insert Orders
INSERT INTO Orders (user_id, total_amount)
VALUES 
(1, 719.98),
(2, 1019.98);

-- Insert Order_Items
INSERT INTO Order_Items (order_id, product_id, quantity, price)
VALUES 
(1, 1, 1, 699.99),
(2, 2, 1, 999.99);

-- Insert Payments
INSERT INTO Payments (order_id, payment_method, amount_paid)
VALUES 
(1, 'Credit Card', 719.98),
(2, 'PayPal', 1019.98);

-- Insert Shipping
INSERT INTO Shipping (order_id, shipping_address)
VALUES 
(1, '123 Main St'),
(2, '456 Oak St');

-- Insert Reviews
INSERT INTO Reviews (user_id, product_id, rating, comment)
VALUES 
(1, 1, 5, 'Great smartphone!'),
(2, 2, 4, 'Laptop is good, but a bit heavy.');

-- Insert Shopping Cart for user 1
INSERT INTO Shopping_Carts (user_id)
VALUES (1);

-- Insert Cart_Items for user 1's cart
INSERT INTO Cart_Items (cart_id, product_id, quantity)
VALUES 
(1, 3, 2);

SELECT TABLE_NAME
FROM QSYS2.SYSTABLES
WHERE TABLE_SCHEMA = 'ECOMMERCE';

