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

  function test_SimpleNftMarketplace_basic_createListing_and_buyListing_with_signatures_and_transactionFee() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);
    helper_changeTransactionFee(ADMIN, 5_000); // 5%

    helper_mint_approve721(address(nft1), SIGNER1, 1);

    helper_generateSignatureAndCreateListing(address(1), address(nft1), 1, 100, SIGNER1_PRIVATEKEY);

    help_moveBlockAndTimeFoward(1, 100);

    helper_mint_approve20(SIGNER2, 100);

    helper_generateSignatureAndBuyListing(address(2), 0, SIGNER2_PRIVATEKEY);
  }

  function test_SimpleNftMarketplace_basic_createListing_and_buyListing_with_signatures_and_transactionFee_afterCreateListing() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_mint_approve721(address(nft1), SIGNER1, 1);

    helper_generateSignatureAndCreateListing(address(1), address(nft1), 1, 100, SIGNER1_PRIVATEKEY);

    help_moveBlockAndTimeFoward(1, 100);
    helper_changeTransactionFee(ADMIN, 5_000); // 5%

    helper_mint_approve20(SIGNER2, 100);

    helper_generateSignatureAndBuyListing(address(2), 0, SIGNER2_PRIVATEKEY);
  }

  function test_SimpleNftMarketplace_basic_createListing_and_buyListing_with_signatures_and_transactionFee_5xSameBlock() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);
    helper_changeTransactionFee(ADMIN, 5_000); // 5%

    helper_mint_approve721(address(nft1), SIGNER1, 1);
    helper_mint_approve721(address(nft1), SIGNER2, 2);
    helper_mint_approve721(address(nft1), SIGNER4, 3);
    helper_mint_approve721(address(nft1), SIGNER5, 4);
    helper_mint_approve721(address(nft1), SIGNER3, 5);

    helper_generateSignatureAndCreateListing(address(1), address(nft1), 1, 100, SIGNER1_PRIVATEKEY);
    helper_generateSignatureAndCreateListing(address(2), address(nft1), 2, 200, SIGNER2_PRIVATEKEY);
    helper_generateSignatureAndCreateListing(address(3), address(nft1), 3, 300, SIGNER4_PRIVATEKEY);
    helper_generateSignatureAndCreateListing(address(4), address(nft1), 4, 400, SIGNER5_PRIVATEKEY);
    helper_generateSignatureAndCreateListing(address(5), address(nft1), 5, 500, SIGNER3_PRIVATEKEY);

    help_moveBlockAndTimeFoward(1, 100);

    helper_mint_approve20(SIGNER5, 100);
    helper_mint_approve20(SIGNER4, 200);
    helper_mint_approve20(SIGNER3, 300);
    helper_mint_approve20(SIGNER2, 400);
    helper_mint_approve20(SIGNER1, 500);

    helper_generateSignatureAndBuyListing(address(11), 0, SIGNER5_PRIVATEKEY);
    helper_generateSignatureAndBuyListing(address(12), 1, SIGNER4_PRIVATEKEY);
    helper_generateSignatureAndBuyListing(address(13), 2, SIGNER3_PRIVATEKEY);
    helper_generateSignatureAndBuyListing(address(14), 3, SIGNER2_PRIVATEKEY);
    helper_generateSignatureAndBuyListing(address(15), 4, SIGNER1_PRIVATEKEY);
  }

  function test_SimpleNftMarketplace_basic_createListing_and_buyListing_with_signatures_and_transactionFee_() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);
    helper_changeTransactionFee(ADMIN, 150_000); // 5%

    helper_mint_approve721(address(nft1), SIGNER1, 1);

    helper_generateSignatureAndCreateListing(address(1), address(nft1), 1, 200, SIGNER1_PRIVATEKEY);

    help_moveBlockAndTimeFoward(1, 100);

    helper_mint_approve20(SIGNER2, 200);

    helper_generateSignatureAndBuyListing(address(2), 0, SIGNER2_PRIVATEKEY, RevertStatus.OverUnderflow);
  }

  function test_SimpleNftMarketplace_basic_createListing_and_buyListing_with_signatures_with_lowerPriceThanSignature() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_mint_approve721(address(nft1), SIGNER1, 1);

    (address seller, uint8 v, bytes32 r, bytes32 s) = helper_generateSignature(address(1), address(nft1), 1, 100, SIGNER1_PRIVATEKEY);

    helper_createListing(address(1), address(nft1), 1, 50, seller, v, r, s, RevertStatus.InvalidSignature);

    help_moveBlockAndTimeFoward(1, 100);

    helper_mint_approve20(SIGNER2, 100);

    helper_generateSignatureAndBuyListing(address(2), 0, SIGNER2_PRIVATEKEY, RevertStatus.SellPriceAboveZeroOrInvalidListing);
  }

  function test_SimpleNftMarketplace_basic_createListing_and_cancelListing() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_mint_approve721(address(nft1), address(1), 1);

    helper_createListing(address(1), address(nft1), 1, 100);

    help_moveBlockAndTimeFoward(1, 100);

    helper_cancelListing(address(1), 0);
  }

  function test_SimpleNftMarketplace_basic_createListing_and_cancelListing_with_signatures() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_mint_approve721(address(nft1), SIGNER1, 1);

    helper_generateSignatureAndCreateListing(address(1), address(nft1), 1, 100, SIGNER1_PRIVATEKEY);

    help_moveBlockAndTimeFoward(1, 100);

    helper_cancelListing(SIGNER1, 0);
  }

  function test_SimpleNftMarketplace_basic_createListing_and_cancelListing_frrom_non_owner() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_mint_approve721(address(nft1), address(1), 1);

    helper_createListing(address(1), address(nft1), 1, 100);

    help_moveBlockAndTimeFoward(1, 100);

    helper_cancelListing(address(6), 0, RevertStatus.CallerNotListingOwnerOrModerator);
  }

  function test_SimpleNftMarketplace_basic_createListing_and_cancelListing_with_signatures_frrom_non_owner() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_mint_approve721(address(nft1), SIGNER1, 1);

    helper_generateSignatureAndCreateListing(address(1), address(nft1), 1, 100, SIGNER1_PRIVATEKEY);

    help_moveBlockAndTimeFoward(1, 100);

    helper_cancelListing(address(8), 0, RevertStatus.CallerNotListingOwnerOrModerator);
  }

  function test_fuzzCreateListing(uint256 salePrice) public {
    vm.assume(salePrice > 0 && salePrice < 100_000_000_000_000_000_000);

    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);

    helper_mint_approve721(address(nft1), SIGNER1, 1);

    helper_generateSignatureAndCreateListing(address(1), address(nft1), 1, salePrice, SIGNER1_PRIVATEKEY);

    help_moveBlockAndTimeFoward(1, salePrice);
    helper_changeTransactionFee(ADMIN, 5_000); // 5%

    helper_mint_approve20(SIGNER2, salePrice);

    helper_generateSignatureAndBuyListing(address(2), 0, SIGNER2_PRIVATEKEY);
  }
}
