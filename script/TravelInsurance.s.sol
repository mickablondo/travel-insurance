// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Script } from "../lib/forge-std/src/Script.sol";
import {TravelInsurance} from "../src/TravelInsurance.sol";

contract TravelInsuranceScript is Script {
    TravelInsurance public travelInsurance;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        travelInsurance = new TravelInsurance();

        vm.stopBroadcast();
    }
}