const express = require('express');
const router = express.Router();
const pool = require('../config/db');

router.get('/:userId/skills', async (req, res) => {
  try {
    const [student] = await pool.query('SELECT student_id FROM student WHERE user_id = ?', [req.params.userId]);
    if (!student.length) return res.status(404).json({ error: 'Student not found' });

    const [skills] = await pool.query('SELECT logical_thinking, critical_analysis, problem_solving FROM test_score_staging WHERE student_id = ? ORDER BY timestamp DESC LIMIT 1', [student[0].student_id]);
    if (!skills.length) return res.status(404).json({ error: 'No skills found' });

    res.json(skills[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;

