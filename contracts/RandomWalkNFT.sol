pragma solidity ^0.5.0;

import "./NumericalMath.sol";
import "./FixidityLib.sol";

contract RandomWalkNFT {
    int256 public pi;
    int256 public b;

    constructor () public {
        pi = NumericalMath.pi();
        int256 a = FixidityLib.newFixed(1);
        b = FixidityLib.add(pi, a);
    }

    function callKeccak256(bytes memory seed) internal pure returns(int256) {
        return int(keccak256(seed));
    }
    
    function getRandomNum(int256 num_seed, int256 upper, int256 lower) public pure returns(int256) {
        int256 rand_num = FixidityLib.abs(callKeccak256(abi.encodePacked(num_seed))) % (upper-lower+1) + lower;
        return rand_num;
    }
}