# Random-Walk-NFT
Submission for the 2021 Chainlink Hackathon. Made using Remix IDE.

This repo worked on concurrently with [Solidity-Math](https://github.com/jstat17/Solidity-Math).

## Ethereum-based Random Walk NFT
A smartcontract that can generate verifiably random walks (using Chainlink VRF), which produces a plot of points that look like a treasure map starting at the origin and ending at some arbitarily-random point.

The frontend's webpage that interacts with the smartcontract uses a web-based python script to display the generated map using the NFT's randomly generated 2-D nodes. The frontend also allows users to generate their NFTs and display them once they are generated in the Ethereum blockchain. The webpage connects via Metamask.

#### Deployed contract (with source code)
[On the Rinkeby testnet](https://rinkeby.etherscan.io/address/0xc9E02478307B6306edfd2a96642576eDF15f17fa#code)

## Video
[YouTube presentation](https://youtu.be/LdCT1tU0ED0) of the logic behind the smartcontract and a demo of interacting with the smartcontract's frontend.
