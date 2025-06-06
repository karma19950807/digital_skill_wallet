const snarkjs = require('snarkjs');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

async function generateProof(logical, critical, problem, tools) {
    const zkBasePath = path.join(__dirname, '../zk');
    const zkCompiledPath = path.join(zkBasePath, 'compiled/skillcoin_js');
    const proofsPath = path.join(zkBasePath, 'proofs');

    if (!fs.existsSync(proofsPath)) {
        fs.mkdirSync(proofsPath, { recursive: true });
    }

    const input = {
        logical,
        critical,
        problem,
        tools,
        total: logical + critical + problem + tools
    };

    const inputPath = path.join(proofsPath, 'input.json');
    const witnessPath = path.join(proofsPath, 'witness.wtns');
    const proofPath = path.join(proofsPath, 'proof.json');
    const publicPath = path.join(proofsPath, 'public.json');

    fs.writeFileSync(inputPath, JSON.stringify(input, null, 2));

    console.log('✅ Running witness generation...');
    await new Promise((resolve, reject) => {
        const cmd = `node ${zkCompiledPath}/generate_witness.js ${zkCompiledPath}/skillcoin.wasm ${inputPath} ${witnessPath}`;
        console.log('Running command:', cmd);
        exec(cmd, (error, stdout, stderr) => {
            if (error) {
                console.error('❌ Witness generation error:', stderr);
                reject(new Error('Witness generation failed'));
            } else {
                console.log('✅ Witness generated:', stdout);
                resolve();
            }
        });
    });

    console.log('✅ Generating proof...');
    await snarkjs.groth16.fullProve(
        input,
        path.join(zkCompiledPath, 'skillcoin.wasm'),
        path.join(zkBasePath, 'keys/skillcoin_final.zkey')
    );

    const proof = JSON.parse(fs.readFileSync(proofPath, 'utf8'));
    const publicSignals = JSON.parse(fs.readFileSync(publicPath, 'utf8'));

    console.log('✅ Proof and public signals ready');
    return { proof, publicSignals };
}

async function verifyProof(proof, publicSignals) {
    const zkBasePath = path.join(__dirname, '../zk');
    const verificationKeyPath = path.join(zkBasePath, 'keys/verification_key.json');

    const vkey = JSON.parse(fs.readFileSync(verificationKeyPath, 'utf8'));
    const res = await snarkjs.groth16.verify(vkey, publicSignals, proof);

    console.log(`✅ Proof verification result: ${res}`);
    return res;
}

module.exports = { generateProof, verifyProof };

