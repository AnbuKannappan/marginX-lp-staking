//const { ethers } = require("hardhat");

// scripts/index.js
async function main () {

    let batch = ['0xf37608ddda94759920a9f242797fda3066028b939ff24fd4aacecf984f3c3cc6',
    '0x81932690dc0b0e842d5fc705aeb2451665b84bce5a8433c4770c9503f8a73ec6',
    '0xe49205ce0ee9a78eb40e3b114fb6635da5fb0b53a58ce02b5aa07f2777fe4cc7',
    '0x66bc989660389ac06a0f2fac4d9960f7649fcdf501dcf4b4b08a9d2ad6c2ebc3',
    '0x3f160a51d1d21fcca8919f03e6f6a3330121544aea5538dc890c9d4332c72c5a',
    '0x07bbadb76111c40568b0d6c5ca1ccff5f00ed03fc2a2a303749d7229e9f8ac1d']

    //let data = "0x07bbadb76111c40568b0d6c5ca1ccff5f00ed03fc2a2a303749d7229e9f8ac1d";

    const address = '0xC1FC9Aedc98A2A6BaaD1457DFa3D21713ed75a44';
    const StoringHash = await ethers.getContractFactory("ExampleContract");
    const storingHash = await StoringHash.attach(address);
    const resultset = await storingHash.exampleFunction("Anbu", 1021, false);
    console.log('ResultSet', resultset);
    
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });