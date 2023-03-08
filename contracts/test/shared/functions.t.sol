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
}
