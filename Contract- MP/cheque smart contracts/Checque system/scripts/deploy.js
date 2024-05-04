const hre = require("hardhat");

async function main() {
  // Deploy Registration contract
  let checkcontract = await hre.ethers.deployContract("ChequeSystem");
  await checkcontract.waitForDeployment();
  console.log("ChequeSystem Contract deployed to:", checkcontract.address);


}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
