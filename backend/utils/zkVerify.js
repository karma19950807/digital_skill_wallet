const snarkjs = require('snarkjs');
const fs = require('fs');
const path = require('path');

async function verifyProof(proof, publicSignals) {
    const zkPath = path.join(__dirname, '../zk');
    const vKey = JSON.parse(fs.readFileSync(`${zkPath}/keys/verification_key.json`));

    const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);
    return res;
}

module.exports = { verifyProof };

