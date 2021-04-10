# Random-Walk-NFT
Submission for the 2021 Chainlink Hackathon. Made using Remix IDE. Worked on concurrently with [Solidity-Math](https://github.com/jstat17/Solidity-Math).

## Ethereum-based Random Walk NFT - Symbol: RWalk
A smartcontract that can generate verifiably random walks (using Chainlink VRF), which produces a plot of points that look like a treasure map starting at the origin and ending at some arbitarily-random point.

The frontend's webpage that interacts with the smartcontract uses a web-based python script to display the generated map using the NFT's randomly generated 2-D nodes. The frontend also allows users to generate their NFTs and display them once they are generated in the Ethereum blockchain. The webpage connects via Metamask.

### Deployed contract (with source code) [on the Rinkeby testnet](https://rinkeby.etherscan.io/address/0xc9E02478307B6306edfd2a96642576eDF15f17fa#code)

## Video
[YouTube presentation](https://youtu.be/LdCT1tU0ED0) of the logic behind the smartcontract and a demo of interacting with the smartcontract's frontend.


## How To Use This Repo
##### Compiling
The file RandomWalk.sol must be compiled with NumericalMath.sol and FixidityLib.sol in the same folder. The rest of the files can fetch from external repositories. Note that  `pragma solidity ^0.6.6;` for all contracts because the VRFConsumerBase.sol for the Chainlink VRF Oracle is on `0.6.6`.

##### RWalk NFTs
Each unique NFT is generated and stored in a struct `Randomwalk`, which has the properties `name`, `ID`, `nodes` to store the simple data. Each NFT also has `int256[] x` and `int256[] y` which are the arrays that store each coordinate component of each node of the walk.

##### Contract Functions
- `requestRandomWalk` is how to begin the creation of an NFT. The user must provide a seed for the VRF Oracle in `userProvidedSeed`, and the number of nodes in the walk for `nodes`. The frontend uses Python's numpy.random to generate a random integer, so that the user does not need to provide a seed. A requestID is returned once the Oracle gives back a random number (2 blocks minimum).
-  `generateRandomWalk` then generates the random walk once the request has been reserved for the user's account. If the request is not reserved, then a blank request of zeros will be what is in `senderToRequest[msg.sender]`. If this check is a success, then a random walk is generated and pushed to the array of walks. Afterwards, the request for the user is set back to the blank request of zeros.
-  `seeRandomWalk` will return all the properties of the RWalk described above as a json-formatted object, which is easily unpacked in JavaScript.
-  `setTokenURI` will set the token URI of a specific RWalk with ID of `tokenID`. This functionality was included in the smartcontract, but not used in this project's frontend. It was created as it is extra functionality that is useful to have for the future.

#### Viewing The Frontend
I used node to create a local http server with `npm install -g http-server` within folder `/frontend` and then start it with `http-server`. Metamask should connect automatically and display in the Status area of the webpage. Python should also be installed (this takes sometimes above 10-15 seconds).

##### Frontend Interaction (requires Metamask)
- Status shows what scripts are currently being run by the browser
- Clicking "Get # of walks in circulation" will display the total supply of NFTs in the smartcontract
- The first textbox allows the user to enter the number of nodes they want in their walk (40), then clicking "Generate Random Walk" will proceed all the various steps to fully create an NFT (watch the demo video linked above).
- The second textbox will display a graphed representation of the NFT with Python's Matplotlib library, once the unique ID of some RWalk is entered, and the button "Plot Random Walk" is clicked.

**Note that all of Pyodide's Python libraries must be installed before the plotting can happen. The first time an NFT is plotted, there is quite a time delay, as it can be seen in the JavaScript console that many modules have to be installed. Once the imports have been done and the first NFT is plotted, then changing the number in the ID entry-textbox will load up the next NFT much faster.**
