const db = require('./config/db');

async function test() {
  try {
    const [rows] = await db.query('SELECT 1 + 1 AS result');
    console.log('✅ MySQL Connected! Result:', rows[0].result);
  } catch (err) {
    console.error('❌ MySQL connection failed:', err.message);
  }
}

test();

