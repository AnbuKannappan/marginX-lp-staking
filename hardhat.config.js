//require("@nomiclabs/hardhat-waffle");
require('@nomiclabs/hardhat-ethers');
require('@openzeppelin/hardhat-upgrades');
require("@nomiclabs/hardhat-etherscan");

const ALCHEMY_API_KEY = "Fl-5ytQkgptHBPNSuK48rxxDXX12NOn3";
const GOERLI_PRIVATE_KEY = "8aa1621c51c72c2ed353e08c0242855850e0712acf3ab1881e3ef87fb574fbd4";
const HARMONY_PRIVATE_KEY = "8aa1621c51c72c2ed353e08c0242855850e0712acf3ab1881e3ef87fb574fbd4";

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    version: "0.8.2",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }, 
  networks: {
    harmony: {
      url: `https://api.s0.b.hmny.io`,
      accounts: [`0x${HARMONY_PRIVATE_KEY}`]
    },
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY]
    },
    fuji: {
      url: `https://api.avax-test.network/ext/bc/C/rpc`,
      accounts: [GOERLI_PRIVATE_KEY]
    },
    fxtestnet: {
      url: `https://testnet-fx-json-web3.functionx.io:8545`,
      accounts: []
    }

  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: "5TQ86X5849114KV5WJXXM7WDYK3AMHSVV9"
  }
};
