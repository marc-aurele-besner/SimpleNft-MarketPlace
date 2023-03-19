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
    assertTrue(marketplace.isListingActive(0), 'Listing is not active');
  }

  function test_SimpleNftMarketplace_basic_cancelListing() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);
    // Mint token, approve marketplace
    helper_mint_approve721(address(nft1), address(1), 1);
    // Create listing
    helper_createListing(address(1), address(nft1), 1, 100);
    // Verify
    assertEq(marketplace.listingPrice(0), 100);
    assertTrue(marketplace.isListingActive(0), 'Listing is not active');
    // Cancel
    helper_cancelListing(address(1), 0);
    assertEq(marketplace.listingPrice(0), 0);
    assertTrue(!marketplace.isListingActive(0), 'Listing is still active');
  }

  function test_SimpleNftMarketplace_basic_cancelListing_withoutAccess() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);
    // Mint token, approve marketplace
    helper_mint_approve721(address(nft1), address(1), 1);
    // Create listing
    helper_createListing(address(1), address(nft1), 1, 100);
    // Verify
    assertEq(marketplace.listingPrice(0), 100);
    assertTrue(marketplace.isListingActive(0), 'Listing is not active');
    // Cancel without permission
    Errors.verify_revertCall(RevertStatus.CallerNotListingOwnerOrModerator);
    helper_cancelListing(address(2), 0);
    assertEq(marketplace.listingPrice(0), 100);
    assertTrue(marketplace.isListingActive(0), 'Listing is not active');
    // test with ModoAccess
    helper_cancelListing(ADMIN, 0);
    assertTrue(!marketplace.isListingActive(0), 'Listing is still active');
  }

  function test_SimpleNftMarketplace_basic_blacklist() public {
    // Mint 1 token
    helper_mint_approve721(address(nft1), address(1), 1);
    // Blacklist without access
    helper_blacklist_user(address(2), address(1), true, RevertStatus.CallerNotModerator);
    helper_blacklist_token(address(2), address(nft1), 1, true, RevertStatus.CallerNotModerator);
    // Blacklist with access
    helper_blacklist_user(ADMIN, address(1), true);
    helper_blacklist_token(ADMIN, address(nft1), 1, true);
  }

  function test_SimpleNftMarketplace_basic_createListing_with_blacklist() public {
    // Setup
    helper_changeSupportedContract(ADMIN, address(nft1), true);
    helper_changeSupportedContract(ADMIN, address(nft2), true);
    // Mint 2 token
    helper_mint_approve721(address(nft1), address(1), 1);
    helper_mint_approve721(address(nft2), address(2), 1);
    // Blacklist 1 user & 1 token
    helper_blacklist_user(ADMIN, address(1), true);
    helper_blacklist_token(ADMIN, address(nft2), 1, true);
    // Create listing with User blacklisted
    helper_createListing(address(1), address(nft1), 1, 100, RevertStatus.UserBlacklisted);
    // Create listing with Token blacklisted
    helper_createListing(address(2), address(nft2), 1, 100, RevertStatus.TokenBlacklisted);
  }

  function test_SimpleNftMarketplace_basic_createListing_without_token() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_createListing(address(1), address(nft1), 1, 100, RevertStatus.Erc721InvalidTokenId);
  }

  function test_SimpleNftMarketplace_basic_createListing_and_buyListing() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_mint_approve721(address(nft1), address(1), 1);

    helper_createListing(address(1), address(nft1), 1, 100);

    help_moveBlockAndTimeFoward(1, 100);

    helper_mint_approve20(address(2), 100);

    helper_buyListing(address(2), 0);
  }

  function test_SimpleNftMarketplace_basic_createListing_and_buyListing_without_allowance() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_mint_approve721(address(nft1), address(1), 1);

    helper_createListing(address(1), address(nft1), 1, 100);

    help_moveBlockAndTimeFoward(1, 100);

    helper_buyListing(address(2), 0, RevertStatus.Erc20InsufficientAllowance);
  }

  function test_SimpleNftMarketplace_basic_editListingPrice() public {
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_mint_approve721(address(nft1), address(1), 1);

    helper_createListing(address(1), address(nft1), 1, 100);

    help_moveBlockAndTimeFoward(1, 100);

    assertEq(marketplace.listingPrice(0), 100);
    vm.prank(ADMIN);
    Errors.verify_revertCall(RevertStatus.CallerNotSeller);
    marketplace.editListingPrice(0, 50);
    assertEq(marketplace.listingPrice(0), 100);

    vm.prank(address(1));
    assertTrue(marketplace.editListingPrice(0, 50), 'Edit price did not work');
    assertEq(marketplace.listingPrice(0), 50);
  }

  // function test_SimpleNftMarketplace_transactionFee() public {
  //   helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
  //   helper_changeSupportedContract(ADMIN, address(nft1), true);
  //   helper_changeSupportedContract(ADMIN, address(nft2), true);

  //   helper_mint_approve721(address(nft1), address(1), 1);
  //   helper_mint_approve721(address(nft2), address(1), 1);

  //   assertEq(marketplace.transactionFee(), 0);
  // Errors.verify_revertCall(RevertStatus.CallerNotAdmin);
  // assertTrue(marketplace.changeTransactionFee(marketplace.BASE_TRANSACTION_FEE()));

  // vm.prank(ADMIN);
  // assertTrue(marketplace.changeTransactionFee(marketplace.BASE_TRANSACTION_FEE()));
  // assertEq(marketplace.transactionFee(), 100_000);

  // helper_createListing(address(1), address(nft1), 1, 100);
  // assertEq(marketplace.calculateListingFee(0), 1);

  // help_moveBlockAndTimeFoward(1, 100);

  // helper_mint_approve20(address(2), 200);

  // helper_buyListing(address(2), 0);

  // assertEq(marketplace.accumulatedFees(), 1);
  // }
}
