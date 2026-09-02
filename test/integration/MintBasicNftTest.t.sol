// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {MintBasicNft} from "../../script/Interactions.s.sol";

contract MintBasicNftTest is Test {
    BasicNft public basicNft;
    DeployBasicNft public deployer;
    MintBasicNft public minter;

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
        minter = new MintBasicNft();
    }

    function testMintNftOnContractIncreasesBalance() public {
        uint256 startingBalance = basicNft.balanceOf(address(msg.sender));

        minter.mintNftOnContract(address(basicNft));

        assertEq(basicNft.balanceOf(address(msg.sender)), startingBalance + 1);
    }

    function testMintNftOnContractSetsCorrectTokenUri() public {
        minter.mintNftOnContract(address(basicNft));

        assertEq(basicNft.tokenURI(0), minter.PXDR());
    }

    function testMintNftOnContractSetsCorrectOwner() public {
        minter.mintNftOnContract(address(basicNft));

        assertEq(basicNft.ownerOf(0), address(msg.sender));
    }

    function testCanMintMultipleTimesViaScript() public {
        minter.mintNftOnContract(address(basicNft));
        minter.mintNftOnContract(address(basicNft));

        assertEq(basicNft.balanceOf(address(msg.sender)), 2);
        assertEq(basicNft.ownerOf(0), address(msg.sender));
        assertEq(basicNft.ownerOf(1), address(msg.sender));
    }
}
