'use strict';

const { Contract } = require('fabric-contract-api');

class SkillWalletContract extends Contract {

    async submitSkillCoin(ctx, studentId, testId, gradeLevel, skillsJson, artefactHash) {
        const key = ctx.stub.createCompositeKey('SkillRecord', [studentId, testId]);
        const record = {
            studentId,
            testId,
            gradeLevel,
            skills: JSON.parse(skillsJson),
            artefactHash,
            timestamp: new Date().toISOString()
        };
        await ctx.stub.putState(key, Buffer.from(JSON.stringify(record)));
        return JSON.stringify(record);
    }

    async getWalletHistory(ctx, studentId) {
        const iterator = await ctx.stub.getStateByPartialCompositeKey('SkillRecord', [studentId]);
        const allResults = [];
        for await (const res of iterator) {
            allResults.push(JSON.parse(res.value.toString()));
        }
        return JSON.stringify(allResults);
    }
}

module.exports = SkillWalletContract;
