// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'foundry-test-utility/contracts/utils/console.sol';
import { CheatCodes } from 'foundry-test-utility/contracts/utils/cheatcodes.sol';

import { Constants } from './constants.t.sol';
import { Errors } from './errors.t.sol';
import { TestStorage } from './testStorage.t.sol';

import { SimpleNftMarketplace } from '../../SimpleNftMarketplace.sol';

contract Functions is Constants, Errors, TestStorage {
  SimpleNftMarketplace public marketplace;

  enum TestType {
    Standard
  }

  function initialize_tests(uint8 LOG_LEVEL_) public returns (SimpleNftMarketplace) {
    // Set general test settings
    _LOG_LEVEL = LOG_LEVEL_;
    vm.roll(1);
    vm.warp(100);
    vm.startPrank(ADMIN);

    marketplace = new SimpleNftMarketplace();

    marketplace.initialize(TREASSURY);

    vm.stopPrank();
    vm.roll(block.number + 1);
    vm.warp(block.timestamp + 100);

    return marketplace;
  }

  function helper_createListing(address sender, address tokenContract, uint256 tokenId, uint256 salePrice) public {
    vm.prank(sender);
    marketplace.createListing(tokenContract, tokenId, salePrice);
  }

  function helper_buyListing(address sender, uint256 listingId) public {
    vm.prank(sender);
    marketplace.buyListing(listingId);
  }

  function helper_createListing(
    address sender,
    address tokenContract,
    uint256 tokenId,
    uint256 salePrice,
    address seller,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) public {
    vm.prank(sender);
    marketplace.createListing(tokenContract, tokenId, salePrice, seller, v, r, s);
  }

  function helper_buyListing(address sender, uint256 listingId, address buyer, uint8 v, bytes32 r, bytes32 s) public {
    vm.prank(sender);
    marketplace.buyListing(listingId, buyer, v, r, s);
  }

  function helper_cancelListing(address sender, uint256 listingId) public {
    vm.prank(sender);
    marketplace.cancelListing(listingId);
  }

  function helper_changeSupportedContract(address sender, address contractAddress, bool isSupported) public {
    vm.prank(sender);
    marketplace.changeSupportedContract(contractAddress, isSupported);
  }

  function helper_changeTransactionFee(address sender, uint32 newTransactionFee) public {
    vm.prank(sender);
    marketplace.changeTransactionFee(newTransactionFee);
  }

  function helper_withdrawTransactionFee() public {
    vm.prank(TREASSURY);
    marketplace.withdrawTransactionFee();
  }
}
