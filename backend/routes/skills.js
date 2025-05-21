const express = require('express');
const router = express.Router();
const pool = require('../config/db');

router.get('/skills/latest/:studentId', async (req, res) => {
  const { studentId } = req.params;

  try {
    const [rows] = await pool.query(
      'SELECT logical_thinking, critical_analysis, problem_solving FROM test_score_staging WHERE student_id = ? ORDER BY timestamp DESC LIMIT 1',
      [studentId]
    );

    if (rows.length === 0) {
      return res.status(404).json({ error: 'No test data found' });
    }

    res.json(rows[0]);
  } catch (err) {
    console.error('DB error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});


module.exports = router;
