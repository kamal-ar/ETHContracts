import { getDefaultConfig } from '@rainbow-me/rainbowkit'
import { mainnet, sepolia } from 'wagmi/chains'
import { createConfig } from 'wagmi'

// Modify the chains as needed
export const config = createConfig(
  getDefaultConfig({
    appName: 'NFT Home',
    projectId: '',
    chains: [mainnet, sepolia],
  })
)
