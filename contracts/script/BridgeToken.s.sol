//SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {BridgeToken} from "../src/BridgeToken.sol";

contract BridgeTokenScript is Script {
    BridgeToken public bridgeToken;

    function setUp() public {}

    function run() external {
        vm.createSelectFork("base-sepolia");
        vm.startBroadcast();

        bridgeToken = new BridgeToken();

        vm.stopBroadcast();
    }
}