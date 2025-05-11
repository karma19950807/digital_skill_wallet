'use strict';

const FabricCAServices = require('fabric-ca-client');
const { Wallets } = require('fabric-network');
const fs = require('fs');
const path = require('path');

async function main() {
    try {
        const ccpPath = path.resolve(__dirname, '../../../../backend/config/connection-profile.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const caURL = ccp.certificateAuthorities['ca.org1.example.com'].url;
        const ca = new FabricCAServices(caURL);

        const walletPath = path.join(__dirname, '../../../../fabric/wallets');
        const wallet = await Wallets.newFileSystemWallet(walletPath);

        const identity = await wallet.get('student001');
        if (identity) {
            console.log('✅ Identity already exists: student001');
            return;
        }

        const adminIdentity = await wallet.get('admin');
        if (!adminIdentity) {
            console.log('❌ Admin identity not found');
            return;
        }

        const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
        const adminUser = await provider.getUserContext(adminIdentity, 'admin');

        const secret = await ca.register({
            affiliation: 'org1.department1',
            enrollmentID: 'student001',
            role: 'client'
        }, adminUser);

        const enrollment = await ca.enroll({
            enrollmentID: 'student001',
            enrollmentSecret: secret
        });

        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes()
            },
            mspId: 'Org1MSP',
            type: 'X.509'
        };

        await wallet.put('student001', x509Identity);
        console.log('✅ Successfully registered and enrolled student001');
    } catch (error) {
        console.error(`❌ Failed to register student001: ${error}`);
        process.exit(1);
    }
}

main();
