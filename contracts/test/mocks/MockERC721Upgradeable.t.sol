// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/**
 * @title MockERC721Upgradeable - Test
 */

// import "hardhat/console.sol";
import { Vm } from 'foundry-test-utility/contracts/utils/vm.sol';
import 'foundry-test-utility/contracts/utils/console.sol';
import { DSTest } from 'foundry-test-utility/contracts/utils/test.sol';
import { CheatCodes } from 'foundry-test-utility/contracts/utils/cheatcodes.sol';

import { MockERC721Upgradeable } from '../../mocks/MockERC721Upgradeable.sol';

contract MockERC721UpgradeableTest is DSTest {
  Vm public constant vm = Vm(address(uint160(uint256(keccak256('hevm cheat code')))));

  MockERC721Upgradeable private mockERC721Upgradeable;

  string constant _TEST_NAME = 'MockERC721Upgradeable';
  string constant _TEST_SYMBOL = 'MOCK';

  function setUp() public {
    // Deploy contracts
    mockERC721Upgradeable = new MockERC721Upgradeable();
    mockERC721Upgradeable.initialize(_TEST_NAME, _TEST_SYMBOL);
  }

  function test_MockERC721Upgradeable_name() public {
    assertEq(mockERC721Upgradeable.name(), _TEST_NAME);
  }

  function test_MockERC721Upgradeable_symbol() public {
    assertEq(mockERC721Upgradeable.symbol(), _TEST_SYMBOL);
  }

  function test_MockERC721Upgradeable_mint(address to_, uint256 tokenId_) public {
    vm.assume(to_ != address(0) && to_.code.length == 0);
    vm.assume(tokenId_ > 0);

    assertEq(mockERC721Upgradeable.balanceOf(to_), 0);

    mockERC721Upgradeable.mint(to_, tokenId_);

    assertEq(mockERC721Upgradeable.balanceOf(to_), 1);
    assertEq(mockERC721Upgradeable.ownerOf(tokenId_), to_);
  }

  function test_MockERC721Upgradeable_burn(address to_, uint256 tokenId_) public {
    vm.assume(to_ != address(0) && to_.code.length == 0);
    vm.assume(tokenId_ > 0);

    assertEq(mockERC721Upgradeable.balanceOf(to_), 0);

    mockERC721Upgradeable.mint(to_, tokenId_);

    assertEq(mockERC721Upgradeable.balanceOf(to_), 1);
    assertEq(mockERC721Upgradeable.ownerOf(tokenId_), to_);

    vm.prank(to_);

    mockERC721Upgradeable.burn(tokenId_);

    assertEq(mockERC721Upgradeable.balanceOf(to_), 0);
  }
}
