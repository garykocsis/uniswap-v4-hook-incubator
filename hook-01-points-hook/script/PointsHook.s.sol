// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {Hooks} from "v4-core/libraries/Hooks.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {HookMiner} from "v4-hooks-public/src/utils/HookMiner.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

import {PointsHook} from "../src/PointsHook.sol";

contract PointsHookScript is Script {
    // https://getfoundry.sh/guides/deterministic-deployments-using-create2/#getting-started
    address internal constant CREATE2_DEPLOYER = 0x4e59b44847b379578588920cA78FbF26c0B4956C;

    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");

        // Get the pool manager address
        HelperConfig helperConfig = new HelperConfig();
        address poolManager = helperConfig.activeNetworkConfig();
        console.log("PoolManager address:", poolManager);

        // Hook contracts must have specific flags encoded in the address
        uint160 permissions = Hooks.AFTER_SWAP_FLAG;

        // Mine a salt that will produce a hook address with the correct flags
        bytes memory constructorArgs = abi.encode(IPoolManager(address(poolManager)));
        (address predicted, bytes32 salt) =
            HookMiner.find(CREATE2_DEPLOYER, permissions, type(PointsHook).creationCode, constructorArgs);
        console.log("Hook address:", predicted);
        console.log("Salt:");
        console.logBytes32(salt);

        // ✅ Deterministic CREATE2 check
        // Before startBroadcast -> nor a "real" transaction
        vm.startBroadcast(pk);

        address deployed = address(new PointsHook{salt: salt}(IPoolManager(address(poolManager))));
        require(address(deployed) == predicted, "CREATE2 mismatch");

        vm.stopBroadcast();
    }
}
