// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Bread2GPay} from "../src/Bread2GPay.sol";

contract Bread2GpayTest is Test {
    Bread2GPay public bread2gpay;

    function setUp() public {
        bread2gpay = new Bread2GPay();
    }
}
