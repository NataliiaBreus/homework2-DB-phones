const fs = require('fs').promises;
const path = require('path');
const { loadUsers } = require('./utils/api');
const { User, Phone, client } = require('./models');
const { generatePhones, getRandomInt } = require('./utils');

async function start () {
  await client.connect();

  const resetQueryString = await fs.readFile(
    path.join(__dirname, '/sql/reset_db_query.sql'),
    'utf8'
  );

  await client.query(resetQueryString);

  const users = await User.bulkCreate(await loadUsers());
  const phones = await Phone.bulkCreate(generatePhones());

  const orderValuesString = users
    .map(u =>
      new Array(getRandomInt(1, 6))
        .fill(null)
        .map(() => `(${u.id})`)
        .join(',')
    )
    .join(',');

  const { rows: orders } = await client.query(
    `INSERT INTO orders ("userId") VALUES ${orderValuesString} RETURNING id`
  );

  const phonesToOrdersValuesString = orders.map(o => {
    const arr = new Array(getRandomInt(1, 6))
      .fill(null)
      .map(() => phones[getRandomInt(0, phones.length)]);

    return [...new Set(arr)]
      .map(p => `(${o.id}, ${p.id}, ${getRandomInt(1, 5)})`)
      .join(',');
  });

  await client.query(`
  INSERT INTO phones_to_orders ("orderId", "phoneId", "quantity") 
  VALUES ${phonesToOrdersValuesString}
  `);

  await client.end();
}

start();
