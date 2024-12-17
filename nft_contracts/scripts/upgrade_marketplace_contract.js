// NOTE: Submit this through the multisig wallet interface.

const { ethers, upgrades } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Upgrading contract with the account:", deployer.address);

    const NFTMarketplaceUpgradeable = await ethers.getContractFactory("NFTMarketplaceUpgradeable");
    const proxyAddress = "0x0000000000"; // Replace with your deployed proxy address

    const upgraded = await upgrades.upgradeProxy(proxyAddress, NFTMarketplaceUpgradeable);
    console.log("NFTMarketplaceUpgradeable upgraded");

    // Set the minimum sale price to 0.1 ETH
    const tx = await upgraded.setMinSalePrice(ethers.utils.parseEther("0.1"));
    await tx.wait();
    console.log("Minimum sale price set to 0.1 ETH");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

