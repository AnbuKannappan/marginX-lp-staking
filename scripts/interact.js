const { Contract, providers, utils, Wallet } = require("ethers");
const testTokenAbi = require("../artifacts/contracts/liquidity/LiquidityStakingV1.sol/LiquidityStakingV1.json");
const ALCHEMY_API_KEY = "Fl-5ytQkgptHBPNSuK48rxxDXX12NOn3";

async function main () {
    
const rpc =  await new providers.JsonRpcProvider( `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}` ) ;
const wallet = new Wallet( "8aa1621c51c72c2ed353e08c0242855850e0712acf3ab1881e3ef87fb574fbd4", rpc);


const testTokenContract = new Contract("0x214c06bd1a76B6F5502252E73f8EeCD60b8dfAA9", testTokenAbi.abi, wallet);

//let flag = await testTokenContract.deposit(BigInt(900000000000000000), "false");
let flag = await testTokenContract.claimRewards("0x31B1B28A40d587A933f04402137Bec76e102A344",{
    gasLimit: 1000000
  });

//   let flag = await testTokenContract.stake(BigInt(1000000000000000000000),{
//     gasLimit: 1000000
//   });

console.log(flag);
}

main()

