// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {MockPoolManager} from "../test/mocks/MockPoolManager.sol";

contract HelperConfig is Script {
    // This contract is used to store configuration data for the deployment scripts.
    // It can be extended to include more configurations as needed

    // https://developers.uniswap.org/docs/protocols/v4/deployments#sepolia-11155111
    address internal constant POOL_MANAGER_SEPOLIA = 0xE03A1074c86CFeDd5C142C4F04F1a1536e203543;
    // https://developers.uniswap.org/docs/protocols/v4/deployments#mainnet-1
    address internal constant POOL_MANAGER_MAINNET = 0x000000000004444c5dc75cB358380D2e3dE08A90;

    uint256 internal constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 internal constant MAINNET_CHAIN_ID = 1;

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address poolManager; //PoolManager address
    }

    constructor() {
        // Set the active network configuration based on the current network
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            // Sepolia
            activeNetworkConfig = getSepoliaConfig();
        } else if (block.chainid == MAINNET_CHAIN_ID) {
            // Mainnet
            activeNetworkConfig = getMainnetConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        } // use anvil config for local testing
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        // Sepolia pool manager address
        NetworkConfig memory sepoliaConfig = NetworkConfig({poolManager: POOL_MANAGER_SEPOLIA});
        console.log("Sepolia pool manager address:", sepoliaConfig.poolManager);
        return sepoliaConfig;
    }

    function getMainnetConfig() public pure returns (NetworkConfig memory) {
        // Sepolia price feed address
        NetworkConfig memory mainnetConfig = NetworkConfig({poolManager: POOL_MANAGER_MAINNET});
        console.log("Mainnet pool manager address:", mainnetConfig.poolManager);
        return mainnetConfig;
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        // Anvil pool manager address

        // 1. Deploy the Mock
        // 2 Return the address of the Mock

        if (activeNetworkConfig.poolManager != address(0)) {
            // If the pool manager is already set, return the existing config
            return activeNetworkConfig;
        }
        // If the pool manager is not set, deploy a new MockPoolManager

        vm.startBroadcast();

        MockPoolManager mockPoolManager = new MockPoolManager();

        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            poolManager: address(mockPoolManager) // Use the address of the deployed MockPoolManager
        });
        return anvilConfig;
    }
}
