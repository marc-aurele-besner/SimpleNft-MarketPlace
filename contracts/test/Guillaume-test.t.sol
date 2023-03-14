// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import 'foundry-test-utility/contracts/utils/console.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol';
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
    helper_changeSupportedContract(address(2), address(nft1), true, RevertStatus.OnlyAdmin);
  }

  function test_SimpleNftMarketplace_basic_changeToken() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
  }

  function test_SimpleNftMarketplace_basic_changeToken_notAdmin() public {
    IERC20Upgradeable newToken = IERC20Upgradeable(address(0x123));
    Errors.RevertStatus expectedError = Errors.RevertStatus.OnlyAdmin;
    helper_changeToken(address(2), newToken, expectedError);
  }

  function test_SimpleNftMarketplace_basic_createListing() public {
    helper_changeToken(ADMIN, IERC20Upgradeable(address(token)));
    helper_changeSupportedContract(ADMIN, address(nft1), true);
  }

}
