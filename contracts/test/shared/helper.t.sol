// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'foundry-test-utility/contracts/utils/console.sol';
import { stdCheats as Cheats } from 'foundry-test-utility/contracts/utils/stdlib.sol';

import { Functions } from './functions.t.sol';

contract Helper is Functions, Cheats {
  function initialize_helper(uint8 LOG_LEVEL_) internal {
    // Deploy contracts
    initialize_tests(
      // Test Settings
      LOG_LEVEL_
    );
  }

  function help_changeLogLevel(uint8 newLogLevel_) internal {
    _LOG_LEVEL = newLogLevel_;
  }

  function help_changeDefaultMintValue(uint256 newDefaultMintValue_) internal {
    DEFAULT_MINT_VALUE = newDefaultMintValue_;
  }

  function help_changeDefaultBlocksCount(uint256 newDefaultBlocksCount_) internal {
    DEFAULT_BLOCKS_COUNT = newDefaultBlocksCount_;
  }

  function help_moveBlockFoward(uint256 blockToRoll_) internal {
    vm.roll(block.number + blockToRoll_);
  }

  function help_moveTimeFoward(uint256 secondToWarp_) internal {
    Cheats.skip(secondToWarp_);
  }

  function help_moveBlockAndTimeFoward(uint256 blockToRoll_, uint256 secondToWarp_) internal {
    help_moveBlockFoward(blockToRoll_);
    help_moveTimeFoward(secondToWarp_);
  }
}
