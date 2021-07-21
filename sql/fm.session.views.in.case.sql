/* 
 Условная конструкция CASE.
 Выражения подзапросов.
 Представления.
 */
/*
 CASE
 WHEN condition1 = true THEN r1
 WHEN condition2 != true THEN r2
 ELSE r3
 END
 
 CASE expression
 WHEN 1 THEN 'hello'
 WHEN 2 THEN 'world'
 ELSE 'test'
 END
 */
SELECT (
    CASE
      WHEN TRUE = FALSE THEN '+'
      WHEN TRUE THEN '-'
      ELSE '???'
    END
  ) AS "test field";
/* */
SELECT *,
  (
    CASE
      WHEN is_male = TRUE THEN 'male'
      WHEN is_male = FALSE THEN 'female'
    END
  ) AS "gender"
FROM users;
/* */
SELECT *,
  (
    CASE
      EXTRACT(
        MONTH
        FROM "birthday"
      )
      WHEN 1 THEN 'winter'
      WHEN 2 THEN 'winter'
      WHEN 3 THEN 'spring'
      WHEN 4 THEN 'spring'
      WHEN 5 THEN 'spring'
      WHEN 6 THEN 'summer'
      WHEN 7 THEN 'summer'
      WHEN 8 THEN 'summer'
      WHEN 9 THEN 'autumn'
      WHEN 10 THEN 'autumn'
      WHEN 11 THEN 'autumn'
      WHEN 12 THEN 'winter'
    END
  ) AS Season
FROM users;
/* */
SELECT *,
  (
    CASE
      WHEN month_of_birthday IN (12, 1, 2) THEN 'winter'
      WHEN month_of_birthday IN (3, 4, 5) THEN 'spring'
      WHEN month_of_birthday IN (6, 7, 8) THEN 'summer'
      WHEN month_of_birthday IN (9, 10, 11) THEN 'autumn'
    END
  ) AS Season
FROM (
    SELECT *,
      EXTRACT(
        MONTH
        FROM "birthday"
      ) AS month_of_birthday
    FROM "users"
  ) AS users_with_mob;
/* */
/* 
 Если бренд это айфон - то вернуть строчку APPLE
 в колонку производитель (manufacturer). А если нет - "other"
 iphone, iPhone, IPhone, Iphone
 */
SELECT *,
  (
    CASE
      WHEN "brand" ILIKE 'iphone' THEN 'Apple'
      ELSE 'Other'
    END
  ) AS manufacturer
FROM phones;
/* TASK
 price < 10K - доступный
 price > 20K  - флагман
 price >= 10 and price <= 20 - средний
 */
SELECT *,
  (
    CASE
      WHEN price < 10000 THEN 'Доступный'
      WHEN price > 20000 THEN 'Флагман'
      ELSE 'Средний'
    END
  ) AS "status"
FROM phones;
/* */
SELECT *,
  (
    CASE
      WHEN price > (
        SELECT AVG(price)
        FROM phones
      ) THEN 'High price'
      ELSE 'Low'
    END
  ) AS "status"
FROM phones;
/* TASK:
 кол-во заказов:
 > 4 - постоянный клиент
 > 2 - активный клиент
 > 0 - клиент
 
 (orders)
 */
SELECT "userId",
  COUNT(id) AS "orders_amount",
  (
    CASE
      WHEN COUNT(id) > 4 THEN 'Постоянный клиент'
      WHEN COUNT(id) > 2 THEN 'Активный клиент'
      ELSE 'Клиент'
    END
  ) AS "status"
FROM orders
GROUP BY "userId";
/* */
SELECT u.id,
  u.email,
  COUNT(o.id) AS "orders_amount",
  (
    CASE
      WHEN COUNT(o.id) > 4 THEN 'Постоянный клиент'
      WHEN COUNT(o.id) > 2 THEN 'Активный клиент'
      ELSE 'Клиент'
    END
  ) AS "status"
FROM orders o
  RIGHT JOIN users u ON u.id = o."userId"
GROUP BY u.id,
  u.email
ORDER BY orders_amount;
/*
 COALESCE
 */
SELECT brand,
  model,
  price,
  COALESCE("description", 'Not available') AS "description"
FROM phones;
/*
 NULLIF
 */
SELECT NULLIF(12, 12);
/* NULL */
SELECT NULLIF(NULL, NULL);
/* NULL */
SELECT NULLIF(NULL, 50);
/* NULL */
SELECT NULLIF(120, 50);
/* 120 */
SELECT NULLIF('hello', '50');
/* hello */
/* GREATEST & LEAST */
SELECT GREATEST(
    1,
    2,
    3,
    4,
    5,
    34645645,
    1234,
    6,
    7,
    8,
    9,
    1,
    1,
    1,
    1
  );
SELECT LEAST(
    1,
    2,
    3,
    4,
    5,
    34645645,
    1234,
    6,
    7,
    8,
    9,
    1,
    1,
    1,
    1
  );
/* Выражения подзапросов */
/* Все юзеры, которые не делали заказы */
SELECT *
FROM users u
WHERE u.id NOT IN (
    SELECT "userId"
    FROM orders
  );
/* Телефоны, которые не заказывали */
SELECT *
FROM phones p
WHERE p.id NOT IN (
    SELECT "phoneId"
    FROM phones_to_orders
  );
/* */
SELECT EXISTS (
    SELECT *
    FROM users
    WHERE id = 200
  );
/* Все юзеры, которые делали заказы */
SELECT *
FROM users u
WHERE EXISTS (
    SELECT *
    FROM orders o
    WHERE u.id = o."userId"
  );
/* Телефоны, которые не заказывали */
SELECT *
FROM phones p
WHERE p.id != ALL(
    SELECT "phoneId"
    FROM phones_to_orders
  )
  /* Телефоны, цена которых больше максимальной цены айфонов */
SELECT *
FROM phones p
WHERE p.price > ALL(
    SELECT MAX(price)
    FROM phones
    WHERE brand ILIKE 'iphone'
  );
/* Представления | VIEWS | Виртуальные таблицы */
CREATE OR REPLACE VIEW "users_with_orders_amount" AS (
    SELECT u.*,
      COUNT(o.id) AS "orders_count"
    FROM users u
      LEFT JOIN orders o ON u.id = o."userId"
    GROUP BY u.id
  );
SELECT id,
  orders_count
FROM users_with_orders_amount
WHERE firstname LIKE 'S%'
ORDER BY firstname;
/* Заказ и его стоимость */
CREATE OR REPLACE VIEW "orders_with_total_sum" AS (
    SELECT o.*,
      SUM(pto.quantity * p.price) AS "total_sum"
    FROM orders o
      JOIN phones_to_orders pto ON o.id = pto."orderId"
      JOIN phones p ON p.id = pto."phoneId"
    GROUP BY o.id
  );
/* */
CREATE OR REPLACE VIEW "spam_list" AS (
    SELECT owts.*,
      CONCAT(u.firstname, ' ', u.lastname) AS "Fullname",
      u.email,
      u.birthday,
      u.is_male
    FROM "orders_with_total_sum" owts
      JOIN users u ON u.id = owts."userId"
  );
/* Fullname, age, gender*/
SELECT "Fullname",
  EXTRACT(
    YEAR
    FROM AGE(birthday)
  ) AS "Age",
  (
    CASE
      WHEN is_male THEN 'male'
      ELSE 'female'
    END
  ) AS "Gender"
  FROM spam_list;