// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "../lib/forge-std/src/Test.sol";
import {TravelInsurance} from "../src/TravelInsurance.sol";

contract CounterTest is Test {
    TravelInsurance public travelInsurance;

    function setUp() public {
        travelInsurance = new TravelInsurance();
    }

    /*function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }*/
}
