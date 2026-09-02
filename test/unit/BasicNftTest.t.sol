//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract BasicNftTest is Test {
    BasicNft public basicNft;
    DeployBasicNft public deployer;
    address public Bob = makeAddr("Bob");
    address public Alice = makeAddr("Alice");

    string public constant PXDR = "ipfs://bafkreienadiihgkfdvlkuming5cuajr3ovdvdw5f7dewyuibn2ecfj3x2i";
    string public constant PXDR2 = "ipfs://bafkreibd4nswuk4bdtvqndnqyipgf3rjnovsc6wre5yvrbbamefi54pbsa";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    /*//////////////////////////////////////////////////////////
                            METADATA
    //////////////////////////////////////////////////////////*/

    function testNameIsCorrect() public view {
        string memory expectedName = "PixelDrifters";
        string memory actualName = basicNft.name();

        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testSymbolIsCorrect() public view {
        string memory expectedSymbol = "PXDR";
        string memory actualSymbol = basicNft.symbol();

        assert(keccak256(abi.encodePacked(expectedSymbol)) == keccak256(abi.encodePacked(actualSymbol)));
    }

    /*//////////////////////////////////////////////////////////
                            MINTING
    //////////////////////////////////////////////////////////*/

    function testCanMintAndHaveABalance() public {
        vm.prank(Bob);
        basicNft.mintNft(PXDR);

        assert(basicNft.balanceOf(Bob) == 1);
        assert(keccak256(abi.encodePacked(PXDR)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }

    function testBalanceIsZeroBeforeAnyMint() public view {
        assertEq(basicNft.balanceOf(Bob), 0);
    }

    function testOwnerOfMintedTokenIsCorrect() public {
        vm.prank(Bob);
        basicNft.mintNft(PXDR);

        assertEq(basicNft.ownerOf(0), Bob);
    }

    function testTokenIdsIncrementSequentially() public {
        vm.prank(Bob);
        basicNft.mintNft(PXDR);

        vm.prank(Alice);
        basicNft.mintNft(PXDR2);

        assertEq(basicNft.ownerOf(0), Bob);
        assertEq(basicNft.ownerOf(1), Alice);
    }

    function testMultipleMintsToSameUserIncreaseBalance() public {
        vm.startPrank(Bob);
        basicNft.mintNft(PXDR);
        basicNft.mintNft(PXDR2);
        vm.stopPrank();

        assertEq(basicNft.balanceOf(Bob), 2);
    }

    function testDifferentTokensCanHaveDifferentUris() public {
        vm.prank(Bob);
        basicNft.mintNft(PXDR);

        vm.prank(Alice);
        basicNft.mintNft(PXDR2);

        assertEq(basicNft.tokenURI(0), PXDR);
        assertEq(basicNft.tokenURI(1), PXDR2);
    }

    function testMintEmitsTransferEvent() public {
        vm.prank(Bob);
        vm.expectEmit(true, true, true, true, address(basicNft));
        emit IERC721.Transfer(address(0), Bob, 0);
        basicNft.mintNft(PXDR);
    }

    /*//////////////////////////////////////////////////////////
                        TOKEN URI BEHAVIOR
    //////////////////////////////////////////////////////////*/

    function testTokenUriForUnmintedTokenReturnsEmptyString() public view {
        // NOTE: this contract overrides tokenURI() without an existence check
        // (no _requireMinted/_requireOwned), so querying an unminted tokenId
        // does not revert -- it just returns the mapping's default value.
        assertEq(basicNft.tokenURI(0), "");
    }

    /*//////////////////////////////////////////////////////////
                            TRANSFERS
    //////////////////////////////////////////////////////////*/

    function testOwnerCanTransferMintedNft() public {
        vm.prank(Bob);
        basicNft.mintNft(PXDR);

        vm.prank(Bob);
        basicNft.transferFrom(Bob, Alice, 0);

        assertEq(basicNft.ownerOf(0), Alice);
        assertEq(basicNft.balanceOf(Bob), 0);
        assertEq(basicNft.balanceOf(Alice), 1);
    }

    function testNonOwnerCannotTransferNft() public {
        vm.prank(Bob);
        basicNft.mintNft(PXDR);

        vm.prank(Alice);
        vm.expectRevert();
        basicNft.transferFrom(Bob, Alice, 0);
    }

    function testQueryingOwnerOfUnmintedTokenReverts() public {
        vm.expectRevert();
        basicNft.ownerOf(0);
    }
}
