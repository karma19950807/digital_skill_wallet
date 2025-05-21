const express = require('express');
const router = express.Router();
const db = require('../config/db');
const bcrypt = require('bcryptjs');

router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const [users] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    if (users.length === 0) return res.status(401).json({ error: 'User not found' });

    const user = users[0];
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ error: 'Invalid password' });

    let roleDetails = {};
    if (user.role === 'student') {
      const [student] = await db.query('SELECT student_id FROM student WHERE user_id = ?', [user.user_id]);
      if (student.length > 0) roleDetails.student_id = student[0].student_id;
    } else if (user.role === 'school') {
      const [school] = await db.query('SELECT school_id FROM school WHERE user_id = ?', [user.user_id]);
      if (school.length > 0) roleDetails.school_id = school[0].school_id;
    }

    return res.json({
      token: 'mock-jwt-token',
      role: user.role,
      user_id: user.user_id,
      ...roleDetails
    });

  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;

