// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Bread2GnosisPay} from "../src/Bread2GnosisPay.sol";
import {TransparentUpgradeableProxy} from "openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract Bread2GPayScript is Script {
    Bread2GnosisPay public bread2gnosispay;

    function setUp() public {
        Bread2GnosisPay bread2gnosispayimplementation = new Bread2GnosisPay();
        bread2gnosispay =  Bread2GnosisPay(
            address(
                new TransparentUpgradeableProxy(
                    address(bread2gnosispayimplementation),
                    address(msg.sender),
                    "" 
                )
            )
        );
    }

    function run() public {
        vm.broadcast();
    }
}
