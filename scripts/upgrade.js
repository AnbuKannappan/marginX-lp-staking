// scripts/upgrade_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const StoringHash = await ethers.getContractFactory('StoringHash');
  console.log('Upgrading StoringHash...');
  await upgrades.upgradeProxy('0xf71ECEE81201DBB30a1A23845682fAC2Bf2BC978', StoringHash);
  console.log('StoringHash upgraded');
}

main();