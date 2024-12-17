// NOTE: Submit this transaction through the multisig wallet interface.

const { ethers } = require("hardhat");

async function main() {
  // Address of the deployed UpgradeableNFT contract
  const nftAddress = ""; // TODO fill here once deployed

  // Connect to the UpgradeableNFT contract
  const UpgradeableNFT = await ethers.getContractFactory("UpgradeableNFT");
  const nft = UpgradeableNFT.attach(nftAddress);

  // Encode the function call to setTransfersAllowed(false)
  const data = nft.interface.encodeFunctionData("setTransfersAllowed", [false]);

  // Create a transaction object
  const transaction = {
    to: nftAddress,
    data: data,
    value: ethers.utils.parseEther("0")  // No Ether is being sent
  };

  console.log("Transaction to be submitted to multisig:");
  console.log("To:", transaction.to);
  console.log("Data:", transaction.data);
  console.log("Value:", transaction.value.toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

