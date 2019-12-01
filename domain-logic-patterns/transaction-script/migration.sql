CREATE TABLE products (id INT PRIMARY KEY, name VARCHAR, type VARCHAR)
CREATE TABLE contracts (id INT PRIMARY KEY, product INT, revenue DECIMAL, date_signed DATE)
CREATE TABLE revenue_recognitions (contract INT, amount DECIMAL, recognized_on DATE, PRIMARY KEY (contract, recognized_on))