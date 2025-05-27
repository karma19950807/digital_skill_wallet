const express = require('express');
const router = express.Router();
const db = require('../config/db');

// GET /api/schools/:id/overview
router.get('/:id/overview', async (req, res) => {
  const schoolId = req.params.id;

  try {
    const [[studentCount]] = await db.query(
      'SELECT COUNT(*) as totalStudents FROM student WHERE school_id = ?', [schoolId]
    );

    const [[testCount]] = await db.query(
      `SELECT COUNT(*) as totalTests
       FROM test_score_staging ts
       JOIN student s ON ts.student_id = s.student_id
       WHERE s.school_id = ?`, [schoolId]
    );

    const [[skillCount]] = await db.query(
      `SELECT COUNT(*) as totalSkills
       FROM skill_wallet_temp sw
       JOIN student s ON sw.student_id = s.student_id
       WHERE s.school_id = ?`, [schoolId]
    );

    const [[pendingCount]] = await db.query(
      `SELECT COUNT(*) as pendingArtefacts
       FROM artefact a
       JOIN student s ON a.student_id = s.student_id
       WHERE s.school_id = ? AND a.artefact_hash IS NULL`, [schoolId]
    );

    const [gradeBreakdown] = await db.query(
      `SELECT grade_level, COUNT(*) as count
       FROM test_score_staging ts
       JOIN student s ON ts.student_id = s.student_id
       WHERE s.school_id = ?
       GROUP BY grade_level`, [schoolId]
    );

    const [statusCounts] = await db.query(
      `SELECT status, COUNT(*) as count
       FROM skill_wallet_temp sw
       JOIN student s ON sw.student_id = s.student_id
       WHERE s.school_id = ?
       GROUP BY status`, [schoolId]
    );

    const [recent] = await db.query(
      `SELECT s.name, ts.test_id, sw.status, ts.timestamp
       FROM test_score_staging ts
       JOIN student s ON ts.student_id = s.student_id
       LEFT JOIN skill_wallet_temp sw ON ts.student_id = sw.student_id AND ts.test_id = sw.test_id
       WHERE s.school_id = ?
       ORDER BY ts.timestamp DESC
       LIMIT 5`, [schoolId]
    );

    const submissionsByGrade = {};
    gradeBreakdown.forEach(row => {
      submissionsByGrade[row.grade_level] = row.count;
    });

    const skillStatusCounts = {};
    statusCounts.forEach(row => {
      skillStatusCounts[row.status] = row.count;
    });

    res.json({
      totalStudents: studentCount.totalStudents,
      totalTests: testCount.totalTests,
      totalSkills: skillCount.totalSkills,
      pendingArtefacts: pendingCount.pendingArtefacts,
      submissionsByGrade,
      skillStatusCounts,
      recentSubmissions: recent
    });
  } catch (err) {
    console.error('School overview fetch error:', err);
    res.status(500).json({ error: 'Failed to load overview' });
  }
});


router.get('/:id/tests', async (req, res) => {
  const schoolId = req.params.id;

  try {
    const [rows] = await db.query(`
      SELECT s.name, ts.test_id, ts.grade_level,
             ts.logical_thinking, ts.critical_analysis,
             ts.problem_solving, ts.digital_tools,
             ts.is_ready, ts.timestamp
      FROM test_score_staging ts
      JOIN student s ON ts.student_id = s.student_id
      WHERE s.school_id = ?
      ORDER BY ts.timestamp DESC
    `, [schoolId]);

    res.json(rows);
  } catch (err) {
    console.error('Error fetching school test data:', err);
    res.status(500).json({ error: 'Failed to fetch test data' });
  }
});


router.get('/:id/skills', async (req, res) => {
  const schoolId = req.params.id;

  try {
    const [rows] = await db.query(`
      SELECT s.name, sw.test_id, sw.grade_level, sw.status,
             sw.artefact_hash, sw.skillcoin_json
      FROM student s
      LEFT JOIN skill_wallet_temp sw ON s.student_id = sw.student_id
      WHERE s.school_id = ?
      ORDER BY sw.created_at DESC
    `, [schoolId]);

    const parsed = rows.map(r => ({
      ...r,
      skillcoin_json: r.skillcoin_json ? JSON.parse(r.skillcoin_json) : null
    }));

    res.json(parsed);
  } catch (err) {
    console.error('Error fetching skill wallet data:', err);
    res.status(500).json({ error: 'Failed to fetch skill wallet records' });
  }
});





module.exports = router;

