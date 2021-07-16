function getRandomArbitrary (min, max) {
  return Math.random() * (max - min) + min;
}

function getRandomInt (min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min)) + min; //Максимум не включается, минимум включается
}

function extractUsers (users) {
  return users
    .map(
      ({ name: { first, last }, email, dob: { date }, gender }) =>
        `($$${first}$$, $$${last}$$, $$${email}$$, '${gender ===
          'male'}', '${date}', ${getRandomArbitrary(
          1,
          2.5
        )}, ${getRandomArbitrary(1, 500)} )`
    )
    .join(',');
}

const PHONE_BRANDS = [
  'Samsung',
  'Nokia',
  'Huawei',
  'Xiaomi',
  'Meizu',
  'Iphone',
  'Honor',
  'Siemens',
  'Motorola',
];

function generatePhone (key) {
  return {
    brand: PHONE_BRANDS[getRandomInt(0, PHONE_BRANDS.length)],
    model: `${key} model ${getRandomInt(0, 100)}`,
    price: getRandomInt(1000, 40000),
    quantity: getRandomInt(10, 1000),
  };
}

function generatePhones (length = 50) {
  return new Array(length).fill(null).map((_, i) => generatePhone(i));
}

module.exports = {
  getRandomArbitrary,
  getRandomInt,
  extractUsers,
  generatePhones,
};
