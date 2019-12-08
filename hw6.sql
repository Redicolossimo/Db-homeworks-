USE vk;
SELECT * FROM users WHERE id = 3;

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO target_types (name) VALUES 
  ('message'),
  ('user'),
  ('photo'),
  ('video'),
  ('post');

-- Заполняем лайки
INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 5)),
    CURRENT_TIMESTAMP 
  FROM messages;

-- Проверим
SELECT * FROM likes LIMIT 10;


-- Добавим таблицу постов
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INT UNSIGNED NOT NULL,
  header VARCHAR(255),
  body TEXT,
  attached_media_id INT UNSIGNED,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO posts
	SELECT
		id,
    FLOOR(1 + (RAND() * 100)),
    'header',
    body,
    NULL,
    CURRENT_TIMESTAMP
	FROM messages;

UPDATE posts SET attached_media_id = FLOOR(1 + (RAND() * 100)) 
  WHERE id IN (8,52,89,5,15);

SELECT * FROM posts LIMIT 10;



SELECT * FROM messages;
SELECT * FROM friendship;
SELECT * FROM profiles;


DESCRIBE messages;

-- 2. Пусть задан некоторый пользователь.
-- Из всех друзей этого пользователя найдите человека, который больше всех общался
-- с нашим пользователем.
-- var1
SELECT 
  id,
  first_name,
  last_name,
  (SELECT COUNT(*) FROM messages WHERE from_user_id = users.id AND to_user_id = 6 ) AS messages_count
FROM
  users
WHERE
  id = (SELECT user_id FROM friendship WHERE friend_id = 6)
OR
  id = (SELECT friend_id FROM friendship WHERE user_id = 6)
ORDER BY 
  (SELECT COUNT(*) count FROM messages WHERE from_user_id = users.id AND to_user_id = 6 )
DESC LIMIT 1;

-- var2

SELECT 
from_user_id AS from_user,
COUNT(from_user_id) AS message_count
FROM messages
WHERE to_user_id = 6 AND to_user_id = (SELECT user_id FROM friendship WHERE friendship.friend_id = messages.from_user_id)
GROUP BY from_user_id 
ORDER BY message_count DESC LIMIT 1;

-- 3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

SELECT SUM(likes) as likes_count
FROM (SELECT
    		(SELECT COUNT(*) FROM likes WHERE target_id = profiles.user_id) AS likes
	  FROM profiles
	  ORDER BY birthday DESC LIMIT 10) AS summ;

-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT
  women.women_likes AS men_count,
  men.men_likes AS wemen_count,
  ABS(women.women_likes - men.men_likes)
  AS difference
FROM
  (SELECT COUNT(likes.id) AS men_likes
   FROM (SELECT user_id
         FROM profiles
         WHERE profiles.sex = 'm'
         ORDER BY user_id
        ) AS men, 
        likes
   WHERE likes.user_id = men.user_id
   ORDER BY men_likes) AS men,
  (SELECT COUNT(likes.id) AS women_likes
   FROM (SELECT user_id
         FROM profiles
         WHERE profiles.sex = 'f'
         ORDER BY user_id
        ) AS women, likes
   WHERE likes.user_id = women.user_id
   ORDER BY women_likes) AS women
ORDER BY NULL;

-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании
-- социальной сети.
-- исхожу из того что активность человека в соцсети это  сообщения, посты и лайки, отсюда получаю общую активность пользователя
-- дальше выводим общую активность пользователей в соответствии с их id сортируем от меньшего к большему отбираем 10 записей. 


SELECT 
  users.id AS person, 
  (SELECT COUNT(*) FROM likes l WHERE user_id = users.id) +
  (SELECT COUNT(*) FROM messages m WHERE from_user_id = users.id) +
  (SELECT COUNT(*) FROM posts p WHERE user_id = users.id) AS total_activity
FROM users ORDER BY total_activity LIMIT 10;
