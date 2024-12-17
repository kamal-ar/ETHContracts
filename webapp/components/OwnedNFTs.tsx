import { useAccount, useContractRead } from 'wagmi'
import { NFT_CONTRACT_ADDRESS, NFT_CONTRACT_ABI } from '../config/contracts'

export function OwnedNFTs() {
  const { address } = useAccount()
  const { data: nfts } = useContractRead({
    address: NFT_CONTRACT_ADDRESS,
    abi: NFT_CONTRACT_ABI,
    functionName: 'tokensOfOwner',
    args: [address],
  })

  return (
    <div>
      <h2>Owned NFTs</h2>
      {nfts?.map((tokenId) => (
        <div key={tokenId.toString()}>Token ID: {tokenId.toString()}</div>
      ))}
    </div>
  )
}

