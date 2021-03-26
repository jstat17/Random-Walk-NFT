// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;
pragma experimental ABIEncoderV2;

import "./NumericalMath.sol";
import "./FixidityLib.sol";
import "https://github.com/smartcontractkit/chainlink/blob/master/evm-contracts/src/v0.6/VRFConsumerBase.sol";
import "https://github.com/jstat17/Random-Walk-NFT/blob/main/openzeppelin-contracts/token/ERC721/ERC721.sol";

/**
 * @title RandomWalkNFT
 * @author John Michael Statheros (GitHub: jstat17)
 * @notice Contract for creating random walk map NFTs.
 */
contract RandomWalkNFT is ERC721, VRFConsumerBase {

    bytes32 internal keyHash = 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4;
    address internal vrfCoordinator = 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9;
    address internal linkToken = 0xa36085F69e2889c224210F603D836748e7dC0088;
    uint256 internal fee;
    uint256 public randomResult;
    
    struct RandomWalk {
        string name;
        uint256 ID;
        uint256 nodes;
        int256[] x;
        int256[] y;
    }
    
    RandomWalk[] private randomWalks;
    
    mapping(bytes32 => string) public requestToMapName;
    mapping(bytes32 => address) public requestToSender;
    mapping(bytes32 => uint256) public requestToTokenID;
    mapping(bytes32 => uint256) public requestToNodes;
    
    /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Kovan
     * Chainlink VRF Coordinator address: 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9
     * LINK token address:                0xa36085F69e2889c224210F603D836748e7dC0088
     * Key Hash: 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     */
    constructor ()
    //constructor (address _VRFCoordinator, address _LinkToken, bytes32 _keyHash)
    ERC721("Random Walk","RWalk")
    VRFConsumerBase(vrfCoordinator, linkToken)
    //VRFConsumerBase(_VRFCoordinator, _LinkToken)
    public {
        //vrfCoordinator = _VRFCoordinator;
        //keyHash = _keyHash;
        fee = 0.1 * 10**18; // 0.1 LINK
    }

    function requestRandomWalk(uint256 userProvidedSeed, uint256 nodes) public returns(bytes32) {
        bytes32 requestID = requestRandomness(keyHash, fee, userProvidedSeed); // get a random number from the oracle
        requestToMapName[requestID] = string(abi.encodePacked(uint2str(nodes), "-node walk"));
        requestToSender[requestID] = msg.sender;
        requestToNodes[requestID] = nodes;
        return requestID;
    }
    
    //this func actually gens the NFT
    function fulfillRandomness(bytes32 requestID, uint256 randomness) internal override {
        uint256 newID = randomWalks.length;
        int256[] memory xs = new int256[](requestToNodes[requestID]);
        int256[] memory ys = new int256[](requestToNodes[requestID]);
        //xs.push(0);
        xs[0] = 1;
        ys[0] = 1;
        randomResult = randomness;
        
        randomWalks.push(
            RandomWalk(
                requestToMapName[requestID],
                newID,
                requestToNodes[requestID],
                xs,
                ys
            )
        );
        _safeMint(requestToSender[requestID], newID);
    }
    
    function setTokenURI(uint256 tokenID, string memory _tokenURI) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenID),
            "ERC721: transfer caller is not owner nor approved"
        );
        _setTokenURI(tokenID, _tokenURI);
    }
    
    function seeRandomWalk(uint256 tokenID) public view returns(RandomWalk memory) {
        return randomWalks[tokenID];
    }
    
    // from: https://stackoverflow.com/questions/47129173/how-to-convert-uint-to-string-in-solidity
    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}