const { ethers } = require("hardhat");

async function main() {
  const NFTContract = await ethers.getContractFactory("MemberNFT");

  // deploy the contract
  const nftContract = await NFTContract.deploy();

  // wait for it to finish deploying
  await nftContract.deployed();

  // print the address of the deployed contract
  console.log("NFT Contract Address:", nftContract.address);
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
