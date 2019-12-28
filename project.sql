-- Требования к курсовому проекту:
-- 1. Составить общее текстовое описание БД и решаемых ею задач;
-- 2. минимальное количество таблиц - 10;
-- 3. скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);
-- 4. создать ERDiagram для БД;
-- 5. скрипты наполнения БД данными;
-- 6. скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);
-- 7. представления (минимум 2);
-- 8. хранимые процедуры / триггеры;

-- Description
-- Вариант бд для кинопоиска, включающий фильмы 
-- и пользователей и их взаимодействия (оценки, лайки, обзоры, рецензии)
DROP DATABASE IF EXISTS kinopoisk_db;
CREATE DATABASE kinopoisk_db;
USE kinopoisk_db;

-- Две основные сущности сервиса, пользователей и фильмы

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `last_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(120) COLLATE utf8_unicode_ci NOT NULL,
  `phone` varchar(120) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
 
DROP TABLE IF EXISTS `films`;

CREATE TABLE `films` (
  `id`                   INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `title`                VARCHAR(120) NOT NULL,
  `release_date`         TIMESTAMP    NOT NULL,
  `created_at`           TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`           TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)
  ENGINE = InnoDB;

-- Добавим таблицы с личными данными пользователей и более подробной информацией о фильмах

DROP TABLE IF EXISTS `profiles`;

CREATE TABLE `profiles` (
  `user_id` int(10) unsigned NOT NULL,
  `sex` char(1) COLLATE utf8_unicode_ci NOT NULL,
  `birthday` date DEFAULT NULL,
  `hometown` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `photo_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `film_info`;

CREATE TABLE `film_info` (
  `film_id` int(10) unsigned NOT NULL,
  `film_cat_id` int(10) unsigned NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `staff` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`film_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `category_types`;

CREATE TABLE `category_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Таблица медиа данных и типов медиа

DROP TABLE IF EXISTS `media`;

CREATE TABLE `media` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `media_type_id` int(10) unsigned NOT NULL,
  `film_id` int(10) unsigned NOT NULL,
  `filename` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `size` int(11) NOT NULL,
  `metadata` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `media_types`;

CREATE TABLE `media_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Рецензии, посты и коменты

DROP TABLE IF EXISTS `reviews`;

CREATE TABLE `reviews` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `film_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `body` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `comments`;

CREATE TABLE `comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `from_user_id` int(10) unsigned NOT NULL,
  `to_target_id` int(10) unsigned NOT NULL,
  `target_type_id` INT UNSIGNED NOT NULL,
  `body` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `attached_media_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS posts;

CREATE TABLE posts (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INT UNSIGNED NOT NULL,
  header VARCHAR(255),
  body TEXT,
  attached_media_id INT UNSIGNED,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Добавляем лайки и адресатов

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Теперь добавим связи(внешние ключи)

ALTER TABLE profiles MODIFY COLUMN photo_id INT(10) UNSIGNED; -- правим формат


ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;
      
ALTER TABLE comments 
  ADD CONSTRAINT comments_user_post_id_fk 
    FOREIGN KEY (to_target_id) REFERENCES posts(id),
  ADD CONSTRAINT commets_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT comments_review_id_fk 
    FOREIGN KEY (to_target_id) REFERENCES reviews(id),
  ADD CONSTRAINT coments_target_type_id_fk 
   	FOREIGN KEY (target_type_id) REFERENCES target_types(id),
  ADD CONSTRAINT coments_media_target_id_fk 
    FOREIGN KEY (to_target_id) REFERENCES media(id);  
    
ALTER TABLE film_info
  ADD CONSTRAINT film_info_film_id_fk 
    FOREIGN KEY (film_id) REFERENCES films(id),
  ADD CONSTRAINT film_info_category_types_fk 
    FOREIGN KEY (film_cat_id) REFERENCES category_types(id)
      ON DELETE CASCADE;
      
ALTER TABLE media
  ADD CONSTRAINT media_user_id_fk 
    FOREIGN KEY (film_id) REFERENCES films(id),
  ADD CONSTRAINT media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id);   
    
ALTER TABLE likes
  ADD CONSTRAINT likes_user_post_id_fk 
    FOREIGN KEY (target_id) REFERENCES posts(id),
  ADD CONSTRAINT likes_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT likes_media_target_id_fk 
    FOREIGN KEY (target_id) REFERENCES media(id),
  ADD CONSTRAINT likes_user_target_id_fk 
    FOREIGN KEY (target_id) REFERENCES users(id),
  ADD CONSTRAINT likes_user_review_id_fk 
    FOREIGN KEY (target_id) REFERENCES reviews(id),
  ADD CONSTRAINT likes_target_type_id_fk 
   	FOREIGN KEY (target_type_id) REFERENCES target_types(id);
   
 
ALTER TABLE posts
  ADD CONSTRAINT posts_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT posts_attached_media_id_fk 
    FOREIGN KEY (attached_media_id) REFERENCES media(id);   
   
ALTER TABLE reviews
  ADD CONSTRAINT reviews_film_id_fk 
    FOREIGN KEY (film_id) REFERENCES films(id),
  ADD CONSTRAINT reviews_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id);

-- Некоторые данные заполняем вручную
   
UPDATE media SET film_id = FLOOR(1 + (RAND() * 100));
UPDATE media SET metadata = CONCAT('{"', filename, '":"', size, '"}');
ALTER TABLE media MODIFY COLUMN metadata JSON;


SELECT * FROM likes LIMIT 10;
INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 7)),
    CURRENT_TIMESTAMP 
  FROM comments;
INSERT INTO posts
  SELECT
	id,
    FLOOR(1 + (RAND() * 100)),
    'header',
    body,
    NULL,
    CURRENT_TIMESTAMP
  FROM comments;

UPDATE posts SET attached_media_id = FLOOR(1 + (RAND() * 100)) 
  WHERE id IN (8,52,89,5,15,24,67);

-- Добавим индексы для некоторых наиболее часто используемых полей

CREATE INDEX users_id_idx ON users(id);
CREATE INDEX films_id_idx ON films(id);
CREATE INDEX comments_from_user_id_to_target_id_idx ON comments(from_user_id, to_target_id);
CREATE INDEX media_user_id_media_type_id_idx ON media(film_id, media_type_id);
CREATE INDEX likes_target_id_idx ON likes(target_id);
CREATE INDEX profiles_sex_idx ON profiles(sex);
CREATE INDEX profiles_hometown_idx ON profiles(hometown);
CREATE INDEX film_info_country_idx ON film_info(country);