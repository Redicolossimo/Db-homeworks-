-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения 
-- и добавить необходимые индексы.

CREATE INDEX users_id_idx ON users(id);
CREATE INDEX messages_from_user_id_to_user_id_idx ON messages(from_user_id, to_user_id);
CREATE INDEX media_user_id_media_type_id_idx ON media(user_id, media_type_id);
CREATE INDEX friendship_user_id_status_id_idx ON friendship(user_id, status_id);
CREATE INDEX likes_target_id_idx ON likes(target_id);
CREATE INDEX profiles_sex_idx ON profiles(sex);
CREATE INDEX profiles_hometown_idx ON profiles(hometown);

-- 2. Задание на оконные функции

-- Построить запрос, который будет выводить следующие столбцы:
-- имя группы
-- среднее количество пользователей в группах
-- самый молодой пользователь в группе
-- самый пожилой пользователь в группе
-- общее количество пользователей в группе
-- всего пользователей в системе
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100

SELECT DISTINCT communities.name, communities.id,
	MAX(profiles.birthday) OVER win AS youngest,
	MIN(profiles.birthday) OVER win AS oldest,
	COUNT(communities_users.user_id) OVER win AS amount,
	COUNT(profiles.user_id) OVER() AS total,
	COUNT(communities_users.user_id) OVER win / COUNT(profiles.user_id) OVER() * 100 as '%%',
	FLOOR(COUNT(profiles.user_id) OVER() / (SELECT COUNT(communities.id) FROM communities)) AS avg -- тут только вопрос как стоит округлять
FROM communities	
			JOIN communities_users
      			ON communities.id = communities_users.community_id
      		JOIN profiles
        		ON communities_users.user_id = profiles.user_id
        	WINDOW win AS (PARTITION BY communities.id);