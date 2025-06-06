const express = require('express');
const router = express.Router();
const pool = require('../config/db');
const bcrypt = require('bcrypt');

router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  console.log("🔐 Login attempt:", email);

  try {
    const [userRows] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);
    if (userRows.length === 0) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    const user = userRows[0];
    const match = await bcrypt.compare(password, user.password);
    if (!match) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    let userDetails = {};
    if (user.role === 'student') {
      const [studentRows] = await pool.query('SELECT * FROM student WHERE user_id = ?', [user.user_id]);
      if (studentRows.length === 0) {
        return res.status(404).json({ error: 'Student record not found' });
      }
      userDetails = studentRows[0];
    } else if (user.role === 'school') {
      const [schoolRows] = await pool.query('SELECT * FROM school WHERE user_id = ?', [user.user_id]);
      if (schoolRows.length === 0) {
        return res.status(404).json({ error: 'School record not found' });
      }
      userDetails = schoolRows[0];
    }

    delete user.password;

    const response = {
      message: 'Login successful',
      role: user.role,
      userId: user.user_id,
      token: 'mock-token',
      details: userDetails
    };

    console.log("✅ Login Success Payload:", response);

    // ✅ THIS WAS MISSING
    return res.status(200).json(response);

  } catch (err) {
    console.error('Login error:', err);
    return res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;

