// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import 'foundry-test-utility/contracts/utils/console.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import { Helper } from './shared/helper.t.sol';
import { Errors } from './shared/errors.t.sol';

contract Enzo_test_SimpleNftMarketplace is Helper {
  uint8 LOG_LEVEL = 0;

  function setUp() public {
    initialize_helper(LOG_LEVEL);
  }

  function test_SimpleNftMarketplace_basic_name() public {
    assertEq(marketplace.name(), CONTRACT_NAME);
  }

  function test_SimpleNftMarketplace_basic_version() public {
    assertEq(marketplace.version(), CONTRACT_VERSION);
  }

  function test_SimpleNftMarketplace_basic_changeSupportedContract() public {
    helper_changeSupportedContract(ADMIN, address(nft1), true);
  }

  function test_SimpleNftMarketplace_basic_changeSupportedContract_notAdmin() public {
    helper_changeSupportedContract(address(2), address(nft1), true, RevertStatus.CallerNotAdmin);
  }

  function test_SimpleNftMarketplace_basic_changeToken() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
  }

  function test_SimpleNftMarketplace_basic_createListing() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);
    // Mint token, approve marketplace
    helper_mint_approve721(address(nft1), address(1), 1);
    // Create listing
    helper_createListing(address(1), address(nft1), 1, 100);
    // Verify
    assertEq(marketplace.listingPrice(0), 100);
    assertTrue(marketplace.isListingActive(0), 'isListingActive');
  }
}
