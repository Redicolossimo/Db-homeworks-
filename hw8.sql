use vk;
DESC profiles;

-- Добавляем внешние ключи
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;

-- Изменяем тип столбца при необходимости
ALTER TABLE profiles DROP FOREIGN KEY profles_user_id_fk;
ALTER TABLE profiles MODIFY COLUMN photo_id INT(10) UNSIGNED;
      
-- Для таблицы сообщений

-- Смотрим структурв таблицы

DESC messages;

-- Добавляем внешние ключи
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id);

-- Смотрим ERDiagram


-- Если нужно удалить
ALTER TABLE table_name DROP FOREIGN KEY constraint_name;
ALTER TABLE media DROP FOREIGN KEY media_type_id_fk ;

DESC friendship;

ALTER TABLE friendship
  ADD CONSTRAINT friendship_from_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_to_user_id_fk 
    FOREIGN KEY (friend_id) REFERENCES users(id);
    
DESC friendship_statuses;

ALTER TABLE friendship
  ADD CONSTRAINT friendship_status_id_fk 
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);
   
DESC media;

ALTER TABLE media
  ADD CONSTRAINT media_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id);   
   
DESC communities_users;   
   
ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
   ADD CONSTRAINT communities_users_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id);  

DESC communities;   
   
ALTER TABLE communities
  ADD CONSTRAINT communities_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id);   
   
   
DESC likes;  
-- Я понимаю что так не заработает корректно, но ничего лучшего придумат не смог
-- для цель лайка нужно ловить через тип из трех разных таблиц, как это сделать я не разобрался
ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT likes_media_target_id_fk 
    FOREIGN KEY (target_id) REFERENCES media(id),
  ADD CONSTRAINT likes_user_target_id_fk 
    FOREIGN KEY (target_id) REFERENCES users(id),
  ADD CONSTRAINT likes_target_type_id_fk 
   	FOREIGN KEY (target_type_id) REFERENCES target_types(id);

DESC posts;  

ALTER TABLE posts
  ADD CONSTRAINT posts_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT posts_attached_media_id_fk 
    FOREIGN KEY (attached_media_id) REFERENCES media(id);

DESC user_privacy;  

ALTER TABLE user_privacy
  ADD CONSTRAINT user_privacy_section_id_fk 
    FOREIGN KEY (section_id) REFERENCES section(id),
  ADD CONSTRAINT user_privacy_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT user_privacy_privacy_id_fk 
   	FOREIGN KEY (privacy_id) REFERENCES privacy(id);
   
DESC privacy_except_user;  

ALTER TABLE privacy_except_user
  ADD CONSTRAINT privacy_except_user_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT privacy_except_user_friend_id_fk 
   	FOREIGN KEY (friend_id) REFERENCES users(id),
  ADD CONSTRAINT privacy_except_user_privacy_id_fk 
   	FOREIGN KEY (privacy_id) REFERENCES privacy(id);   




   
   
   
   