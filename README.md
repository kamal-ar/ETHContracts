----------------------------------

nft_contracts/
    This folder has the code for the NFT contracts and the scripts to upgrade as in Part 3.

    contracts/
        multisig.sol - The multi signature smart contract
        nft_contract.sol - NFT smart contract
        nft_marketplace.sol - NFT marketplace smart contract

   scripts/
   
       upgrade_nft_contract.js - Script to upgrade, line 10 needs the deployed proxy address
       upgrade_marketplace_contract.js - Line 7 needs nft address


----------------------------------

webapp/
    This folder has the Next.js codes for the webapp (Wagmi)

    config/
        wagmi.ts - Line 9 needs project ID from WalletConnect
        contracts.ts - Needs contract addresses and ABIs (JSONs)

 These folders have codes for the pages/components
  pages/
  components/
