const express = require('express');
const router = express.Router();
const db = require('../config/db');

// GET /api/students/:id/skills
router.get('/:id/skills', async (req, res) => {
  const studentId = req.params.id;

  try {
    const [results] = await db.query(
      `SELECT * FROM skill_wallet_temp WHERE student_id = ?`,
      [studentId]
    );

    res.json(results);
  } catch (err) {
    console.error('[API Error] Failed to fetch skills:', err);
    res.status(500).json({ error: 'Failed to fetch skill data' });
  }
});


// GET /api/students/:id/skill-wallet
router.get('/:id/skill-wallet', async (req, res) => {
  const studentId = req.params.id;

  try {
    const [results] = await db.query(`
      SELECT test_id, grade_level, artefact_hash, status, skillcoin_json, created_at
      FROM skill_wallet_temp
      WHERE student_id = ?
      ORDER BY created_at DESC
    `, [studentId]);

    res.json(results);
  } catch (err) {
    console.error('Error fetching skill wallet:', err);
    res.status(500).json({ error: 'Failed to fetch skill wallet data' });
  }
});

// GET /api/students/:id/profile
router.get('/:id/profile', async (req, res) => {
  const studentId = req.params.id;

  try {
    const [results] = await db.query(`
      SELECT s.name, u.email, sc.school_name
      FROM student s
      JOIN users u ON s.user_id = u.user_id
      JOIN school sc ON s.school_id = sc.school_id
      WHERE s.student_id = ?
    `, [studentId]);

    if (results.length === 0) {
      return res.status(404).json({ error: 'Profile not found' });
    }

    res.json(results[0]);
  } catch (err) {
    console.error('Error fetching student profile:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

router.put('/:id/profile', async (req, res) => {
  const studentId = req.params.id;
  const { name, email } = req.body;

  try {
    // Update student name
    await db.query(
      `UPDATE student SET name = ? WHERE student_id = ?`,
      [name, studentId]
    );

    // Update email via user_id (join required to get it)
    await db.query(
      `UPDATE users u
       JOIN student s ON u.user_id = s.user_id
       SET u.email = ?
       WHERE s.student_id = ?`,
      [email, studentId]
    );

    res.json({ message: 'Profile updated successfully' });
  } catch (err) {
    console.error('Error updating profile:', err);
    res.status(500).json({ error: 'Failed to update profile' });
  }
});




module.exports = router;

