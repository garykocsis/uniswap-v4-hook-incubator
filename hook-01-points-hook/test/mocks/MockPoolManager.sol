// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {PoolId} from "v4-core/types/PoolId.sol";
import {IExtsload} from "v4-core/interfaces/IExtsload.sol";

/// @notice Simple mock used in tests for modules that need pool liquidity via StateLibrary.getLiquidity.
/// StateLibrary.getLiquidity calls extsload(liquiditySlot); this mock implements extsload and fills
/// the slot when setLiquidity(poolId, amount) is called using the same slot layout as v4 PoolManager.
contract MockPoolManager is IExtsload {
    bytes32 private constant POOLS_SLOT = bytes32(uint256(6));
    uint256 private constant LIQUIDITY_OFFSET = 3;

    mapping(bytes32 => bytes32) private slotValues;

    function setLiquidity(PoolId poolId, uint256 amount) external {
        bytes32 stateSlot = keccak256(abi.encodePacked(PoolId.unwrap(poolId), POOLS_SLOT));
        bytes32 liquiditySlot = bytes32(uint256(stateSlot) + LIQUIDITY_OFFSET);
        slotValues[liquiditySlot] = bytes32(uint256(amount));
    }

    function extsload(bytes32 slot) external view returns (bytes32 value) {
        return slotValues[slot];
    }

    function extsload(bytes32 startSlot, uint256 nSlots) external view returns (bytes32[] memory values) {
        values = new bytes32[](nSlots);
        for (uint256 i = 0; i < nSlots; i++) {
            values[i] = slotValues[bytes32(uint256(startSlot) + i)];
        }
    }

    function extsload(bytes32[] calldata slots) external view returns (bytes32[] memory values) {
        values = new bytes32[](slots.length);
        for (uint256 i = 0; i < slots.length; i++) {
            values[i] = slotValues[slots[i]];
        }
    }
}
