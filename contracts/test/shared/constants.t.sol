// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Constants {
  // Constants value specific to the contracts we are testing.
  string constant CONTRACT_NAME = 'SimpleNftMarketplace';
  string constant CONTRACT_VERSION = '0.0.1';

  address constant ADMIN = address(42_000);
  address constant TREASSURY = address(42_001);
  address constant MODERATOR = address(42_002);
  address constant USER = address(42_003);

  uint256 DEFAULT_BLOCKS_COUNT = 10;
  uint256 DEFAULT_MINT_VALUE = 1 ether;
}
