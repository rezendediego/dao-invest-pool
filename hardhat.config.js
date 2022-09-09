require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    ropsten: {
      url: process.env.INFURA_URL_ROPSTEN,
      accounts: [process.env.WALLET_SECRET],
    }
  }
};
