'use strict';

const FabricCAServices = require('fabric-ca-client');
const { Wallets } = require('fabric-network');
const fs = require('fs');
const path = require('path');

async function main() {
  try {
    const ccpPath = path.resolve(__dirname, '../config/connection-profile.json');
    const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

    const caInfo = ccp.certificateAuthorities['ca.org1.example.com'];
    const ca = new FabricCAServices(caInfo.url);

    const walletPath = path.resolve(__dirname, '../../fabric/wallets');
    const wallet = await Wallets.newFileSystemWallet(walletPath);

    const identity = await wallet.get('student001');
    if (identity) {
      console.log('✅ Identity for student001 already exists in wallet');
      return;
    }

    const adminIdentity = await wallet.get('admin');
    if (!adminIdentity) {
      console.log('⚠️ Admin identity not found in wallet. Please enroll admin first.');
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
    console.log('✅ student001 enrolled and stored in wallet');
  } catch (error) {
    console.error(`❌ Failed to register student001: ${error}`);
    process.exit(1);
  }
}

main();

