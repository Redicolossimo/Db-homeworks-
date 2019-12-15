USE shop;
DESC products;
SELECT * FROM products;

-- ������������ ������� �� ���� �����������, ����������, ��������������

-- 1. � ���� ������ shop � sample ������������ ���� � �� �� �������, ������� ���� ������. 
-- ����������� ������ id = 1 �� ������� shop.users � ������� sample.users. 
-- ����������� ����������.

START TRANSACTION;

INSERT INTO sample.users 
SELECT * FROM shop.users WHERE id = 1;

DELETE FROM shop.users WHERE id = 1;

COMMIT;

-- 2. �������� �������������, ������� ������� �������� name �������� ������� �� ������� products
--  � ��������������� �������� �������� name �� ������� catalogs.

CREATE OR REPLACE VIEW product_category(product, category)
AS SELECT 
		p.name, 
        c.name 
	FROM 
		products p 
		JOIN catalogs c 
	WHERE p.catalog_id = c.id;

SELECT * FROM product_category;

-- ������������ ������� �� ���� ��������� ��������� � �������, ��������"

-- 1. �������� �������� ������� hello(), ������� ����� ���������� �����������, � ����������� �� �������� ������� �����.
-- � 6:00 �� 12:00 ������� ������ ���������� ����� "������ ����",
-- � 12:00 �� 18:00 ������� ������ ���������� ����� "������ ����",
-- � 18:00 �� 00:00 � "������ �����", � 00:00 �� 6:00 � "������ ����".

DELIMITER //
DROP PROCEDURE IF EXISTS hello;
CREATE PROCEDURE hello()
BEGIN
	DECLARE x INT DEFAULT DATE_FORMAT(CURRENT_TIMESTAMP, "%H");
    IF (x >= 6 AND x < 12) THEN
		SELECT '������ ����';
    ELSEIF (x >= 12 AND x < 18) THEN
		SELECT '������ ����';
	ELSEIF (x >= 18 AND x <= 23) THEN
		SELECT '������ �����';
	ELSEIF (x >= 0 AND x <= 6) THEN
		SELECT '������ ����';
    END IF;
END//
DELIMITER ;

CALL hello();

-- 2. � ������� products ���� ��� ��������� ����: name � ��������� ������ � description � ��� ���������. 
-- ��������� ����������� ����� ����� ��� ���� �� ���. ��������, ����� ��� ���� 
DELIMITER // 

DROP TRIGGER IF EXISTS check_catalog_insert//
CREATE TRIGGER check_catalog_insert BEFORE INSERT ON shop.products
FOR EACH ROW
BEGIN
	IF (NEW.name IS NULL AND NEW.description IS NULL) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NOPE';
	END IF;
	SET NEW.name = COALESCE(NEW.name, '�����');
	SET NEW.description = COALESCE(NEW.description, '��� ��������');
END//

DELIMITER ;

INSERT products(name, description, price, catalog_id, created_at, updated_at)
VALUES (NULL, NULL, 1200.00, 2, NOW(), NOW());

INSERT products(name, description, price, catalog_id, created_at, updated_at)
VALUES (NULL, 'TEST', 1200.00, 2, NOW(), NOW());