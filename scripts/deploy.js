async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const Token = await ethers.getContractFactory("LiquidityStakingV1");
    const token = await Token.deploy("0x28Aa37809569FB33353e6Ca6ECd213546353AC4b","0x28Aa37809569FB33353e6Ca6ECd213546353AC4b",
    "0x5f19a63b93ad9d0ac8e4bbfa7e32e88f34592726",1669121131, 1825052500);
  
    console.log("Contract address:", token.address);

  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });