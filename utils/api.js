const axios = require('axios');
const config = require('../configs/api.json');

const {
  baseURL,
  get: { users: usersGET }
} = config;

const http = axios.create({ baseURL });

module.exports.loadUsers = async (options = {}) => {
  const queryParams = {
    ...usersGET,
    ...options
  };

  const urlQueryParams = new URLSearchParams(queryParams);

  const {
    data: { results: users }
  } = await http.get(`?${urlQueryParams.toString()}`);

  return users;
};
