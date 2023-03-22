// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Vm } from 'foundry-test-utility/contracts/utils/vm.sol';
import { DSTest } from 'foundry-test-utility/contracts/utils/test.sol';

contract Errors is DSTest {
  Vm public constant vm = Vm(address(uint160(uint256(keccak256('hevm cheat code')))));

  mapping(RevertStatus => string) private _errors;

  // Add a revert error to the enum of errors.
  enum RevertStatus {
    Success,
    SkipValidation,
    InvalidSignature,
    CallerNotListingOwnerOrModerator,
    ListingNotActive,
    CallerNotSeller,
    CallerNotAdmin,
    CallerNotModerator,
    CallerNotTreasury,
    TransferFailed,
    ContractTokenNotSupported,
    ListingSold,
    SellPriceAboveZero,
    SellPriceAboveZeroOrInvalidListing,
    TokenBlacklisted,
    UserBlacklisted,
    SellerBlacklisted,
    BuyerBlacklisted,
    OnlyRenounceRolesForSelf,
    ContractIsNotInitializing,
    ContractIsInitializing,
    ContractAlreasyInitialized,
    Erc721InvalidTokenId,
    Erc20InsufficientAllowance,
    OverUnderflow
  }

  // Associate your error with a revert message and add it to the mapping.
  constructor() {
    _errors[RevertStatus.InvalidSignature] = 'SimpleNftMarketplace: invalid signature';
    _errors[RevertStatus.CallerNotListingOwnerOrModerator] = 'SimpleNftMarketplace: Only listing owner or moderator';
    _errors[RevertStatus.CallerNotSeller] = 'SimpleNftMarketplace: Only seller';
    _errors[RevertStatus.ListingNotActive] = 'SimpleNftMarketplace: Listing is not active';
    _errors[RevertStatus.CallerNotAdmin] = 'Controlable: Only admin';
    _errors[RevertStatus.CallerNotModerator] = 'Controlable: Only moderator';
    _errors[RevertStatus.CallerNotTreasury] = 'Controlable: Only treasury';
    _errors[RevertStatus.TransferFailed] = 'Controlable: Transfer failed';
    _errors[RevertStatus.ContractTokenNotSupported] = 'ListingManager: Contract token is not supported';
    _errors[RevertStatus.ListingSold] = 'ListingManager: Listing already sold';
    _errors[RevertStatus.SellPriceAboveZero] = 'ListingManager: Sell price must be above zero';
    _errors[RevertStatus.SellPriceAboveZeroOrInvalidListing] = 'ListingManager: Sell price must be above zero or listing does not exist';
    _errors[RevertStatus.TokenBlacklisted] = 'ListingManager: Contract token is blacklisted';
    _errors[RevertStatus.UserBlacklisted] = 'ListingManager: User is blacklisted';
    _errors[RevertStatus.SellerBlacklisted] = 'ListingManager: Seller is blacklisted';
    _errors[RevertStatus.BuyerBlacklisted] = 'ListingManager: Buyer is blacklisted';
    _errors[RevertStatus.OnlyRenounceRolesForSelf] = 'AccessControl: can only renounce roles for self';
    _errors[RevertStatus.ContractIsNotInitializing] = 'Initializable: contract is not initializing';
    _errors[RevertStatus.ContractIsInitializing] = 'Initializable: contract is initializing';
    _errors[RevertStatus.ContractAlreasyInitialized] = 'Initializable: contract is already initialized';
    _errors[RevertStatus.InvalidSignature] = 'ValidateSignature: invalid signature';
    _errors[RevertStatus.Erc721InvalidTokenId] = 'ERC721: invalid token ID';
    _errors[RevertStatus.Erc20InsufficientAllowance] = 'ERC20: insufficient allowance';
  }

  // Return the error message associated with the error.
  function _verify_revertCall(RevertStatus revertType_) internal view returns (string storage) {
    return _errors[revertType_];
  }

  // Expect a revert error if the revert type is not success.
  function verify_revertCall(RevertStatus revertType_) public {
    if (revertType_ != RevertStatus.Success && revertType_ != RevertStatus.SkipValidation) vm.expectRevert(bytes(_verify_revertCall(revertType_)));
  }
}
