// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./FixidityLib.sol";

/**
 * @title NumericalMath
 * @author John Michael Statheros (GitHub: jstat17)
 * @notice This library builds on the fixed-point math in FixidityLib with
 * numerical approximations to trigonometric functions, the value of pi etc.
 */
library NumericalMath {
    /**
     * @notice Returns value of pi to 24 digits of precision.
     * @return π as int256
    */
    function pi() public pure returns(int256) {
        return 3141592653589793238462643;
    }
    
    /**
     * @notice 7th order numerical approximation to the sine function.
     * @param theta: angle in radians
     * @param digits: digits of precision of the angle
     * @return sin(x)
     * @dev Example input:  sin(11,1) => sin(1.1)
     *                      sin(3,0) => sin(3)
     */
    function sin(int256 theta, uint8 digits) public pure returns(int256){
        int256 x = FixidityLib.newFixed(theta, digits);
        int256 _2pi = FixidityLib.multiply(FixidityLib.newFixed(2),pi());
        int256 _3_2pi = FixidityLib.multiply(pi(), FixidityLib.newFixedFraction(3, 2));
        x = normAngle(x);
        int256 temp = FixidityLib.abs(FixidityLib.subtract(x, pi()));
        
        if (FixidityLib.subtract(x, pi()) < 0 && FixidityLib.subtract(x, FixidityLib.divide(pi(), FixidityLib.newFixed(2))) > 0) { // > 90 deg and < 180 deg
            x = temp;
        } else if (FixidityLib.subtract(x, pi()) > 0 && FixidityLib.subtract(x, _3_2pi) < 0) { // > 180 deg and < 270 deg
            x = FixidityLib.subtract(temp, FixidityLib.multiply(temp, FixidityLib.newFixed(2)));
        } else if(FixidityLib.subtract(x, _3_2pi) > 0) { // > 270 deg and < 360 deg
            x = FixidityLib.subtract(x, _2pi);
        }
        
        int256 x_3 = FixidityLib.multiply(FixidityLib.multiply(x, x), x);
        int256 x_5 = FixidityLib.multiply(FixidityLib.multiply(x_3, x), x);
        
        int256 a = FixidityLib.subtract(x, FixidityLib.divide(x_3, FixidityLib.newFixed(6)));
        int256 b = FixidityLib.add(a, FixidityLib.divide(x_5, FixidityLib.newFixed(120)));
        return b;
    }
    
    /**
     * @notice 6th order numerical approximation to the cosine function.
     * @param theta: angle in radians
     * @param digits: digits of precision of the angle
     * @return cos(x)
     * @dev Example input:  cos(11,1) => cos(1.1)
     *                      cos(3,0) => cos(3)
     */
    function cos(int256 theta, uint8 digits) public pure returns(int256){
        int256 x = FixidityLib.newFixed(theta, digits);
        int256 _2pi = FixidityLib.multiply(FixidityLib.newFixed(2),pi());
        int256 _3_2pi = FixidityLib.multiply(pi(), FixidityLib.newFixedFraction(3, 2));
        x = normAngle(x);
        int256 temp = FixidityLib.abs(FixidityLib.subtract(x, pi()));
        int8 c = 1;
        
        if (FixidityLib.subtract(x, pi()) < 0 && FixidityLib.subtract(x, FixidityLib.divide(pi(), FixidityLib.newFixed(2))) > 0) { // > 90 deg and < 180 deg
            x = temp;
            c = -1;
        } else if (FixidityLib.subtract(x, pi()) > 0 && FixidityLib.subtract(x, _3_2pi) < 0) { // > 180 deg and < 270 deg
            x = FixidityLib.subtract(temp, FixidityLib.multiply(temp, FixidityLib.newFixed(2)));
            c = -1;
        } else if(FixidityLib.subtract(x, _3_2pi) > 0) { // > 270 deg and < 360 deg
            x = FixidityLib.subtract(x, _2pi);
        }
        
        int256 x_2 = FixidityLib.multiply(x, x);
        int256 x_4 = FixidityLib.multiply(x_2, x_2);
        
        int256 a = FixidityLib.subtract(FixidityLib.fixed1(), FixidityLib.divide(x_2, FixidityLib.newFixed(2)));
        int256 b = FixidityLib.add(a, FixidityLib.divide(x_4, FixidityLib.newFixed(24)));
        return b*c;
    }
    /**
     * @notice Numerical approximation of the tangent function,
     * using the fact that sin(x)/cos(x) = tan(x).
     * @param theta: angle in radians
     * @param digits: digits of precision of the angle
     * @return tan(x)
     * @dev Example input:  tan(11,1) => tan(1.1)
     *                      tan(3,0) => tan(3)
     */
    function tan(int256 theta, uint8 digits) public pure returns(int256) {
        return (FixidityLib.divide(sin(theta, digits), cos(theta, digits)));
        /** Taylor series approximation of tan(x), but is poor near asymptotes.
         * 
        int256 x = FixidityLib.newFixed(theta, digits);
        int256 _2pi = FixidityLib.multiply(FixidityLib.newFixed(2),pi());
        int256 _3_2pi = FixidityLib.multiply(pi(), FixidityLib.newFixedFraction(3, 2));
        x = normAngle(x);
        int256 temp = FixidityLib.abs(FixidityLib.subtract(x, pi()));
        int8 c = 1;
        
        if (FixidityLib.subtract(x, pi()) < 0 && FixidityLib.subtract(x, FixidityLib.divide(pi(), FixidityLib.newFixed(2))) > 0) { // > 90 deg and < 180 deg
            x = temp;
            c = -1;
        } else if (FixidityLib.subtract(x, pi()) > 0 && FixidityLib.subtract(x, _3_2pi) < 0) { // > 180 deg and < 270 deg
            x = FixidityLib.subtract(temp, FixidityLib.multiply(temp, FixidityLib.newFixed(2)));
        } else if(FixidityLib.subtract(x, _3_2pi) > 0) { // > 270 deg and < 360 deg
            x = FixidityLib.subtract(x, _2pi);
            c = -1;
        }
        
        int256 x_3 = FixidityLib.multiply(FixidityLib.multiply(x, x), x);
        int256 x_5 = FixidityLib.multiply(FixidityLib.multiply(x_3, x), x);
        
        int256 a = FixidityLib.add(x, FixidityLib.divide(x_3, FixidityLib.newFixed(3)));
        int256 b = FixidityLib.add(a, FixidityLib.multiply(x_5, FixidityLib.newFixedFraction(2, 15)));
        return b*c;
        */
    }
    
    /**
     * @notice Helper function for the trigonometric functions,
     * which transforms any angle > 360 deg or < -360 deg to
     * -360 < x < 360, or its 'normal'/'standard' representation.
     * @param x: angle in radians
     * @return angle x where -2π < x < 2π
     */
    function normAngle(int256 x) internal pure returns(int256) {
        int256 _2pi = FixidityLib.multiply(FixidityLib.newFixed(2),pi());
        bool k = false;
        while (!k) {
            int256 x_sub2pi = FixidityLib.subtract(x, _2pi);
            if (x_sub2pi > 0) {
                x = x_sub2pi;
                continue;
            }
            
            int256 x_add2pi = FixidityLib.add(x, _2pi);
            if (x_add2pi < 0) {
                x = x_add2pi;
                continue;
            }
            
            k = !k;
        }
        return x;
    }
}