/* 1.Посчитать кол-во телефонов, которые были проданы */

SELECT SUM ("quantity") AS "sold phones"
FROM "phones_to_orders";

/* 2. Кол-во телефонов, которые есть "на складе" */

SELECT SUM ("quantity") AS "in stock"
FROM "phones";

/* 3.Средняя цена всех телефонов */

SELECT AVG ("price")
FROM "phones";

/* 4.Средняя цена каждого бренда */

SELECT "brand", AVG ("price") AS "average_price"
FROM "phones"
GROUP BY "brand";

/* 5. Кол-во моделей каждого бренда */

SELECT "brand", "model", SUM ("quantity") AS "quantity"
FROM "phones"
GROUP BY "brand", "model"
ORDER BY "brand", "model";

/* 6. Кол-во заказов каждого пользователя, которые совершали заказы */

SELECT "userId", COUNT ("id") AS "amount_of_orders"
FROM "orders"
GROUP BY "userId"
ORDER BY "userId";

/* 7. Средняя цена на IPhone */

SELECT AVG ("price") AS "average_price"
FROM "phones"
WHERE "brand" ILIKE 'Iphone';

/* 8. Стоимость всех телефонов в диапазоне их цен от 10К до 20К */

SELECT SUM ("price") AS "price"
FROM "phones"
WHERE "price" > 10000 AND "price" < 20000; 

/* 9. Узнать каких брендов телефонов осталось меньше всего */

SELECT "brand", SUM ("quantity") AS "quantity"
FROM "phones"
GROUP BY "brand"
ORDER BY "quantity"
LIMIT 5;

/* 10. Сортировка юзеров по возрасту(не день рождения) и по имени  */

SELECT "age", "firstname"
FROM (
  SELECT EXTRACT (
    YEAR
    FROM AGE ("birthday")
  ) AS "age",
  *
  FROM "users"
) AS "users_age"
GROUP BY "age", "firstname"
ORDER BY "age", "firstname"; 

/* 11. Извлечь все телефоны заказа №4 JOIN*/

SELECT  * FROM "phones" AS p 
JOIN "phones_to_orders" AS pto ON p."id" = pto."phoneId"
WHERE pto."orderId" = 4; 

/* 12. Кол-во заказов каждого пользователя и его емейл */

SELECT u."id", u."email", COUNT (o."id") AS "amount_of_orders"
FROM users AS u 
LEFT JOIN orders AS o ON u."id" = o."userId"
GROUP BY u."id", u."email";

/* 13. Извлечь самый популярный телефон (каких моделей телефонов заказано больше всего) */

SELECT p.* FROM "phones" AS p
JOIN "phones_to_orders" AS pto ON p."id" = pto."phoneId"
ORDER BY pto."quantity" DESC
LIMIT 1;
