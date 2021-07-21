CREATE TABLE user_tasks (
  id SERIAL PRIMARY KEY,
  userid INT NOT NULL CONSTRAINT tasks_userid_fkey REFERENCES users,
  body text not null,
  isdone BOOLEAN DEFAULT FALSE,
  deadline TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL CONSTRAINT tasks_dedline_check CHECK(deadline >= CURRENT_TIMESTAMP)
);
INSERT INTO user_tasks (userid, body, isdone, deadline)
VALUES (1, 'test', FALSE, '2022-02-02');
/* Добавлять столбцы */
ALTER TABLE user_tasks
ADD COLUMN createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
  /* Удалять столбцы */
ALTER TABLE user_tasks DROP COLUMN createdat -- 
  /* Добавлять ограничения */
ALTER TABLE user_tasks
ALTER COLUMN createdat
SET NOT NULL;
ALTER TABLE user_tasks
ADD CONSTRAINT tasks_createdat_check CHECK(createdat <= CURRENT_TIMESTAMP)
  /* Удалять ограничения */
ALTER TABLE user_tasks DROP CONSTRAINT tasks_createdat_check
  /*Removing NOT NULL constraint*/
ALTER TABLE user_tasks
ALTER COLUMN createdat DROP NOT NULL
  /* Изменять значения по умолчанию */
ALTER TABLE user_tasks
ALTER COLUMN deadline SET DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE user_tasks
ALTER COLUMN deadline DROP DEFAULT;
  /* Изменять типы */
ALTER TABLE user_tasks
ALTER COLUMN body TYPE VARCHAR(512);
 /* Переименовывать столбцов */
 ALTER TABLE user_tasks
 RENAME COLUMN isdone TO status;
  /* Переименовывать таблицы */
ALTER TABLE user_tasks RENAME TO tasks;