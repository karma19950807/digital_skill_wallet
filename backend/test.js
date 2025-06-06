const bcrypt = require('bcrypt');

bcrypt.hash('pass123', 12, (err, hash) => {
  console.log('New hash for pass123:', hash);
});

