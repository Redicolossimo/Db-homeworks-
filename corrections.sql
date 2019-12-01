USE vk;
SHOW TABLES;

SELECT * FROM users LIMIT 10;

SELECT * FROM profiles LIMIT 10;

SELECT * FROM messages LIMIT 10;
UPDATE messages SET
  from_user_id = FLOOR(1 + (RAND() * 100)),
  to_user_id = FLOOR(1 + (RAND() * 100))
;

SELECT * FROM media_types LIMIT 10;
DELETE FROM media_types;
TRUNCATE media_types;

INSERT INTO media_types (name) VALUES
  ('photo'),
  ('video'),
  ('audio')
;

UPDATE media SET media_type_id = FLOOR(1 + (RAND() * 3));

SELECT * FROM media LIMIT 10;
UPDATE media SET user_id = FLOOR(1 + (RAND() * 100));
UPDATE media SET metadata = CONCAT('{"', filename, '":"', size, '"}');
ALTER TABLE media MODIFY COLUMN metadata JSON;

SELECT * FROM friendship LIMIT 100;
-- Мне нравится как у меня получилось, у одного человека можжет быть несколько друзей,насколько это имеет право на жизнь в таком виде?
UPDATE friendship SET
  user_id = FLOOR(1 + (RAND() * 100)),
  friend_id = FLOOR(1 + (RAND() * 100))
;

DESC friendship;

SELECT * FROM communities LIMIT 10;

SELECT * FROM communities_users LIMIT 10;
SELECT * FROM communities ORDER BY id DESC LIMIT 1;
UPDATE communities_users SET
  community_id = FLOOR(1 + (RAND() * 100)),
  user_id = FLOOR(1 + (RAND() * 100))
;
ALTER TABLE profiles MODIFY COLUMN photo_id INT;

CREATE TABLE user_privacy (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,  
  user_id INT UNSIGNED NOT NULL,
  section_id INT UNSIGNED NOT NULL,
  privacy_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
);

CREATE TABLE section (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,  
  name VARCHAR(255) NOT NULL
);

INSERT INTO `section` (`id`, `name`) VALUES (1, 'Кто видит основную информацию моей страницы');
INSERT INTO `section` (`id`, `name`) VALUES (2, 'Кто видит фотографии, на которых меня отметили');
INSERT INTO `section` (`id`, `name`) VALUES (3, 'Кто видит список моих сохранённых фотографий');
INSERT INTO `section` (`id`, `name`) VALUES (4, 'Кто видит список моих групп');

CREATE TABLE privacy (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,  
  name VARCHAR(255) NOT NULL
);

INSERT INTO `privacy` (`id`, `name`) VALUES (1, 'Все пользователи');
INSERT INTO `privacy` (`id`, `name`) VALUES (2, 'Только друзья');
INSERT INTO `privacy` (`id`, `name`) VALUES (3, 'Друзья и друзья друзей');
INSERT INTO `privacy` (`id`, `name`) VALUES (4, 'Только я');
INSERT INTO `privacy` (`id`, `name`) VALUES (5, 'Все кроме...');
INSERT INTO `privacy` (`id`, `name`) VALUES (6, 'Некоторые друзья');

CREATE TABLE privacy_except_user (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,  
  user_id INT UNSIGNED NOT NULL,
  friend_id INT UNSIGNED NOT NULL,
  privacy_id INT UNSIGNED NOT NULL
);

DESC communities;
ALTER TABLE communities ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER name;
ALTER TABLE communities ADD COLUMN is_closed BOOLEAN AFTER created_at;
ALTER TABLE communities ADD COLUMN closed_at TIMESTAMP AFTER is_closed;

UPDATE communities SET is_closed = TRUE WHERE id IN (3, 14, 27, 56);
UPDATE communities SET closed_at = NOW() WHERE is_closed IS TRUE;

DESC communities_users;
ALTER TABLE communities_users ADD column is_banned BOOLEAN AFTER user_id;
ALTER TABLE communities_users ADD column is_admin BOOLEAN AFTER user_id;

UPDATE communities_users SET is_banned = TRUE WHERE user_id IN (8, 65, 87);
UPDATE communities_users SET is_admin = TRUE WHERE user_id IN (1, 56, 74, 12, 34);

DESC messages;

ALTER TABLE messages ADD column attached_media_id INT UNSIGNED AFTER body;

UPDATE messages SET attached_media_id = (
  SELECT id FROM media WHERE user_id = from_user_id LIMIT 1
);

