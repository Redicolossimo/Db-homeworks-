-- CREATE DATABASE shop;
-- USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '�������� �������',
  UNIQUE unique_name(name(10))
) COMMENT = '������� ��������-��������';

INSERT INTO catalogs VALUES
  (NULL, '����������'),
  (NULL, '����������� �����'),
  (NULL, '����������'),
  (NULL, '������� �����'),
  (NULL, '����������� ������');

DROP TABLE IF EXISTS rubrics;
CREATE TABLE rubrics (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '�������� �������'
) COMMENT = '������� ��������-��������';

INSERT INTO rubrics VALUES
  (NULL, '����������'),
  (NULL, '������');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '����������';

INSERT INTO users (name, birthday_at) VALUES
  ('��������', '1990-10-05'),
  ('�������', '1984-11-12'),
  ('���������', '1985-05-20'),
  ('������', '1988-02-14'),
  ('����', '1998-01-12'),
  ('�����', '1992-08-29');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��������',
  description TEXT COMMENT '��������',
  price DECIMAL (11,2) COMMENT '����',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = '�������� �������';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 7890.00, 1),
  ('Intel Core i5-7400', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 12700.00, 1),
  ('AMD FX-8320E', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.', 4780.00, 1),
  ('AMD FX-8320', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', '����������� ����� ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', '����������� ����� Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', '����������� ����� MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = '������';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT '���������� ���������� �������� �������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������ ������';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT '�������� ������ �� 0.0 �� 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = '������';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT '����� �������� ������� �� ������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������ �� ������';

-- 1. ��������� ������ ������������� users, ������� ����������� ���� �� ���� ����� orders � �������� ��������.

SELECT id, name FROM users;

SELECT * FROM orders;

INSERT INTO orders (user_id) VALUE (1);
INSERT INTO orders (user_id) VALUE (3);
INSERT INTO orders (user_id) VALUE (5);
INSERT INTO orders (user_id) VALUE (5);

SELECT id, name FROM users WHERE id IN (SELECT user_id FROM orders);

SELECT user_id FROM orders;

-- 2. �������� ������ ������� products � �������� catalogs, ������� ������������� ������.

SELECT * FROM products; 
SELECT * FROM catalogs;

SELECT id, name, (SELECT name FROM catalogs WHERE id = catalog_id) AS 'catalog'  FROM products;
-- ���
SELECT
	products.id, 
	products.name, 
	(SELECT 
		catalogs.name 
	FROM 
		catalogs 
	WHERE 
		catalogs.id = products.catalog_id) AS 'catalog'
FROM 
	products;
-- ���
SELECT p.id, p.name, c.name FROM catalogs AS c JOIN products AS p ON c.id=p.catalog_id;

-- 3. (�� �������) ����� ������� ������� ������ flights (id, from, to) � ������� ������� cities (label, name).
-- ���� from, to � label �������� ���������� �������� �������, ���� name � �������.
-- �������� ������ ������ flights � �������� ���������� �������.

-- �������� � �������� �������

CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
    `from` VARCHAR(255),
    `to` VARCHAR(255)
);

INSERT INTO flights (`from`, `to`) VALUES ('moscow', 'omsk');
INSERT INTO flights (`from`, `to`) VALUES ('novgorod', 'kazan');
INSERT INTO flights (`from`, `to`) VALUES ('irkutsk', 'moscow');
INSERT INTO flights (`from`, `to`) VALUES ('omsk', 'irkutsk');
INSERT INTO flights (`from`, `to`) VALUES ('moscow', 'kazan');

CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
    label VARCHAR(255),
    name VARCHAR(255)
);

INSERT INTO cities (label, name) VALUES ('moscow','������');
INSERT INTO cities (label, name) VALUES ('omsk', '����');
INSERT INTO cities (label, name) VALUES ('novgorod', '��������');
INSERT INTO cities (label, name) VALUES ('kazan', '������' );
INSERT INTO cities (label, name) VALUES ('irkutsk', '�������' );

SELECT * FROM flights;
SELECT * FROM cities;

SELECT 
	f.id,
	(SELECT c.name FROM cities c where  c.label=f.`from`) AS `from`,
	(SELECT c.name FROM cities c where  c.label=f.`to`) AS`to`
FROM 
	flights f;