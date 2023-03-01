// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './abstracts/ListingManager.sol';
import './abstracts/ValidateSignature.sol';

contract SimpleNftMarketplace is ListingManager, ValidateSignature {
  string private _name;
  string private _version;

  modifier onlyListingOwnerOrModerator(uint256 listingId) {
    require(msg.sender == _listings[_listingId].seller || isModerator(msg.sender), 'Only listing owner or moderator');
    _;
  }

  function name() external view returns (string memory) {
    return _name;
  }

  function version() external view returns (string memory) {
    return _version;
  }

  function createListing(address tokenContract, uint256 tokenId, uint256 salePrice) external returns (uint256 listingId) {
    _createListing(tokenContract, tokenId, salePrice);
  }

  function buyListing(uint256 listingId) external returns (bool success) {}

  function createListing(
    address tokenContract,
    uint256 tokenId,
    uint256 salePrice,
    address seller,
    uint8 r,
    bytes32 s,
    bytes32 v
  ) external returns (uint256 listingId) {}

  function buyListing(uint256 listingId, uint8 r, bytes32 s, bytes32 v) external returns (bool success) {}

  // Moderator || Listing creator
  function cancelListing(uint256 listingId) external onlyListingOwnerOrModerator(uint256 listingId) returns (bool success) {}

  // Admin
  function changeSupportedContract(address contractAddress, bool isSupported) external onlyAdmin returns (bool success) {}

  function changeTransactionFee(uint32 transactionFee) external onlyAdmin returns (bool success) {}

  // Treasury
  function withdrawTransactionFee() external onlyTreasury returns (bool success) {}

  // Moderator
  function blacklistToken(address tokenContract, uint256 tokenId) external onlyModerator returns (bool success) {}

  function blacklistUser(address userAddress) external onlyModerator returns (bool success) {}

  // Read operation

  function listingPrice(uint256 listingId) external view returns (uint256 listingPrice) {}

  function isListingActive(uint256 listingId) external view returns (bool isActive) {}

  function isBlacklistedUser(address userAddress) external view returns (bool isBlacklisted) {}

  function isBlacklistedToken(address tokenContract, uint256 tokenId) external view returns (bool isBlacklisted) {}

  function isSupportedContract(address tokenContract) external view returns (bool isSupported) {}
}
