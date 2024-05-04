require("@nomicfoundation/hardhat-toolbox");

const API_URL ="paste your alchamey key here";
const PRIVATE_KEY =
  "paste your wallet private key here";

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.0",
      },
      {
        version: "0.4.11",
      },
      {
        version: "0.8.1",
      },
      {
        version: "0.8.4",
      },
    ],
  },
 
  etherscan: {
    apiKey: "paste your API Key here", // Obtain an API key from the Etherscan website
  },
};