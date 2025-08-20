//SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/Console.sol";
import {BridgeToken} from "../src/BridgeToken.sol";
import {MockToken} from "../src/MockToken.sol";

contract TestBridge is Test {
    BridgeToken bridgeToken;
    MockToken mockToken;

    address owner = makeAddr("owner");
    address user = makeAddr("user");
    address recipient = makeAddr("recipient");

    function setUp() external {
        vm.prank(owner);

        bridgeToken = new BridgeToken();
        mockToken = new MockToken();

        mockToken.transfer(user, 1_000 * 10 ** mockToken.decimals());
    }

    function testBridge() external {

        uint256 amount = 100 * 10 ** mockToken.decimals();

        vm.startPrank(user);

        console.log(user);
        console.log(owner);
        mockToken.approve(address(bridgeToken), amount);
        assertEq(mockToken.allowance(user, address(bridgeToken)), amount);

        bridgeToken.bridge(mockToken, amount);

        assertEq(mockToken.balanceOf(address(bridgeToken)), amount);
        assertEq(mockToken.balanceOf(user), 900 * 10 ** mockToken.decimals());

        console.log("Contract Balance: ",mockToken.balanceOf(address(bridgeToken)));
        vm.stopPrank();
    }

    function testRedeem() external {

        uint256 amount = 100 * 10 ** mockToken.decimals();

        vm.startPrank(user);
        mockToken.approve(address(bridgeToken), amount);
        bridgeToken.bridge(mockToken, amount);
        vm.stopPrank();

        assertEq(mockToken.balanceOf(address(bridgeToken)), amount);

        vm.startPrank(owner);

        bridgeToken.redeem(mockToken, recipient, amount, 1);

        assertEq(mockToken.balanceOf(recipient), amount);

        assertEq(bridgeToken.nonce(), 1);
    }

}