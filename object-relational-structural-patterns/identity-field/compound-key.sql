CREATE TABLE orders (id INT PRIMARY KEY, customer VARCHAR)
CREATE TABLE line_items (order_id INT, seq INT, amount INT, product VARCHAR, PRIMARY KEY (order_id, seq))