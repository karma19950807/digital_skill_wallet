const express = require('express');
const router = express.Router();
const db = require('../config/db');
const { generateProof } = require('../utils/zkProof');
const { verifyProof } = require('../utils/zkVerify');
const fs = require('fs');
const path = require('path');

// =========================
// Get all student skill records (parsed)
// =========================
router.get('/:id/skills', async (req, res) => {
    const studentId = req.params.id;

    try {
        const [results] = await db.query(
            `SELECT * FROM skill_wallet_temp WHERE student_id = ?`,
            [studentId]
        );

        const parsed = results.map(r => ({
            ...r,
            skillcoin_json: JSON.parse(r.skillcoin_json)
        }));

        res.json(parsed);
    } catch (err) {
        console.error('[API Error] Failed to fetch student skills:', err);
        res.status(500).json({ error: 'Failed to fetch student skill data' });
    }
});

// =========================
// Get student profile
// =========================
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

// =========================
// Update student profile
// =========================
router.put('/:id/profile', async (req, res) => {
    const studentId = req.params.id;
    const { name, email } = req.body;

    try {
        await db.query(`UPDATE student SET name = ? WHERE student_id = ?`, [name, studentId]);

        await db.query(`
            UPDATE users u
            JOIN student s ON u.user_id = s.user_id
            SET u.email = ?
            WHERE s.student_id = ?
        `, [email, studentId]);

        res.json({ message: 'Profile updated successfully' });
    } catch (err) {
        console.error('Error updating profile:', err);
        res.status(500).json({ error: 'Failed to update profile' });
    }
});

// =========================
// Get all skill wallets for a school
// =========================
router.get('/schools/:schoolId/skills', async (req, res) => {
    const schoolId = req.params.schoolId;

    try {
        const [results] = await db.query(`
            SELECT s.student_id, s.name, sw.test_id, sw.grade_level, sw.status, sw.artefact_hash, sw.skillcoin_json
            FROM student s
            JOIN skill_wallet_temp sw ON s.student_id = sw.student_id
            WHERE s.school_id = ?
        `, [schoolId]);

        const parsed = results.map(r => ({
            ...r,
            skillcoin_json: JSON.parse(r.skillcoin_json)
        }));

        res.json(parsed);
    } catch (err) {
        console.error('Error fetching school skill wallets:', err);
        res.status(500).json({ error: 'Failed to fetch school skill wallet records' });
    }
});

// =========================
// Calculate + verify + merge skill coins (with skills preserved)
// =========================
router.get('/:studentId/calculate-coins', async (req, res) => {
    const studentId = req.params.studentId;

    try {
        const [rows] = await db.query(
            `SELECT * FROM test_score_staging WHERE student_id = ? ORDER BY timestamp DESC LIMIT 1`,
            [studentId]
        );

        if (rows.length === 0) {
            return res.status(404).json({ error: 'No test score found for student' });
        }

        const testScore = rows[0];
        const metrics = ['logical_thinking', 'critical_analysis', 'problem_solving', 'digital_tools'];
        let totalCoins = 0;
        const details = {};

        for (const metric of metrics) {
            const [rubricRows] = await db.query(
                `SELECT point FROM rubric WHERE ? BETWEEN range_end AND range_start LIMIT 1`,
                [testScore[metric]]
            );
            const point = rubricRows.length > 0 ? rubricRows[0].point : 0;
            totalCoins += point;
            details[metric] = point;
        }

        const { proof, publicSignals } = await generateProof(
            testScore.logical_thinking,
            testScore.critical_analysis,
            testScore.problem_solving,
            testScore.digital_tools
        );

        const isValid = await verifyProof(proof, publicSignals);

        const [existing] = await db.query(
            `SELECT * FROM skill_wallet_temp WHERE student_id = ? ORDER BY created_at DESC LIMIT 1`,
            [studentId]
        );

        if (existing.length === 0) {
            return res.status(404).json({ error: 'Skill wallet record not found' });
        }

        let currentJson = {};
        try {
            currentJson = JSON.parse(existing[0].skillcoin_json);
        } catch (err) {
            console.warn('Warning: Failed to parse existing skillcoin_json, starting fresh.');
        }

        // Ensure 'skills' block is preserved or freshly added
        const updatedJson = {
            ...currentJson,
            skills: currentJson.skills || {
                logical: testScore.logical_thinking,
                analysis: testScore.critical_analysis,
                problem: testScore.problem_solving,
                digital_tools: testScore.digital_tools
            },
            total: totalCoins,
            verified: isValid,
            proof,
            publicSignals
        };

        await db.query(
            `UPDATE skill_wallet_temp SET skillcoin_json = ? WHERE wallet_id = ?`,
            [JSON.stringify(updatedJson), existing[0].wallet_id]
        );

        // Save proof for download
        const proofsPath = path.join(__dirname, '../zk/proofs');
        if (!fs.existsSync(proofsPath)) fs.mkdirSync(proofsPath, { recursive: true });

        fs.writeFileSync(
            `${proofsPath}/student_${studentId}_proof.json`,
            JSON.stringify({ proof, publicSignals }, null, 2)
        );

        res.json({
            total: totalCoins,
            verified: isValid,
            proof,
            publicSignals
        });
    } catch (err) {
        console.error('Error calculating or verifying skill coins:', err);
        res.status(500).json({ error: 'Failed to calculate or verify skill coins' });
    }
});

// =========================
// Download stored proof file
// =========================
router.get('/:studentId/proof', async (req, res) => {
    const studentId = req.params.studentId;
    const filePath = path.join(__dirname, `../zk/proofs/student_${studentId}_proof.json`);

    if (!fs.existsSync(filePath)) {
        return res.status(404).json({ error: 'Proof data missing in record' });
    }

    res.download(filePath, `student_${studentId}_proof.json`);
});

module.exports = router;

