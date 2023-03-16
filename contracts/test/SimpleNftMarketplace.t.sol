// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import 'foundry-test-utility/contracts/utils/console.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol';
import { Helper } from './shared/helper.t.sol';
import { Errors } from './shared/errors.t.sol';

contract SimpleNftMarketplace_test is Helper {
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

  function test_SimpleNftMarketplace_basic_createListing_and_buyListing_with_signatures() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_mint_approve721(address(nft1), SIGNER1, 1);

    helper_generateSignatureAndCreateListing(address(1), address(nft1), 1, 100, SIGNER1_PRIVATEKEY);

    help_moveBlockAndTimeFoward(1, 100);

    helper_mint_approve20(SIGNER2, 100);

    helper_generateSignatureAndBuyListing(address(2), 0, SIGNER2_PRIVATEKEY);
  }
}
