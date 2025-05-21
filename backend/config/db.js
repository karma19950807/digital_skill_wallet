const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: '172.28.96.1',
  user: 'root',
  password: 'root123',
  database: 'digital_skill_wallet_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

module.exports = pool;

