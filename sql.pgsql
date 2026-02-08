CREATE DATABASE phones_sales;
-- DROP DATABASE phones_sales; 

-- customers 
CREATE TABLE IF NOT EXISTS customers (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(64) NOT NULL,
  last_name VARCHAR(64) NOT NULL,
  email VARCHAR(64) CHECK (email <> ''),
  tel CHAR(13) NOT NULL UNIQUE CHECK (tel LIKE '+%')
);

INSERT INTO customers (first_name, last_name, email, tel)
VALUES
  ('Олександр', 'Ковальчук', 'oleksandr.kovalchuk@gmail.com', '+380671234567'),
  ('Марія', 'Шевченко', 'maria.shevchenko@gmail.com', '+380931112233'),
  ('Іван', 'Мельник', 'ivan.melnyk@gmail.com', '+380501234890'),
  ('Олена', 'Бондаренко', 'olena.bondarenko@gmail.com', '+380631998877'),
  ('Андрій', 'Ткаченко', 'andrii.tkachenko@gmail.com', '+380981234321'),
  ('Наталія', 'Романюк', 'nataliia.romaniuk@gmail.com', '+380661112244'),
  ('Дмитро', 'Савченко', 'dmytro.savchenko@gmail.com', '+380731234555'),
  ('Ірина', 'Лисенко', 'iryna.lysenko@gmail.com', '+380951234678'),
  ('Богдан', 'Петрук', 'bohdan.petruk@gmail.com', '+380681234999');


-- phones 
CREATE TABLE phones (
  id SERIAL PRIMARY KEY,
  brand VARCHAR(32) NOT NULL,
  model VARCHAR(32) NOT NULL,
  price numeric(10, 2) CHECK (price > 0) NOT NULL,
  color VARCHAR(32),
  manufactured_year SMALLINT CHECK (
    manufactured_year BETWEEN 1970 AND EXTRACT(year FROM CURRENT_DATE)
  )
);

INSERT INTO phones (brand, model, price, color, manufactured_year)
VALUES
  ('Samsung', 'Galaxy S10', 550.00, 'black', 2019),
  ('Samsung', 'Galaxy S21', 750.00, 'white', 2021),
  ('Samsung', 'Galaxy A52', 420.00, 'blue', 2021),
  ('Samsung', 'Galaxy S23', 950.00, 'green', 2023),
  ('Apple', 'iPhone 11', 650.00, 'black', 2019),
  ('Apple', 'iPhone 12', 800.00, 'white', 2020),
  ('Apple', 'iPhone 13', 900.00, 'blue', 2021),
  ('Apple', 'iPhone 14', 1050.00, 'purple', 2022),
  ('Apple', 'iPhone 15', 1200.00, 'black', 2023);

-- orders 
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  customer_id INTEGER REFERENCES customers (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  created_at TIMESTAMP NOT NULL CHECK (created_at < CURRENT_TIMESTAMP) DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO orders (customer_id, created_at)
VALUES
  (1, '2023-01-15'),
  (2, '2023-02-10'),
  (3, '2022-11-05'),
  (3, '2023-03-22'),
  (4, '2022-09-18'),
  (5, '2023-04-01'),
  (6, '2023-01-28');

-- phones_to_orders 
CREATE TABLE phones_to_orders (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  phone_id INTEGER REFERENCES phones (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  amount SMALLINT CHECK (amount > 0),
  UNIQUE (order_id, phone_id)
);

INSERT INTO phones_to_orders (phone_id, order_id, amount)
VALUES
  (5, 1, 1), -- iPhone 11
  (2, 2, 1), -- Galaxy S21
  (3, 2, 2), -- Galaxy A52
  (7, 3, 1), -- iPhone 13
  (1, 4, 1), -- Galaxy S10
  (9, 5, 1), -- iPhone 15
  (4, 6, 2); -- Galaxy S23

-- DROP TABLE IF EXISTS phones_to_orders; 
-- DROP TABLE IF EXISTS orders; 
-- DROP TABLE IF EXISTS phones; 
-- DROP TABLE IF EXISTS customers;