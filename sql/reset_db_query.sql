DROP TABLE IF EXISTS phones_to_orders CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS phones CASCADE;
DROP TABLE IF EXISTS users CASCADE;
/* */
CREATE TABLE IF NOT EXISTS "users" (
  id SERIAL PRIMARY KEY,
  firstname VARCHAR(64) NOT NULL CHECK(firstname != ''),
  lastname VARCHAR(64) NOT NULL CHECK(lastname != ''),
  email VARCHAR(256) NOT NULL CHECK(email != ''),
  is_male BOOLEAN NOT NULL,
  birthday DATE NOT NULL CHECK(birthday < CURRENT_DATE),
  "height" NUMERIC(3, 2) CHECK(
    "height" > 0.2
    AND "height" < 3
  ),
  "weight" NUMERIC(5, 2) CHECK(
    "weight" BETWEEN 1 AND 500
  )
);
/* */
CREATE TABLE phones (
  id SERIAL PRIMARY KEY,
  brand VARCHAR(20) NOT NULL,
  model VARCHAR(40) NOT NULL,
  price NUMERIC(10, 2) NOT NULL CHECK(price > 0),
  quantity INT NOT NULL CHECK (quantity >= 0)
);
/* */
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  "userId" INT REFERENCES users(id),
  "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
/* */
CREATE TABLE phones_to_orders (
  "orderId" INT REFERENCES orders(id),
  "phoneId" INT REFERENCES phones(id),
  quantity INT NOT NULL CHECK (quantity > 0),
  PRIMARY KEY ("orderId", "phoneId")
);