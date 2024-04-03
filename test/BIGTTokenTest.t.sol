// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployBIGToken} from "../script/DeployBIGTToken.s.sol";
import {BIGTToken} from "../src/BIGTToken.sol";

contract BIGTTokenTest is Test {
    BIGTToken public bigtToken;
    DeployBIGToken public deployer;

    uint256 public constant STARTING_BALANCE = 500 ether;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    function setUp() public {
        deployer = new DeployBIGToken();
        bigtToken = deployer.run();

        vm.startPrank(msg.sender);
        bigtToken.transfer(bob, STARTING_BALANCE);
        vm.stopPrank();
    }

    function testbobBalance() public view {
        assertEq(STARTING_BALANCE, bigtToken.balanceOf(bob));
    }

    function testAllowances() public {
        uint256 initialAllowance = 200 ether;
        // bob approves alice to spend tokens on her behalf
        vm.prank(bob);
        bigtToken.approve(alice, initialAllowance);

        uint256 transferAmount = 100 ether;
        vm.prank(alice);
        bigtToken.transferFrom(bob, alice, transferAmount);

        assertEq(bigtToken.balanceOf(alice), transferAmount);
        assertEq(bigtToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testInitialSupply() public view {
        assertEq(bigtToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testAllowanceUpdate() public {
        uint256 newAllowance = 300 ether;
        vm.prank(bob);
        bigtToken.approve(alice, newAllowance);

        assertEq(bigtToken.allowance(bob, alice), newAllowance);
    }

    function testTransfer() public {
        uint256 transferAmount = 50 ether;
        vm.prank(bob);
        bigtToken.transfer(alice, transferAmount);

        assertEq(bigtToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(bigtToken.balanceOf(alice), transferAmount);
    }
    // have problem with minting

    // function testMinting() public view {
    //     // Assuming the initial supply is correctly set in the constructor
    //     assertEq(bigtToken.totalSupply(), STARTING_BALANCE);
    //     assertEq(bigtToken.balanceOf(msg.sender), STARTING_BALANCE);
    // }

    function testDecimals() public view {
        assertEq(bigtToken.decimals(), 18); // Assuming your token uses 18 decimals
    }

    function testSymbol() public view {
        assertEq(bigtToken.symbol(), "BIGT");
    }

    function testName() public view {
        assertEq(bigtToken.name(), "BigTToken");
    }

    function testTransferFrom() public {
        uint256 transferAmount = 100 ether;
        vm.prank(bob);
        bigtToken.approve(alice, transferAmount);

        vm.prank(alice);
        bigtToken.transferFrom(bob, alice, transferAmount);

        assertEq(bigtToken.balanceOf(alice), transferAmount);
        assertEq(bigtToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testRevertOnInsufficientAllowance() public {
        uint256 transferAmount = 1000 ether;
        vm.prank(bob);
        bigtToken.approve(alice, transferAmount - 1 ether); // Allow less than the transfer amount

        vm.prank(alice);
        bool success = false;
        try bigtToken.transferFrom(bob, alice, transferAmount) {
            success = true;
        } catch {
            success = false;
        }

        assertEq(success, false);
    }
}
