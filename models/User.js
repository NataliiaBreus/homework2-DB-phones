const { extractUsers } = require('../utils');

class User {
  static _client = null;
  static _tableName = 'users';

  static async createTableIfNotExist () {
    return await this._client.query(`
    CREATE TABLE IF NOT EXISTS ${this._tableName} (
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
    `);
  }

  static async dropTableIfExists () {
    return await this._client.query(
      `DROP TABLE IF EXISTS "${this._tableName}" CASCADE;`
    );
  }

  static async findAll () {
    return await this._client.query(`SELECT * FROM "${this._tableName}"`);
  }

  static async bulkCreate (users) {
    const { rows } = await this._client.query(
      `INSERT INTO "${
        this._tableName
      }" ("firstname", "lastname", "email", "is_male", "birthday", "height", "weight")
       VALUES ${extractUsers(users)}
       RETURNING *
      `
    );
    return rows;
  }

  static async deleteById (id) {
    return await this._client.query(
      `DELETE FROM "${this._tableName}"
       WHERE "id" = ${id}
       RETURNING *;
      `
    );
  }

  static async truncateTable () {
    return await this._client.query(`TRUNCATE ${this._tableName}`);
  }
}

module.exports = User;
