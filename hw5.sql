CREATE DATABASE lesson5db;
USE lesson5db;
SHOW DATABASES;
SELECT * FROM catalogs;

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

-- ������������ ������� 5. ����������, ����������, ���������� � �����������
-- 1. ����� � ������� users ���� created_at � updated_at ��������� ��������������.
-- ��������� �� �������� ����� � ��������.

SELECT * FROM users;
DESCRIBE users;
UPDATE users SET created_at=NOW(), updated_at=NOW();

-- 2. ������� users ���� �������� ��������������.
-- ������ created_at � updated_at ���� ������ ����� VARCHAR � � ��� ������ ����� 
-- ���������� �������� � ������� "20.10.2017 8:10". 
-- ���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������.

ALTER TABLE `users`
MODIFY COLUMN `updated_at` VARCHAR(200);

ALTER TABLE `users`
MODIFY COLUMN `created_at` VARCHAR(200);

ALTER TABLE `users`
MODIFY COLUMN `updated_at` DATETIME;

ALTER TABLE `users`
MODIFY COLUMN `created_at` DATETIME;

-- 3. � ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����:
-- 0, ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������. 
-- ���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ���������� �������� value. 
-- ������, ������� ������ ������ ���������� � �����, ����� ���� �������.

SELECT * FROM storehouses_products;
DESCRIBE storehouses_products;
-- ���������� ��������� �������� ��� ���� value �������� ����������� ���
INSERT INTO `storehouses_products` (`storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`)
VALUES (NULL, NULL, RAND()*10000, NULL, NULL);
-- ���������� ������� �������� ��� ���� value ������� ���������� ���
INSERT INTO `storehouses_products` (`storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`)
VALUES (NULL, NULL, 0, NULL, NULL);
-- ������� � ����������� �� �������
SELECT * FROM storehouses_products ORDER BY value=0, value;
-- ��� ���
SELECT * FROM storehouses_products ORDER BY value > 0 DESC, value ASC;

-- 4.(�� �������) �� ������� users ���������� ������� �������������, ���������� � ������� � ���. 
-- ������ ������ � ���� ������ ���������� �������� ('may', 'august')

SELECT name, DATE_FORMAT(birthday_at, '%M') AS b_month
FROM users
WHERE DATE_FORMAT(birthday_at, '%M') = 'may'
OR DATE_FORMAT(birthday_at, '%M') = 'august';
-- 5.(�� �������) �� ������� catalogs ����������� ������ ��� ������ �������.
--  SELECT * FROM catalogs WHERE id IN (5, 1, 2);
--  ������������ ������ � �������, �������� � ������ IN.

SELECT * FROM catalogs WHERE id IN(5, 1, 2) ORDER BY id < 5, id ASC;

-- ������������ ������� 5. ���������� �������
-- 1. ����������� ������� ������� ������������� � ������� users.

SELECT name, TIMESTAMPDIFF(YEAR, birthday_at, NOW()) AS age FROM users; 
SELECT FLOOR(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))) AS age_avg  FROM users;

-- 2. ����������� ���������� ���� ��������, ������� ���������� �� ������ �� ���� ������. 
-- ������� ������, ��� ���������� ��� ������ �������� ����, � �� ���� ��������.

SELECT * FROM users;
DESCRIBE users;

SELECT GROUP_CONCAT(name SEPARATOR ',') AS names,
DAYOFWEEK(CONCAT_WS('-', DATE_FORMAT(birthday_at, '%d-%m'),
DATE_FORMAT(NOW(), '%y'))) AS dw_birth,
COUNT(DAYOFWEEK(CONCAT_WS('-', DATE_FORMAT(birthday_at, '%d-%m'),
DATE_FORMAT(NOW(), '%y')))) AS count_ppl FROM users GROUP BY dw_birth;


