//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract MintBasicNft is Script {
    string public constant PXDR = "ipfs://bafkreienadiihgkfdvlkuming5cuajr3ovdvdw5f7dewyuibn2ecfj3x2i";
    string public constant PXDR2 = "ipfs://bafkreibd4nswuk4bdtvqndnqyipgf3rjnovsc6wre5yvrbbamefi54pbsa";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(PXDR);
        vm.stopBroadcast();
    }
}
