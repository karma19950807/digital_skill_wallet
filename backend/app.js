const express = require('express');
const cors = require('cors');
const walletRoutes = require('./routes/wallet');

const app = express();
app.use(cors());
app.use(express.json());

app.use('/api/wallet', walletRoutes);

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`✅ Backend API running at http://localhost:${PORT}`);
});

