// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Bread2GnosisPay} from "../src/Bread2GnosisPay.sol";
import {TransparentUpgradeableProxy} from "openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {ERC20VotesUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC20VotesUpgradeable.sol";

abstract contract Bread is ERC20VotesUpgradeable {
    function mint(address receiver) external payable virtual;
}
contract Bread2GpayTest is Test {
    Bread2GnosisPay public bread2gnosispay;
    Bread public bread= Bread(0xa555d5344f6FB6c65da19e403Cb4c1eC4a1a5Ee3);
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
        vm.deal(address(this),10000000000000);
    }

    function test_approve_and_swap() public {
        bread.mint{value:10000}(address(this));
        bread.approve(address(bread2gnosispay), 100);
        bread2gnosispay.swapAndTransfer(address(this), 100, 1);
    }
}
