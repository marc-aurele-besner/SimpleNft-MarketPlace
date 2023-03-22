// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import 'foundry-test-utility/contracts/utils/console.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol';
import { AccessControlUpgradeable } from '@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol';
import { Helper } from './shared/helper.t.sol';
import { Errors } from './shared/errors.t.sol';

contract SimpleNftMarketplace_test_guillaume_test is Helper {
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

  function test_SimpleNftMarketplace_basic_changeToken_notAdmin() public {
    IERC20Upgradeable newToken = IERC20Upgradeable(address(0x123));
    Errors.RevertStatus expectedError = Errors.RevertStatus.CallerNotAdmin;
    helper_changeToken(address(2), newToken, expectedError);
  }

  function test_SimpleNftMarketplace_basic_createListing() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_mint_approve721(address(nft1), address(1), 1);

    helper_createListing(address(1), address(nft1), 1, 100);
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

  // je ne suis pas sûr de cette fonction
  function test_SimpleNftMarketplace_basic_checkValidAddress() public pure {
    // Adresse valide
    address adresseValide = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    assert(adresseValide != address(0));
  }

  function test_SimpleNftMarketplace_basic_blacklistUser() public {
    helper_blacklist_user(MODERATOR, USER, true); // ajouter USER à la liste noire
  }

  function test_SimpleNftMarketplace_basic_blacklistUser_admin() public {
    helper_blacklist_user(ADMIN, address(1), true);
    assertTrue(marketplace.isBlacklistedUser(address(1)));
  }

  function test_SimpleNftMarketplace_basic_blacklistUser_moderator() public {
    helper_blacklist_user(address(2), address(1), true, RevertStatus.CallerNotModerator);
    assertTrue(!marketplace.isBlacklistedUser(address(1)));
  }

  function test_SimpleNftMarketplace_basic_blacklistToken_admin() public {
    helper_blacklist_token(ADMIN, address(1), 0, true);
    assertTrue(marketplace.isBlacklistedToken(address(1), 0));
  }

  function test_SimpleNftMarketplace_basic_blacklistToken_moderator() public {
    helper_blacklist_token(address(2), address(1), 0, true, RevertStatus.CallerNotModerator);
    assertTrue(!marketplace.isBlacklistedToken(address(1), 0));
  }

  function test_SimpleNftMarketplace_basic_changeTransactionFee() public {
    uint32 newTransactionFee = 500;
    helper_changeTransactionFee(ADMIN, newTransactionFee);
    assertEq(marketplace.transactionFee(), newTransactionFee);
  }

  function test_SimpleNftMarketplace_basic_withdrawTransactionFee() public {
    uint256 initialTreasuryBalance = token.balanceOf(TREASSURY);

    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);
    helper_mint_approve721(address(nft1), address(1), 1);
    helper_createListing(address(1), address(nft1), 1, 100);
    help_moveBlockAndTimeFoward(1, 100);
    helper_mint_approve20(address(2), 100);
    helper_buyListing(address(2), 0);

    uint256 feeAmount = marketplace.calculateListingFee(0);

    helper_withdrawTransactionFee();

    // Check that the treasury balance has increased by the fee amount
    assertEq(token.balanceOf(TREASSURY), initialTreasuryBalance + feeAmount);
  }

  function test_SimpleNftMarketplace_basic_editListingPrice() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_mint_approve721(address(nft1), address(1), 1);

    helper_createListing(address(1), address(nft1), 1, 100);

    helper_editListingPrice(address(1), 0, 200, RevertStatus.Success);
  }
}
