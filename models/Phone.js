class Phones {
  static _client = null;
  static _tableName = 'phones';

  static async findAll () {
    return await this._client.query(`SELECT * FROM "${this._tableName}"`);
  }

  static async bulkCreate (values) {
    const valuesString = values.map(
      ({ brand, model, price, quantity }) =>
        `($$${brand}$$, $$${model}$$, ${price}, ${quantity})`
    );
    const { rows } = await this._client.query(
      `INSERT INTO "${this._tableName}" ("brand", "model", "price", "quantity")
       VALUES ${valuesString}
       RETURNING *;
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

module.exports = Phones;
