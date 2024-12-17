import { useState } from 'react'
import { useContractWrite } from 'wagmi'
import { MARKETPLACE_CONTRACT_ADDRESS, MARKETPLACE_CONTRACT_ABI } from '../config/contracts'

export function ListNFT() {
  const [tokenId, setTokenId] = useState('')
  const [price, setPrice] = useState('')

  const { write } = useContractWrite({
    address: MARKETPLACE_CONTRACT_ADDRESS,
    abi: MARKETPLACE_CONTRACT_ABI,
    functionName: 'createListing',
  })

  const handleSubmit = (e) => {
    e.preventDefault()
    write({ args: [NFT_CONTRACT_ADDRESS, tokenId, price] })
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={tokenId}
        onChange={(e) => setTokenId(e.target.value)}
        placeholder="Token ID"
      />
      <input
        type="text"
        value={price}
        onChange={(e) => setPrice(e.target.value)}
        placeholder="Price in ETH"
      />
      <button type="submit">List NFT</button>
    </form>
  )
}

