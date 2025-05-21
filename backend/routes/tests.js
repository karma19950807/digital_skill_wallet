const express = require('express');
const router = express.Router();
const db = require('../config/db'); // your DB connection

router.get('/:studentId', async (req, res) => {
  const { studentId } = req.params;

  try {
    const [results] = await db.query(`
      SELECT 
        ts.test_id,
        ts.course_name,
        ts.logical_thinking,
        ts.critical_analysis,
        ts.problem_solving,
        ts.digital_tools,
        ts.grade_level,
        ts.timestamp,
        a.artefact_json,
        a.artefact_hash
      FROM test_score_staging ts
      LEFT JOIN artefact a ON ts.student_id = a.student_id AND ts.test_id = a.test_id
      WHERE ts.student_id = ?
    `, [studentId]);

    res.json(results);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch test data' });
  }
});

module.exports = router;

