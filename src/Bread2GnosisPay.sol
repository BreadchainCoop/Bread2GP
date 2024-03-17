// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {OwnableUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface IStableSwap3Pool {
    // https://github.com/curvefi/curve-contract/blob/master/contracts/pools/3pool/StableSwap3Pool.vy#L431
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
    // https://github.com/curvefi/curve-contract/blob/master/contracts/pools/3pool/StableSwap3Pool.vy#L402
    function get_dy(int128 i, int128 j, uint256 dx) external view returns (uint256);
}

contract Bread2GnosisPay is OwnableUpgradeable {

    address private constant GBPE_TOKEN_ADDRESS = 0x5Cb9073902F2035222B9749F8fB0c9BFe5527108;
    address private constant BREAD_TOKEN_ADDRESS = 0xa555d5344f6FB6c65da19e403Cb4c1eC4a1a5Ee3;
    address private constant CURVE_POOL_ADDRESS = 0x32b0456100e4fEBcA554244B225706B1BEeeaEB1;
    
    IERC20 private gbpeToken = IERC20(GBPE_TOKEN_ADDRESS);
    IERC20 private breadToken = IERC20(BREAD_TOKEN_ADDRESS);
    IStableSwap3Pool private curvePool = IStableSwap3Pool(CURVE_POOL_ADDRESS);

    error TransferFailed();
    error ApprovalFailed();
    event TransferSuccessful(address to, uint256 amount);
    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

    function swapAndTransfer(address safeWallet, uint256 amount, uint256 min_dy) external {
        // Transfer BREAD tokens from sender to this contract
        require(breadToken.transferFrom(msg.sender, address(this), amount), "BREAD transfer failed");

        // Perform the swap on Curve, converting BREAD to GBPe
        curvePool.exchange(
            0, // Index for GBPe in Curve pool,
            1, // Index for BREAD in Curve pool,
            1, // Min amount of GBPe to accept
            min_dy
        );

        // Get the swapped GBPe balance of this contract
        uint256 gbpeBalance = gbpeToken.balanceOf(address(this));

        // Transfer GBPe tokens from this contract to the provided SAFE wallet
        require(gbpeToken.transfer(safeWallet, gbpeBalance), "GBPe transfer failed");

        emit TransferSuccessful(safeWallet, amount);
    }

    // Computes min_dy with a specified slippage tolerance
    function computeMinDy(int128 i, int128 j, uint256 dx, uint256 slippageToleranceInBasisPoints) external view returns (uint256) {
        uint256 expected_dy = curvePool.get_dy(i, j, dx);
        uint256 slippageTolerance = slippageToleranceInBasisPoints * 1e14; // Convert basis points to a proportion
        uint256 min_dy = expected_dy * (1e18 - slippageTolerance) / 1e18;
        return min_dy;
    }
}
