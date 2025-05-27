const snarkjs = require('snarkjs');
const fs = require('fs');
const path = require('path');

async function generateProof(logical, critical, problem, tools) {
    const total = logical + critical + problem + tools;

    const input = {
        logical,
        critical,
        problem,
        tools,
        total
    };

    const zkPath = path.join(__dirname, '../zk');
    const proofsPath = path.join(zkPath, 'proofs');

    if (!fs.existsSync(proofsPath)) {
        fs.mkdirSync(proofsPath, { recursive: true });
    }

    // Write input.json for witness generation
    fs.writeFileSync(`${proofsPath}/input.json`, JSON.stringify(input));

    // Calculate witness
    await snarkjs.wtns.calculate(
        `${zkPath}/compiled/skillcoin.wasm`,
        `${proofsPath}/input.json`,
        `${proofsPath}/witness.wtns`
    );

    // Generate proof
    await snarkjs.groth16.prove(
        `${zkPath}/keys/skillcoin_final.zkey`,
        `${proofsPath}/witness.wtns`,
        `${proofsPath}/proof.json`,
        `${proofsPath}/public.json`
    );

    const proof = JSON.parse(fs.readFileSync(`${proofsPath}/proof.json`, 'utf8'));
    const publicSignals = JSON.parse(fs.readFileSync(`${proofsPath}/public.json`, 'utf8'));

    return { proof, publicSignals };
}

module.exports = { generateProof };

