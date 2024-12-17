import { useContractRead, useContractWrite } from 'wagmi'
import { MARKETPLACE_CONTRACT_ADDRESS, MARKETPLACE_CONTRACT_ABI } from '../config/contracts'

export function Marketplace() {
  const { data: listings } = useContractRead({
    address: MARKETPLACE_CONTRACT_ADDRESS,
    abi: MARKETPLACE_CONTRACT_ABI,
    functionName: 'getAllListings',
  })

  const { write: buyNFT } = useContractWrite({
    address: MARKETPLACE_CONTRACT_ADDRESS,
    abi: MARKETPLACE_CONTRACT_ABI,
    functionName: 'buyNFT',
  })

  return (
    <div>
      <h2>NFT Marketplace</h2>
      {listings?.map((listing) => (
        <div key={listing.listingId.toString()}>
          <p>Token ID: {listing.tokenId.toString()}</p>
          <p>Price: {listing.price.toString()} ETH</p>
          <button onClick={() => buyNFT({ args: [listing.listingId] })}>Buy</button>
        </div>
      ))}
    </div>
  )
}

