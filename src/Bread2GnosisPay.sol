// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {OwnableUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {ERC20VotesUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

interface IStableSwap3Pool {
    // https://github.com/curvefi/curve-contract/blob/master/contracts/pools/3pool/StableSwap3Pool.vy#L431
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
    // https://github.com/curvefi/curve-contract/blob/master/contracts/pools/3pool/StableSwap3Pool.vy#L402
    function get_dy(int128 i, int128 j, uint256 dx) external view returns (uint256);
}

contract Bread2GnosisPay is OwnableUpgradeable {

    address public constant GBPE_TOKEN_ADDRESS = 0x5Cb9073902F2035222B9749F8fB0c9BFe5527108;
    address public constant BREAD_TOKEN_ADDRESS = 0xa555d5344f6FB6c65da19e403Cb4c1eC4a1a5Ee3;
    address public constant CURVE_POOL_ADDRESS = 0x32b0456100e4fEBcA554244B225706B1BEeeaEB1;
    function initialize() public initializer {
        __Ownable_init(msg.sender);
        IERC20(BREAD_TOKEN_ADDRESS).approve(CURVE_POOL_ADDRESS, type(uint256).max);
    }

    function swapAndTransfer(address safeWallet, uint256 amount, uint256 min_dy) external {
        // Transfer BREAD tokens from sender to this contract
        IERC20(BREAD_TOKEN_ADDRESS).transferFrom(msg.sender, address(this), amount);

        // Perform the swap on Curve, converting BREAD to GBPe
        IStableSwap3Pool(CURVE_POOL_ADDRESS).exchange(
            1, // Send BREAD
            0, // Receive GBPe
            amount, // Amount of BREAD to send
            min_dy // Minimum amount of GBPe to receive (slippage tolerance)
        );

        // Get the swapped GBPe balance of this contract
        uint256 gbpeBalance = IERC20(GBPE_TOKEN_ADDRESS).balanceOf(address(this));

        // Transfer GBPe tokens from this contract to the provided Gnosis Pay addresss
        IERC20(GBPE_TOKEN_ADDRESS).transfer(safeWallet, gbpeBalance);

    }


}
