const { Gateway, Wallets } = require('fabric-network');
const path = require('path');
const fs = require('fs');

const ccpPath = path.resolve(__dirname, '../config/connection-profile.json');
const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
const walletPath = path.resolve(__dirname, '../../fabric/wallets');

async function getContract(userId) {
    const wallet = await Wallets.newFileSystemWallet(walletPath);

    const identity = await wallet.get(userId);
    if (!identity) throw new Error(`❌ No identity for ${userId} in wallet`);

    const gateway = new Gateway();
    await gateway.connect(ccp, {
        wallet,
        identity: userId,
        discovery: { enabled: true, asLocalhost: true },
    });

    const network = await gateway.getNetwork('dswchannel');
    const contract = network.getContract('skillwallet');
    return { contract, gateway };
}

module.exports = {
    async submitSkillCoin(payload) {
        const { studentId, testId, gradeLevel, skills, artefactHash } = payload;
        const { contract, gateway } = await getContract(studentId);

        const tx = contract.createTransaction('submitSkillCoin');
        const response = await tx.submit(
            studentId,
            testId,
            gradeLevel,
            JSON.stringify(skills),
            artefactHash
        );

        await gateway.disconnect();
        return JSON.parse(response.toString());
    },

    async getWalletHistory(studentId) {
        const { contract, gateway } = await getContract(studentId);
        const response = await contract.evaluateTransaction('getWalletHistory', studentId);
        await gateway.disconnect();
        return JSON.parse(response.toString());
    }
};

