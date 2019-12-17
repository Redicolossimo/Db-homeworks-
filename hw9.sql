USE shop;
DESC products;
SELECT * FROM products;

-- Практическое задание по теме “Транзакции, переменные, представления”

-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. 
-- Используйте транзакции.

START TRANSACTION;

INSERT INTO sample.users 
SELECT * FROM shop.users WHERE id = 1;

DELETE FROM shop.users WHERE id = 1;

COMMIT;

-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products
--  и соответствующее название каталога name из таблицы catalogs.

CREATE OR REPLACE VIEW product_category(product, category)
AS SELECT 
		p.name, 
        c.name 
	FROM 
		products p 
		JOIN catalogs c 
	WHERE p.catalog_id = c.id;

SELECT * FROM product_category;

-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"

-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DELIMITER //
DROP PROCEDURE IF EXISTS hello;
CREATE PROCEDURE hello()
BEGIN
	DECLARE x INT DEFAULT DATE_FORMAT(CURRENT_TIMESTAMP, "%H");
    IF (x >= 6 AND x < 12) THEN
		SELECT 'доброе утро';
    ELSEIF (x >= 12 AND x < 18) THEN
		SELECT 'добрый день';
	ELSEIF (x >= 18 AND x <= 23) THEN
		SELECT 'добрый вечер';
	ELSEIF (x >= 0 AND x <= 6) THEN
		SELECT 'доброй ночи';
    END IF;
END//
DELIMITER ;

CALL hello();

-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля 
DELIMITER // 

DROP TRIGGER IF EXISTS check_catalog_insert//
CREATE TRIGGER check_catalog_insert BEFORE INSERT ON shop.products
FOR EACH ROW
BEGIN
	IF (NEW.name IS NULL AND NEW.description IS NULL) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NOPE';
	END IF;
	SET NEW.name = COALESCE(NEW.name, 'товар');
	SET NEW.description = COALESCE(NEW.description, 'без описания');
END//

DELIMITER ;

INSERT products(name, description, price, catalog_id, created_at, updated_at)
VALUES (NULL, NULL, 1200.00, 2, NOW(), NOW());

INSERT products(name, description, price, catalog_id, created_at, updated_at)
VALUES (NULL, 'TEST', 1200.00, 2, NOW(), NOW());