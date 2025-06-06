const fabricService = require('../services/fabricService');

exports.submitSkillWallet = async (req, res) => {
    try {
        const result = await fabricService.submitSkillCoin(req.body);
        res.json(result);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.getWalletHistory = async (req, res) => {
    try {
        const result = await fabricService.getWalletHistory(req.params.studentId);
        res.json(result);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

