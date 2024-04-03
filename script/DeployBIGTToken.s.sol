// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BIGTToken} from "../src/BIGTToken.sol";

contract DeployBIGToken is Script {
    uint256 public constant INITIAL_SUPPLY = 10000 ether;

    function run() external returns (BIGTToken) {
        vm.startBroadcast();
        BIGTToken bigt = new BIGTToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return bigt;
    }
}
