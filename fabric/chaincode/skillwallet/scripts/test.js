'use strict';

const SkillWalletContract = require('../SkillWalletContract');

async function test() {
    const contract = new SkillWalletContract();

    const ctx = {
        stub: {
            createCompositeKey: (prefix, keys) => `${prefix}:${keys.join(':')}`,
            putState: async (key, value) => console.log(`Put ${key}: ${value}`),
            getStateByPartialCompositeKey: async () => {
                return {
                    async *[Symbol.asyncIterator]() {
                        yield { value: Buffer.from(JSON.stringify({ dummy: 'test' })) };
                    }
                };
            }
        }
    };

    console.log('--- Submit Test ---');
    await contract.submitSkillCoin(ctx, 'student001', 'CRT-001', '10',
        JSON.stringify({ logical: 85, analysis: 75, problem: 90, digital_tools: 80 }), 'QmCID001');

    console.log('--- Get History ---');
    const history = await contract.getWalletHistory(ctx, 'student001');
    console.log('Result:', history);
}

test();
