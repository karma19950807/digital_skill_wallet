const express = require('express');
const router = express.Router();
const db = require('../config/db');
const { generateProof, verifyProof } = require('../utils/zkProof');
const fs = require('fs');
const path = require('path');

// 1️⃣ Get student skills
router.get('/:id/skills', async (req, res) => {
    const studentId = req.params.id;

    try {
        const [results] = await db.query(
            `SELECT * FROM skill_wallet_temp WHERE student_id = ?`,
            [studentId]
        );

        const parsed = results.map(r => ({
            ...r,
            skillcoin_json: typeof r.skillcoin_json === 'string'
                ? JSON.parse(r.skillcoin_json)
                : r.skillcoin_json
        }));

        res.json(parsed);
    } catch (err) {
        console.error('[API Error] Failed to fetch student skills:', err);
        res.status(500).json({ error: 'Failed to fetch student skill data' });
    }
});

// 2️⃣ Get full skill wallet
router.get('/:id/skill-wallet', async (req, res) => {
    const studentId = req.params.id;

    try {
        const [results] = await db.query(`
            SELECT test_id, grade_level, artefact_hash, status, skillcoin_json, created_at
            FROM skill_wallet_temp
            WHERE student_id = ?
            ORDER BY created_at DESC
        `, [studentId]);

        const parsed = results.map(r => ({
            ...r,
            skillcoin_json: typeof r.skillcoin_json === 'string'
                ? JSON.parse(r.skillcoin_json)
                : r.skillcoin_json
        }));

        res.json(parsed);
    } catch (err) {
        console.error('Error fetching student skill wallet:', err);
        res.status(500).json({ error: 'Failed to fetch skill wallet data' });
    }
});

// 3️⃣ Get all skills for a school
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
            skillcoin_json: typeof r.skillcoin_json === 'string'
                ? JSON.parse(r.skillcoin_json)
                : r.skillcoin_json
        }));

        res.json(parsed);
    } catch (err) {
        console.error('Error fetching school skill wallets:', err);
        res.status(500).json({ error: 'Failed to fetch school skill wallet records' });
    }
});

// 4️⃣ Calculate + verify skill coins and update DB
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

        for (const metric of metrics) {
            const [rubricRows] = await db.query(
                `SELECT point FROM rubric WHERE ? BETWEEN range_end AND range_start LIMIT 1`,
                [testScore[metric]]
            );
            const point = rubricRows.length > 0 ? parseFloat(rubricRows[0].point) : 0;
            totalCoins += point;
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

        const currentJson = typeof existing[0].skillcoin_json === 'string'
            ? JSON.parse(existing[0].skillcoin_json)
            : existing[0].skillcoin_json;

        const updatedJson = {
            ...currentJson,
            total: totalCoins,  // ✅ numeric sum now properly saved
            verified: isValid,
            proof,
            publicSignals,
            skills: {
                logical: testScore.logical_thinking,
                analysis: testScore.critical_analysis,
                problem: testScore.problem_solving,
                digital_tools: testScore.digital_tools
            }
        };

        await db.query(
            `UPDATE skill_wallet_temp SET skillcoin_json = ?, status = ? WHERE wallet_id = ?`,
            [JSON.stringify(updatedJson), isValid ? 'Verified' : 'Not Verified', existing[0].wallet_id]
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

// 5️⃣ Download proof file
router.get('/:studentId/proof', async (req, res) => {
    const studentId = req.params.studentId;
    if (!studentId || studentId === 'undefined') {
        return res.status(400).json({ error: 'Invalid student ID provided' });
    }
    const filePath = path.join(__dirname, `../zk/proofs/student_${studentId}_proof.json`);
    if (!fs.existsSync(filePath)) {
        return res.status(404).json({ error: 'Proof data missing in record' });
    }
    res.download(filePath, `student_${studentId}_proof.json`);
});




module.exports = router;

