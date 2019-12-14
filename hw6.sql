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

-- var3
SELECT * FROM  friendship_statuses;
desc friendship;

SELECT 	CONCAT(u.first_name, ' ', u.last_name) AS friend,
		COUNT(from_user_id) AS total_messages 
FROM messages m
	JOIN friendship f
	ON m.from_user_id = f.user_id
	JOIN users u
	ON u.id = m.from_user_id
WHERE to_user_id = 6 OR from_user_id = 6
GROUP BY m.from_user_id 
ORDER BY total_messages DESC LIMIT 1;

SELECT 
  CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(to_user_id) AS messages_count
FROM
  messages m
    JOIN users u
    JOIN friendship f
    ON (f.user_id = m.to_user_id AND f.friend_id = u.id) 
      OR (f.friend_id = m.to_user_id AND f.user_id = u.id)
WHERE to_user_id = 6 AND from_user_id = u.id
GROUP BY name
ORDER BY messages_count DESC LIMIT 1;

-- 3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
-- var1
SELECT SUM(likes) as likes_count FROM (
	SELECT
      (SELECT COUNT(*) 
    	  FROM likes
    		  WHERE target_id = profiles.user_id) AS likes
	  FROM profiles
	  ORDER BY birthday DESC LIMIT 10) AS summ;
-- var2	 
SELECT SUM(likes_per_user) AS likes_total FROM ( 
  SELECT COUNT(*) AS likes_per_user 
    FROM likes 
      WHERE target_type_id = 2
        AND target_id IN (
          SELECT * FROM (
            SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10
          ) AS sorted_profiles 
        ) 
      GROUP BY target_id
) AS counted_likes;
-- var3
SELECT sum(likes) as likes_total FROM(
SELECT 
  p.user_id,
    COUNT(l.id) as likes
FROM
  profiles p
    JOIN likes l
    ON l.target_id = p.user_id AND l.target_type_id = 2
GROUP BY user_id
ORDER BY birthday DESC LIMIT 10) AS coundet_likes;



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

SELECT
  male_likes_count,
  female_likes_count,
  ABS(female_likes_count - male_likes_count) AS difference
FROM
  (SELECT COUNT(*) AS male_likes_count
    FROM
      profiles p
      JOIN likes l
        ON l.user_id = p.user_id AND p.sex = 'm'
  ) AS male_likes,
    (SELECT COUNT(*) AS female_likes_count
    FROM 
      profiles p
      JOIN likes l
        ON l.user_id = p.user_id AND p.sex = 'f'
  ) AS female_likes;

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

SELECT CONCAT(first_name, ' ', last_name) AS user, 
	(SELECT COUNT(*) FROM likes WHERE likes.user_id = users.id) + 
	(SELECT COUNT(*) FROM media WHERE media.user_id = users.id) + 
	(SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id) 
	AS overall_activity 
	FROM users
	ORDER BY overall_activity
	LIMIT 10;

SELECT
  users.id,
  (mes.count + pos.count + lik.count) AS activity,
  (SELECT CONCAT(first_name, ' ', last_name)
   FROM users u1
   WHERE u1.id = users.id
  ) AS name
FROM users
  JOIN
  (SELECT
     users.id           AS user_id,
     COUNT(messages.id) AS count
   FROM users
     LEFT JOIN messages
       ON messages.from_user_id = users.id
   GROUP BY users.id
   ORDER BY count ASC, count
  ) AS mes,
  (SELECT
     users.id        AS user_id,
     COUNT(posts.id) AS count
   FROM users
     LEFT JOIN posts
       ON posts.user_id = users.id
   GROUP BY users.id
   ORDER BY count ASC, count
  ) AS pos,
  (SELECT
     users.id        AS user_id,
     COUNT(likes.id) AS count
   FROM users
     LEFT JOIN likes
       ON likes.user_id = users.id
   GROUP BY users.id
   ORDER BY count ASC, count
  ) AS lik
WHERE mes.user_id = users.id
      AND pos.user_id = users.id
      AND lik.user_id = users.id
GROUP BY users.id
ORDER BY activity ASC, activity
LIMIT 10

