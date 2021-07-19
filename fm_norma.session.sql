/* 1NF */
DROP TABLE test;
CREATE TABLE test (
  v1 VARCHAR(12),
  v2 INT,
  PRIMARY KEY(v1,v2)
);
/* 2NF */
CREATE TABLE positions(
  name VARCHAR(64) PRIMARY KEY,
  car_aviability BOOLEAN
);
/* */
CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name VARCHAR(64),
  position VARCHAR(32) REFERENCES positions,
);
/* 3NF */

CREATE TABLE departments (
  id SERIAL PRIMARY KEY,
  name,
  phone_number
);

CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name VARCHAR(64),
  department REFERENCES departments
);

INSERT INTO employees (name, department, department_number)
VALUES 
('t1 f1', 'HR'),
('t2 f2', 'Sales'),
('t3 f3', 'Sales');

/* BCNF */
/*
  teachers
  students
  subjects

  teacher n:1 subjects
  students m:n subjects
  students m:n teachers
*/
CREATE TABLE students (id SERIAL PRIMARY KEY);
CREATE TABLE subjects (name SERIAL PRIMARY KEY)
CREATE TABLE teachers (
  id SERIAL PRIMARY KEY, 
  "subject" VARCHAR(64) REFERENCES subjects
);

CREATE TABLE students_to_teachers(
  teacher_id INT REFERENCES teachers,
  student_id INT REFERENCES students,
  PRIMARY KEY (teacher_id, student_id)
);
/* 4NF */

/*
  restaurants
  pizza
  delivery_services
*/


CREATE TABLE pizzas("name" VARCHAR(64) PRIMARY KEY);
CREATE TABLE restaurants (id SERIAL PRIMARY KEY);
CREATE TABLE delivery_services (id SERIAL PRIMARY KEY);
CREATE TABLE pizza_to_restaurant(
  pizza_name VARCHAR(64) REFERENCES pizzas, 
  restaurant_id REFERENCES restaurants
);
CREATE TABLE restaurants_to_deliveries (
  restaurant_id INT REFERENCES restaurants,
  delivery_id INT REFERENCES delivery_services,
  PRIMARY KEY(restaurant_id, delivery_id)
);

INSERT INTO restaurants_to_deliveries
VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),





















/*
  Необходимо спроектировать базу данных ПОСТАВКА ТОВАРОВ
  В БД должна храниться информация:
  - о ТОВАРАХ : код товара, наименование товара, цена товара
  - ЗАКАЗАХ на поставку товаров: код заказа, наименование заказчика, адрес заказчика, телефон,
  номер договора, дата заключения договора, наименование товара, плановая поставка (шт.);
  - фактических ОТГРУЗКАХ товаров: код отгрузки, код заказа, дата отгрузки,
  отгружено товара (шт.)
  При проектировании БД необходимо учитывать следующее:
  • товар имеет несколько заказов на поставку. Заказ соответствует одному товару;
  • товару могут соответствовать несколько отгрузок. В отгрузке могут участвовать несколько товаров.
  Кроме того следует учесть:
  • товар не обязательно имеет заказ. Каждому заказу обязательно соответствует товар;
  • товар не обязательно отгружается заказчику. Каждая отгрузка обязательно соответствует некоторому товару.
*/
