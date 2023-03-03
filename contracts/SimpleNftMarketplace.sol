// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol';

import './abstracts/ListingManager.sol';
import './abstracts/ValidateSignature.sol';

contract SimpleNftMarketplace is ListingManager, ValidateSignature {
  string public constant NAME = 'SimpleNft-MarketPlace';
  string public constant VERSION = '0.0.1';

  modifier onlyListingOwnerOrModerator(uint256 listingId) {
    require(msg.sender == _listings[listingId].seller || isModerator(msg.sender), 'Only listing owner or moderator');
    _;
  }

  function initialize() external initializer {
    __ValidateSignature_init(name(), version());
  }

  function name() public pure returns (string memory) {
    return NAME;
  }

  function version() public pure returns (string memory) {
    return VERSION;
  }

  function createListing(address tokenContract, uint256 tokenId, uint256 salePrice) external returns (uint256 listingId) {
    _createListing(tokenContract, tokenId, salePrice, msg.sender);
  }

  function buyListing(uint256 listingId) external returns (bool success) {
    _buyListing(listingId, msg.sender);
  }

  function createListing(
    address tokenContract,
    uint256 tokenId,
    uint256 salePrice,
    address seller,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 listingId) {
    require(_verifyCreateListing(tokenContract, tokenId, salePrice, seller, v, r, s), 'SimpleNftMarketplace: invalid signature');
    return _createListing(tokenContract, tokenId, salePrice, msg.sender);
  }

  function buyListing(uint256 listingId, address buyer, uint8 v, bytes32 r, bytes32 s) external returns (bool success) {
    require(_verifyBuyListing(listingId, buyer, v, r, s), 'SimpleNftMarketplace: invalid signature');
    return _buyListing(listingId, buyer);
  }

  // Moderator || Listing creator
  function cancelListing(uint256 listingId) external onlyListingOwnerOrModerator(listingId) returns (bool success) {
    return false;
  }

  // Admin
  function changeSupportedContract(address contractAddress, bool isSupported) external onlyAdmin returns (bool success) {
    return false;
  }

  function changeTransactionFee(uint32 transactionFee) external onlyAdmin returns (bool success) {
    return false;
  }

  // Treasury
  function withdrawTransactionFee() external onlyTreasury returns (bool success) {
    return false;
  }

  // Moderator
  function blacklistToken(address tokenContract, uint256 tokenId) external onlyModerator returns (bool success) {
    return false;
  }

  function blacklistUser(address userAddress) external onlyModerator returns (bool success) {
    return false;
  }

  // Read operation

  function listingPrice(uint256 listingId) external view returns (uint256 listingPrice) {}

  function isListingActive(uint256 listingId) external view returns (bool isActive) {}

  function isBlacklistedUser(address userAddress) external view returns (bool isBlacklisted) {}

  function isBlacklistedToken(address tokenContract, uint256 tokenId) external view returns (bool isBlacklisted) {}

  function isSupportedContract(address tokenContract) external view returns (bool isSupported) {}

  function calculateListingFee(uint256 listingId) external view returns (uint256 amount) {
    return _calculateListingFee(listingId);
  }
}
