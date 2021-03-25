// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NumericalMath.sol";
import "./FixidityLib.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

/**
 * @title RandomWalkNFT
 * @author John Michael Statheros (GitHub: jstat17)
 * @notice Contract for creating random walk map NFTs.
 */
contract RandomWalkNFT{
    uint256 id = 0;
    struct coords {
        int256[] x;
        int256[] y;
    }
    mapping(uint256 => coords) RandomWalkTable;
    mapping(uint256 => address) owners;
    
    constructor () public {
        
    }

    /**
     * @notice Generates a random int256 between some upper
     * and lower bounds using an int256 seed.
     * @param num_seed: integer seed
     * @param upper: upper-bound of the random number
     * @param lower: lower-bound of the random number
     * @return random int256 between upper and lower (inclusive)
     */
    function getRandomNum(int256 num_seed, int256 upper, int256 lower) public pure returns(int256) {
        int256 rand_num = FixidityLib.abs(callKeccak256(abi.encodePacked(num_seed))) % (upper-lower+1) + lower;
        return rand_num;
    }
    
    /**
     * @notice Helper function to hash a seed using keccak256.
     * @param seed: bytes object
     * @return int256 of hashed seed
     */
    function callKeccak256(bytes memory seed) internal pure returns(int256) {
        return int256(uint256(keccak256(seed)));
    }
    
    //function bytes32ToInt256(bytes32 b) internal pure returns(int256) {
        //int256 num;
        //for(uint8 i = 0; i < 32; i++) {
            //int256 exp = int256(2**uint256(8*(32-(i+1))));
            //num = num + int256(uint8(bytes1(b[i])))*exp;
        //}
    //}
    
    //function bytes32ToInt256(bytes32 b) internal pure returns(int256) {
        //bytes memory buffer = new bytes(32);
        //buffer = b;
        //bytes32 preI;
        //uint256 offset = 32;
        //assembly {
            //preI := mload(add(b, offset))
        //}
        //int256 x = int256(preI);
    //}
    
    function generateRandomWalk(int256 nodes) public returns(bool success) {
        return true;
    }
}