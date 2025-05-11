const express = require('express');
const router = express.Router();
const walletController = require('../controllers/walletController');

router.post('/submit', walletController.submitSkillWallet);
router.get('/history/:studentId', walletController.getWalletHistory);

module.exports = router;

