USE shop;
desc catalogs;

DROP TABLE IF EXISTS logs; 
CREATE TABLE logs (
	id 						INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	id_of_insert_data	 	INT UNSIGNED NOT NULL,
	`action` 				VARCHAR(255) NOT NULL,
	from_tab				VARCHAR(255) NOT NULL,
	name_tab 			VARCHAR(255) NOT NULL,
	created_at	TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
)
ENGINE=Archive;

DESC logs;

DELIMITER -

CREATE TRIGGER check_catalog_insert
AFTER INSERT ON catalogs
FOR EACH ROW
  BEGIN
    INSERT INTO
      logs (`id_of_insert_data`, `from_tab`, `action`, `name_tab`, `created_at`)
    VALUES
      (NEW.id, 'catalog', 'insert', NEW.name, NOW());
  END-   
  
CREATE TRIGGER check_catalog_update
AFTER UPDATE ON catalogs
FOR EACH ROW
  BEGIN
    INSERT INTO
      logs (`id_of_insert_data`, `from_tab`, `action`, `name_tab`, `created_at`)
    VALUES
      (NEW.id, 'catalog', 'update', NEW.name, NOW());
  END-
  
CREATE TRIGGER check_user_insert
AFTER INSERT ON users
FOR EACH ROW
  BEGIN
    INSERT INTO
      logs (`id_of_insert_data`, `from_tab`, `action`, `name_tab`, `created_at`)
    VALUES
      (NEW.id, 'user', 'insert', NEW.name, NOW());
  END-
  
CREATE TRIGGER check_user_update
AFTER UPDATE ON users
FOR EACH ROW
  BEGIN
    INSERT INTO
      logs (`id_of_insert_data`, `from_tab`, `action`, `name_tab`, `created_at`)
    VALUES
      (NEW.id, 'user', 'update', NEW.name, NOW());
  END-  
  
CREATE TRIGGER check_product_insert
AFTER INSERT ON products
FOR EACH ROW
  BEGIN
    INSERT INTO
      logs (`id_of_insert_data`, `from_tab`, `action`, `name_tab`, `created_at`)
    VALUES
      (NEW.id, 'product', 'insert', NEW.name, NOW());
  END-
  
CREATE TRIGGER check_product_update
AFTER UPDATE ON products
FOR EACH ROW
  BEGIN
    INSERT INTO
      logs (`id_of_insert_data`, `from_tab`, `action`, `name_tab`, `created_at`)
    VALUES
      (NEW.id, 'product', 'update', NEW.name, NOW());
  END-  
  
DELIMITER ;  
  
SHOW TRIGGERS;
  
INSERT INTO `catalogs`(`name`) VALUES ('Звуковая карта');
SELECT * FROM catalogs;
SELECT * FROM logs;
