pragma solidity ^0.5.0;

import "./NumericalMath.sol";
import "./FixidityLib.sol";

/**
 * @title RandomWalkNFT
 * @author John Michael Statheros (GitHub: jstat17)
 * @notice Contract for creating random walk map NFTs.
 */
contract RandomWalkNFT {
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
     * @param seed: integer seed
     * @param upper: upper-bound of the random number
     * @param lower: lower-bound of the random number
     * @return random int256 between upper and lower (inclusive)
     */
    function getRandomNum(int256 num_seed, int256 upper, int256 lower) public pure returns(int256) {
        return rand_num = FixidityLib.abs(callKeccak256(abi.encodePacked(num_seed))) % (upper-lower+1) + lower;
    }
    
    /**
     * @notice Helper function to hash a seed using keccak256.
     * @param seed: bytes object
     * @return int256 of hashed seed
     */
    function callKeccak256(bytes memory seed) internal pure returns(int256) {
        return int(keccak256(seed));
    }
    
    function generateRandomWalk(int256 nodes) public returns(bool success) {
        return true;
    }
}