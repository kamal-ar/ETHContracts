import { ConnectWallet } from '../components/ConnectWallet'
import { OwnedNFTs } from '../components/OwnedNFTs'
import { ListNFT } from '../components/ListNFT'
import { Marketplace } from '../components/Marketplace'

export default function Home() {
  return (
    <div>
      <h1>NFT Marketplace</h1>
      <ConnectWallet />
      <OwnedNFTs />
      <ListNFT />
      <Marketplace />
    </div>
  )
}

