const { ethers, upgrades } = require('hardhat');

async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    // console.log("Account balance:", (await deployer.getBalance()).toString());
  
  //   const StoringHash = await ethers.getContractFactory("InitializableAdminUpgradeabilityProxy");
  // //   const hash = await upgrades.deployProxy(StoringHash,["0x91ab0fAb8225cD73EB778B0A049307c806bD8F95","0xBb19939D96ca5cd34ec2919eE9Da3a1b70D7A77C",
  // // "0x5f19a63b93ad9d0ac8e4bbfa7e32e88f34592726",1667286100, 1825052500], { initializer: 'initialize' });
  // const hash = await upgrades.deployProxy(StoringHash,["0x01Aba531DB9FDB7A91255EB1D3CB5a44847b6fD8", "0x31B1B28A40d587A933f04402137Bec76e102A344","data"], { initializer: 'initialize', unsafeAllow: ['delegatecall'] });
  //   const deploy = await hash.deployed();

    // //Treasury
    // const StoringHash = await ethers.getContractFactory("Treasury");
    // const hash = await upgrades.deployProxy(StoringHash, { initializer: 'initialize' });
    // const deploy = await hash.deployed();

     // //Treasury
    // const StoringHash = await ethers.getContractFactory("Treasury");
    // const hash = await upgrades.deployProxy(StoringHash, { initializer: 'initialize' });
    // const deploy = await hash.deployed();
  
    console.log("StoringHash Token address:", deploy.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });