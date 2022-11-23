const hre = require("hardhat");
const {ethers, upgrades} = require("hardhat");
require("@nomiclabs/hardhat-etherscan");

async function main() {
    console.log('Running deploy script');

    this.LSProxy = await hre.ethers.getContractFactory("InitializableAdminUpgradeabilityProxy");
    const lsProxy = await this.LSProxy.deploy();
    await lsProxy.deployed();
    console.log("LSProxy lib deployed to: ", lsProxy.address);

    this.LiquidityStakingV1 = await hre.ethers.getContractFactory("LiquidityStakingV1", {
        unsafeAllow: ['external-library-linking'],
        libraries: {
            LSProxy: lsProxy.address
        },
    });

    const interaction = await upgrades.deployProxy(this.LiquidityStakingV1, [
        VAT,
        SPOT,
        HAY,
        HayJoin,
        JUG,
        DOG,
        REWARDS
    ], {
        initializer: "initialize",
        unsafeAllowLinkedLibraries: true,
    });
    await interaction.deployed();
    console.log("interaction deployed to:", interaction.address);
}