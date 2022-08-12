/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 require("@nomiclabs/hardhat-truffle5");
 require("solidity-coverage")
 require("hardhat-gas-reporter");

 module.exports = {
  solidity: {
    version: "0.8.7",
    settings: {
      optimizer: {
        enabled: true,
        runs: 50,
      },
    },
  },
  gasReporter: {
    enabled: true,
    currency: 'USD',
    gasPrice: 21
  }
};