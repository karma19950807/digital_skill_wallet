template SkillCoinCheck() {
    signal input logical;
    signal input critical;
    signal input problem;
    signal input tools;
    signal input total;

    signal computed;

    computed <== logical + critical + problem + tools;

    total === computed;
}

component main = SkillCoinCheck();

