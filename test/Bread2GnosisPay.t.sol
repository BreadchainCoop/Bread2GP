// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Bread2GnosisPay} from "../src/Bread2GnosisPay.sol";

contract Bread2GpayTest is Test {
    Bread2GnosisPay public bread2gnosispay;

    function setUp() public {
        bread2gnosispay = new Bread2GnosisPay();
    }
}
