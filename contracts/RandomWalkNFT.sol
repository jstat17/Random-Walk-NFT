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
    
    int256 public test1;
    int256 public test2;
    
    bytes32 internal keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
    address internal vrfCoordinator = 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B;
    address internal linkToken = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;
    uint256 internal fee;
    int256 public randomResult;
    bytes32 public lastOracleRequest;
    
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
    mapping(address => bytes32) public senderToRequest;
    
    struct Walker {
        int256 x;
        int256 y;
        int256 currAngle;
        int256 angle_orig;
        uint8 big_digits;
        uint8 smaller_digits;
    }
    
    /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Kovan
     * Chainlink VRF Coordinator address: 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9
     * LINK token address:                0xa36085F69e2889c224210F603D836748e7dC0088
     * Key Hash: 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     * 
     * Network: Rinkeby
     * Chainlink VRF Coordinator address: 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B
     * LINK token address:                0x01be23585060835e02b77ef475b0cc51aa1e0709
     * Key Hash: 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311

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
    
    function generateRandomWalkNFT() public returns(bool success) {
        bytes32 requestID = senderToRequest[msg.sender];
        uint256 newID = randomWalks.length;
        int256[] memory xs = new int256[](requestToNodes[requestID]);
        int256[] memory ys = new int256[](requestToNodes[requestID]);
        //xs.push(0);
        xs[0] = 0;
        ys[0] = 0;
        
        
        int256 _2pi = FixidityLib.multiply(FixidityLib.newFixed(2), NumericalMath.pi());
        int256 _pi_on_2 = FixidityLib.multiply(FixidityLib.divide(1, 2), NumericalMath.pi());
        int256 _pi_on_4 = FixidityLib.multiply(FixidityLib.divide(1, 4), NumericalMath.pi());
        
        //test1 = _pi_on_2;
        test2 = _pi_on_4;
        
        Walker memory walker;
        walker.x = 0;
        walker.y = 0;
        
        //int256[] memory loc = new int256[](2); // current location
        //loc[0] = 0;
        //loc[1] = 0;
        // new starting angle between 0 and 2π rad
        walker.angle_orig = NumericalMath.convBtwUpLo(randomResult, 0, _2pi);
        test1 = walker.angle_orig;
        
        //int256 zero = FixidityLib.newFixed(0); // check this zero if it is neccessary
        //int256 currAngle;
        walker.big_digits = FixidityLib.digits();
        walker.smaller_digits = 4;
        //xs[1] = FixidityLib.add(walker.x, NumericalMath.cos(FixidityLib.convertFixed(walker.currAngle, walker.big_digits, walker.smaller_digits), walker.smaller_digits));
        //ys[1] = FixidityLib.add(walker.y, NumericalMath.sin(FixidityLib.convertFixed(walker.currAngle, walker.big_digits, walker.smaller_digits), walker.smaller_digits));
        
        for (uint256 _i = 1; _i < requestToNodes[requestID]; _i++) {
            // Get new angle to walk towards
            if (_i == 1) {
                walker.currAngle = walker.angle_orig;
            } else {
                randomResult = NumericalMath.callKeccak256(abi.encodePacked(randomResult));
                walker.currAngle = FixidityLib.add(walker.currAngle, FixidityLib.subtract(NumericalMath.getRandomNum(randomResult, 0, _pi_on_2), _pi_on_4));
            }
            // Walk forwards in the new angle by 1 unit
            walker.x = FixidityLib.add(walker.x, NumericalMath.cos(walker.currAngle, walker.big_digits));
            walker.y = FixidityLib.add(walker.y, NumericalMath.sin(walker.currAngle, walker.big_digits));
            // Add new location as a node
            xs[_i] = walker.x;
            ys[_i] = walker.y;
            
            //tempWalker = walker;
            
        }
        
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
        return true;
    }
    
    function requestRandomWalk(uint256 userProvidedSeed, uint256 nodes) public returns(bytes32) {
        bytes32 requestID = requestRandomness(keyHash, fee, userProvidedSeed); // get a random number from the oracle
        requestToMapName[requestID] = string(abi.encodePacked(uint2str(nodes), "-node walk"));
        requestToSender[requestID] = msg.sender;
        requestToNodes[requestID] = nodes;
        senderToRequest[msg.sender] = requestID;
        return requestID;
    }
    
    //this func actually gens the NFT
    function fulfillRandomness(bytes32 requestID, uint256 randomness) internal override {
        randomResult = FixidityLib.abs(int256(randomness));
        lastOracleRequest = requestID;
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
    
    function testNumMath(int256 theta, uint8 digits) public pure returns(int256) {
        int256 a = NumericalMath.sin(theta, digits);
        return a;
    }
    
    function getAnotherSplitRand(int256 x, int256 y, int256 y_orig) internal pure returns(int256, int256) {
        int256 y_div = FixidityLib.divide(y, y_orig);
        int256 new_rand = FixidityLib.add(FixidityLib.divide(x % y, y_div), 1);
        y = FixidityLib.multiply(y, y);
        return (new_rand, y);
    }
}