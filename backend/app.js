const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/auth'); // ✅ Make sure this file exists

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ✅ This is essential
app.use('/api/auth', authRoutes); 

const testRoutes = require('./routes/tests');
app.use('/api/tests', testRoutes);

const studentRoutes = require('./routes/students');
app.use('/api/students', studentRoutes);

const skillsRoutes = require('./routes/skills');
app.use('/api/skills', skillsRoutes);

const schoolRoutes = require('./routes/schools');
app.use('/api/schools', schoolRoutes);


app.get('/', (req, res) => {
  res.send('🔗 API is running...');
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Backend running at http://localhost:${PORT}`);
});

