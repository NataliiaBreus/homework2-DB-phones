DROP TABLE IF EXISTS users CASCADE;
/*
 Используя документацию добавьте поля birthday, isMale
 */
/*
 VARCHAR(3)
 "123"45
 "1"
 
 CHAR(3)
 "123"45
 "1  "
 
 */
/* */
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  firstname VARCHAR(64) NOT NULL CHECK(firstname != ''),
  lastname VARCHAR(64) NOT NULL CHECK(lastname != ''),
  email VARCHAR(256) NOT NULL CHECK(email != ''),
  is_male BOOLEAN NOT NULL,
  birthday DATE NOT NULL CHECK(birthday < CURRENT_DATE),
  height NUMERIC(3, 2) CHECK(
    height > 0.2
    AND height < 3
  )
);
/* */
ALTER TABLE "users"
ADD UNIQUE("email");
/* */
ALTER TABLE "users"
ADD CONSTRAINT "custom_check" CHECK("height" > 0.5);
/* */
ALTER TABLE "users" DROP CONSTRAINT "custom_check";
/* */
ALTER TABLE "users"
ADD "weight" NUMERIC(5, 2) CHECK(
    "weight" BETWEEN 1 AND 500
  );
/* */
INSERT INTO "users" (
    "firstname",
    "lastname",
    "email",
    "is_male",
    "birthday",
    "height",
    "weight"
  )
VALUES (
    'Test',
    'Testovich',
    'test1@mail.com',
    TRUE,
    '1980-01-01',
    2,
    15
  ),
  (
    'Test',
    'Testovich',
    'test2@mail.com',
    TRUE,
    '1980-01-01',
    1.5,
    150
  ),
  (
    'Test',
    'Testovich',
    'test3@mail.com',
    TRUE,
    '1980-01-01',
    1,
    200
  );
/* */
DROP TABLE IF EXISTS a;
/* */
CREATE TABLE a (b INT, c INT, PRIMARY KEY (b, c));
INSERT INTO a
VALUES (1, 1),
  (1, 2),
  (2, 1),
  (1, 3);
/* */
DROP TABLE IF EXISTS "products" CASCADE;
/* */
CREATE TABLE "products" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(256) NOT NULL CHECK("name" != ''),
  "category" VARCHAR(128) NOT NULL CHECK("category" != ''),
  "quantity" INTEGER NOT NULL CHECK("quantity" > 0),
  UNIQUE ("name", "category")
);
/*
 samsung phones
 xiaomi  phones
 samsung laptops
 */
/* */
DROP TABLE IF EXISTS "orders" CASCADE;
CREATE TABLE "orders" (
  "id" BIGSERIAL PRIMARY KEY,
  "customer_id" INTEGER NOT NULL CHECK("customer_id" > 0) REFERENCES "users" ("id"),
  "is_done" BOOLEAN NOT NULL DEFAULT FALSE,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
/* */
DROP TABLE IF EXISTS "products_to_orders";
/* */
CREATE TABLE "products_to_orders" (
  "order_id" BIGINT REFERENCES "orders" ("id"),
  "product_id" INTEGER REFERENCES "products" ("id"),
  "quantity" INTEGER CHECK("quantity" > 0),
  PRIMARY KEY ("order_id", "product_id")
);
/*
 chats:
 chat_name,
 description
 
 users,
 
 users_to_chats
 */
/* */
DROP TABLE IF EXISTS "chats" CASCADE;
/* */
CREATE TABLE "chats" (
  "id" BIGSERIAL PRIMARY KEY,
  "owner_id" INTEGER NOT NULL REFERENCES "users" ("id"),
  "name" VARCHAR(64) NOT NULL CHECK("name" != ''),
  "description" VARCHAR(512) CHECK("description" != '')
);
/* */
DROP TABLE IF EXISTS "users_to_chats" CASCADE;
/* */
CREATE TABLE "users_to_chats" (
  "chat_id" BIGINT REFERENCES "chats"("id"),
  "user_id" INTEGER REFERENCES "users"("id"),
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("chat_id", "user_id")
);
/* */
DROP TABLE IF EXISTS "messages";
/* */
CREATE TABLE "messages" (
  "id" BIGSERIAL PRIMARY KEY,
  "body" VARCHAR(2048) NOT NULL CHECK("body" != ''),
  "author_id" INTEGER NOT NULL,
  "chat_id" BIGINT NOT NULL,
  "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "isRead" BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY ("chat_id", "author_id") REFERENCES "users_to_chats" ("chat_id", "user_id")
);
/*
 КОНТЕНТ: имя, описание,
 РЕАКЦИИ: isLiked
 */
DROP TABLE "content" CASCADE;
CREATE TABLE "content" (
  "id" SERIAL PRIMARY KEY,
  "owner_id" INTEGER NOT NULL REFERENCES "users"("id"),
  "name" VARCHAR(255) NOT NULL CHECK("name" != ''),
  "description" TEXT
);
/* */
DROP TABLE "reactions";
CREATE TABLE "reactions" (
  "content_id" INTEGER REFERENCES "content"("id"),
  "user_id" INTEGER REFERENCES "users"("id"),
  "is_liked" BOOLEAN,
  PRIMARY KEY ("content_id", "user_id")
);
/*1:1*/
CREATE TABLE "coach" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(128)
);
CREATE TABLE "teams" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(128),
  "coach_id" INTEGER NOT NULL REFERENCES "coach"("id")
);
ALTER TABLE "coach"
ADD COLUMN "team_id" INTEGER REFERENCES "teams"("id");
/*
 CRUD      SQL
 
 CREATE    INSERT - manipulation
 READ      SELECT - query
 UPDATE    UPDATE - manipulation 
 DELETE    DELETE - manipulation
 
 */
SELECT *
FROM "users"
WHERE "is_male" = FALSE;
/* ВСЕ ЮЗЕРЫ С ЧЕТНЫМИ ID */
SELECT *
FROM "users"
WHERE "id" % 2 = 0;
/* ВСЕ ЮЗЕРЫ МУЖСКОГО ПОЛА С НЕЧЕТНЫМИ ID */
SELECT "id",
  "firstname",
  "lastname",
  "email"
FROM "users"
WHERE "is_male" = TRUE
  AND "id" % 2 = 1;
/* */
SELECT *
FROM "users"
WHERE "firstname" = 'Sophia';
/* */
UPDATE "users"
SET "height" = 1.75
WHERE "firstname" = 'Sophia'
RETURNING "id",
  "firstname",
  "height";
/* */
UPDATE "users"
SET "firstname" = 'Test',
  "lastname" = 'Testovich'
WHERE "id" = 2000;
/* */
SELECT *
FROM "users"
WHERE "id" = 2000;
/* */
DELETE FROM "users"
WHERE "id" = 2099
RETURNING *;
/*
 1. get all men
 2. get all women
 3. get all adult users (> 30 y)
 4. get all adult women (> 30 y)
 5. get all users age >= 20 & age <= 40
 6. get all users with age > 20 & height > 1.8
 7. get all users: were born September
 8. get all users: were born 1 November
 9. delete all with age < 30
 */
/* */
SELECT *
FROM "users"
WHERE AGE("birthday") < MAKE_INTERVAL(25);
/* */
SELECT *
FROM "users"
WHERE AGE("birthday") BETWEEN MAKE_INTERVAL(25) AND MAKE_INTERVAL(27);
/* */
SELECT *
FROM "users"
WHERE EXTRACT(
    MONTH
    FROM "birthday"
  ) = 9;
/* */
SELECT "id" AS "Порядковый номер",
  "firstname" AS "Имя",
  "lastname" AS "Фамилия",
  "email" AS "Почта"
FROM "users" AS "u"
WHERE "u"."id" = 1500;
/* PAGINATION */
SELECT "id",
  "firstname",
  "lastname",
  "email"
FROM "users"
LIMIT 15 OFFSET 45;
/*
 offset = limit * page index
 15 * 0 = 0  first page
 15 * 1 = 15 second page
 
 */
/* */
SELECT "id",
  CONCAT("firstname", ' ', "lastname") AS "fullname",
  "email"
FROM "users"
  /* Получить всех пользователей с длиной fullname больше 15 символов */
  /*
   Функциии агрегации
   
   min - вернет минимальное значение
   max - максимальное
   sum - сумма значений
   count - подсчет кол-ва записей
   avg - среднее значение
   */
SELECT COUNT("id")
FROM "users";
/* */
SELECT AVG("height") AS "avg_height",
  AVG("weight") AS "avg_weight"
FROM "users";
/* */
SELECT SUM("weight") AS "total_weight"
FROM "users";
/* */
SELECT "is_male",
  AVG("height") AS "avg_height",
  MAX("height") AS "max_height",
  MIN("weight") AS "min_weight",
  COUNT("id") AS "rows_count"
FROM "users"
GROUP BY "is_male";
/* 
 минимальный рост мужчин и женщин
 минимальный, максимальный и средний рост мужчины и женщины
 Кол-во людей родившихся 1 января 1970 года
 Кол-во людей с определённым именем -> John | *
 Кол-во мужчин и женщин в возрасте от 20 до 30 лет
 */
SELECT COUNT("id") AS "count_people"
FROM "users"
WHERE "birthday" = '1970-01-01';
SELECT "firstname",
  COUNT("id") AS "count_people"
FROM "users"
WHERE "firstname" IN ('Sophia', 'Don', 'Arno', 'Katarina')
GROUP BY "firstname";
/* */
SELECT "is_male",
  COUNT("id") AS "count_people"
FROM "users"
WHERE AGE("birthday") BETWEEN MAKE_INTERVAL(20) AND MAKE_INTERVAL(30)
GROUP BY "is_male";
/* */
SELECT *
FROM "users"
ORDER BY "firstname" ASC;
/*
 1. Отсортировать юзеров 
 по дню рождения в порядке убывания, 
 по весу в порядке возрастания,
 по росту в порядке убывания.
 
 2. Отсортировать по фамилии, имени в алфавитном порядке
 по id в порядке убывания
 
 3. Выберите Fullname юзеров, их email и день рождения
 Отсортируйте юзеров по email length в порядке возрастания
 
 4. Посчитайте средний вес среди женщин и мужчин с ростом более 2-х метров
 */
SELECT CONCAT("firstname", ' ', "lastname") AS "fullname",
  "email",
  "birthday"
FROM "users"
ORDER BY LENGTH("email");
/* */
SELECT "is_male",
  AVG("weight") AS "average_weight"
FROM "users"
WHERE "height" > 2
GROUP BY "is_male"
ORDER BY "average_weight";
/* */
SELECT "firstname",
  COUNT("id") AS "count_people"
FROM "users"
GROUP BY "firstname"
HAVING COUNT("id") > 1
ORDER BY "count_people" DESC,
  "firstname" ASC
  /* Извлечь все бренды телефонов, в которых кол-во телефонов > 3k*/
SELECT "brand",
  SUM("quantity")
FROM phones
GROUP BY "brand"
HAVING SUM("quantity") > 3000;
/* 
 Выбрать количество людей одинакового возраста, 
 сгруппировать по возрасту,
 отображать только те группы, в которых кол-во людей одинакового возраста > 5
 */
SELECT "Age",
  COUNT("id") AS "Кол-во людей"
FROM (
    SELECT EXTRACT(
        YEAR
        FROM AGE("birthday")
      ) AS "Age",
      *
    FROM "users"
  ) AS "users_with_age"
GROUP BY "Age"
HAVING COUNT("id") > 5
ORDER BY "Кол-во людей" DESC;
/*
 LIKE  - С учётом регистра
 ILIKE - Без учёта регистра
 
 * - Всё что угодно, в любых кол-вах    => %
 ? - Всё что угодно, один раз           => _
 
 'my test value' LIKE '%test%' // TRUE
 'test' LIKE '_est' // TRUE
 */
SELECT "firstname"
FROM "users"
WHERE "firstname" ILIKE 'al%';
/*
 SIMILAR TO
 
 REGEXP:
 ~ - Соответствие с учётом регистра
 ~* - Соответствие без учёта регистра
 
 !~ - Несоответствие с учётом регистра
 !~* - Несоответствие без учёта регистра
 */
SELECT "firstname"
FROM "users"
WHERE "firstname" ~ '.*i{2}.*'
  /*
   Найти все firstname, которые начинаются с буквы M,
   заканчиваются буквой n 
   и содержат в себе 2 последовательные буквы e
   */
SELECT "firstname"
FROM "users"
WHERE "firstname" ~ 'M.*e{2}.*n';
/* */
DROP TABLE IF EXISTS A;
DROP TABLE IF EXISTS B;
CREATE TABLE A(v CHAR(3), t INT);
CREATE TABLE B(v CHAR(3));
INSERT INTO A
VALUES ('XXX', 1),
  ('ZXX', 2),
  ('XXY', 1),
  ('ZXY', 2),
  ('XXZ', 1),
  ('ZXZ', 2),
  ('XYX', 3),
  ('XYY', 3),
  ('XYZ', 3),
  ('YXZ', 4),
  ('YXX', 4),
  ('YXY', 4),
  ('YYY', 5);
INSERT INTO B
VALUES ('ABC'),
  ('ZXZ'),
  ('YXZ'),
  ('YXY'),
  ('XXX');
/* Декартово произведение */
SELECT *
FROM A,
  B;
/* Объединение. Все уникальные значения из 2-х таблиц */
SELECT v
FROM A
UNION
SELECT v
FROM B;
/* Пересечение. Совпадающие значения */
SELECT v
FROM A
INTERSECT
SELECT v
FROM B;
/* Вычитание. Значения из таблицы A, которых нет в таблице B*/
SELECT v
FROM A
EXCEPT
SELECT v
FROM B;
/* Узнать id юзеров, которые не делали заказы */
SELECT id
FROM "users"
EXCEPT
SELECT "userId"
FROM "orders"
  /* Все заказы одного юзера */
SELECT o.id AS "orderId",
  u.*
FROM users AS u
  JOIN orders AS o ON u.id = o."userId"
WHERE u.id = 8;
/* */
SELECT *
FROM A
  JOIN B ON A.v = B.v
  JOIN phones AS p ON A.t = p.id;
/* Все заказы Samsung */
SELECT o.id,
  o."createdAt",
  p.brand
FROM orders AS o
  JOIN phones_to_orders AS pto ON o.id = pto."orderId"
  JOIN phones AS p ON p.id = pto."phoneId"
WHERE p.brand = 'Samsung'
  /*
   Выбрать из таблицы orders поля id, createdAt,
   подсчитать общее количество устройств в заказе
   */
  /*
   SELECT o.id, o."createdAt" FROM orders AS o;
   SELECT "orderId", SUM("quantity") FROM phones_to_orders
   GROUP BY "orderId";
   */
SELECT o.id,
  o."createdAt",
  SUM("quantity") AS "Total quantity"
FROM orders AS o
  JOIN phones_to_orders AS pto ON o.id = pto."orderId"
GROUP BY o.id,
  o."createdAt";
/* 
 Выбрать все телефоны, которые покупают 
 и посчитать общее кол-во продаж по каждому телефону 
 */
SELECT p.id,
  p.brand,
  p.model,
  SUM(pto."quantity") AS "Total Sold"
FROM phones AS p
  JOIN phones_to_orders AS pto ON p.id = pto."phoneId"
GROUP BY p.id,
  p.brand,
  p.model
ORDER BY "Total Sold" DESC;
/* Выбрать юзеров и посчитать кол-во заказов по каждому */
SELECT u.id,
  u.firstname,
  u.lastname,
  u.email,
  COUNT(o.id) AS "ordersAmount"
FROM users AS u
  LEFT JOIN orders AS o ON u.id = o."userId"
GROUP BY u.id,
  u.firstname,
  u.lastname,
  u.email;
/* */
/* email пользователей, которые делали заказы
 бренда Honor
 */
SELECT u.email,
  p.brand
FROM users u
  JOIN orders o ON o."userId" = u.id
  JOIN phones_to_orders pto ON pto."orderId" = o.id
  JOIN phones p ON p.id = pto."phoneId"
WHERE p.brand ILIKE 'honor'
GROUP BY u.email,
  p.brand;
INSERT INTO "phones" ("brand", "model", "price", "quantity")
VALUES ('test', 'T1', 15000, 100),
  ('test', 'T2', 25000, 200),
  ('test', 'T3', 35000, 300);
/* */
CREATE SCHEMA wf;
DROP TABLE wf.departments;
CREATE TABLE wf.departments (
  id SERIAL PRIMARY KEY,
  name VARCHAR(64) NOT NULL
);
/* */
DROP TABLE wf.employees;
CREATE TABLE wf.employees (
  id SERIAL PRIMARY KEY,
  department_id INT REFERENCES wf.departments ON DELETE CASCADE,
  name VARCHAR(128) NOT NULL,
  hire_date DATE NOT NULL CHECK(hire_date <= CURRENT_TIMESTAMP),
  salary NUMERIC(10, 2) NOT NULL CHECK(salary >= 0)
);
/* */
INSERT INTO wf.departments("name")
VALUES ('SALES'),
  ('HR'),
  ('DEVELOPMENT'),
  ('QA'),
  ('TOP MANAGEMENT');
INSERT INTO wf.employees ("name", salary, hire_date, department_id)
VALUES ('TEST TESTov', 10000, '1990-1-1', 1),
  ('John Doe', 6000, '2010-1-1', 2),
  ('Matew Doe', 3456, '2020-1-1', 2),
  ('Matew Doe1', 53462, '2020-1-1', 3),
  ('Matew Doe2', 124543, '2012-1-1', 4),
  ('Matew Doe3', 12365, '2004-1-1', 5),
  ('Matew Doe4', 1200, '2000-8-1', 5),
  ('Matew Doe5', 2535, '2010-1-1', 2),
  ('Matew Doe6', 1000, '2014-1-1', 3),
  ('Matew Doe6', 63456, '2017-6-1', 1),
  ('Matew Doe7', 1000, '2020-1-1', 3),
  ('Matew Doe8', 346434, '2015-4-1', 2),
  ('Matew Doe9', 3421, '2018-1-1', 3),
  ('Matew Doe0', 34563, '2013-2-1', 5),
  ('Matew Doe10', 2466, '2011-1-1', 1),
  ('Matew Doe11', 9999, '1999-1-1', 5),
  ('TESTing 1', 1000, '2019-1-1', 2);
/* Кол-во сотрудников в отделе */
SELECT d.name,
  COUNT(e.id)
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
GROUP BY d.id;
/* Сотрудник и название отдела */
SELECT e.*,
  d.name AS "dep"
FROM wf.employees e
  JOIN wf.departments d ON e.department_id = d.id;
/* Средняя зарплата по отделам */
SELECT d.name,
  AVG(e.salary)
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
GROUP BY d.id;
/* user info | dep info | avg salary by dep */
SELECT e.*,
  d.name AS "dep",
  d.emp_in_dep,
  d.avg_salary
FROM wf.employees e
  JOIN (
    SELECT d.id,
      d.name,
      COUNT(e.id) AS "emp_in_dep",
      AVG(e.salary) AS "avg_salary"
    FROM wf.departments d
      JOIN wf.employees e ON e.department_id = d.id
    GROUP BY d.id
  ) d ON e.department_id = d.id;
/* */
SELECT e.*,
  COUNT(e.id) OVER (PARTITION BY d.id) AS "emp_in_dep",
  AVG(e.salary) OVER (PARTITION BY d.id) AS "avg_salary",
  SUM(e.salary) OVER (PARTITION BY d.id),
  SUM(e.salary) OVER ()
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id;
/* */
SELECT e.*,
  COUNT(e.id) OVER w AS "emp_in_dep",
  AVG(e.salary) OVER w AS "avg_salary",
  SUM(e.salary) OVER w,
  SUM(e.salary) OVER ()
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id WINDOW w AS (PARTITION BY d.id);
/* */
SELECT e.*,
  SUM(e.salary) OVER (
    PARTITION BY d.id
    ORDER BY e.salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS "sum_salary_by_dep",
  SUM(e.salary) OVER ()
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id;

/* Каскадное удаление данных */
DELETE FROM wf.departments
WHERE id = 5;