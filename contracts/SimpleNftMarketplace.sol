// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol';

import './abstracts/ListingManager.sol';
import './abstracts/ValidateSignature.sol';

contract SimpleNftMarketplace is ListingManager, ValidateSignature {
  string public constant NAME = 'SimpleNftMarketplace';
  string public constant VERSION = '0.0.1';

  modifier onlyListingOwnerOrModerator(uint256 listingId) {
    require(msg.sender == _listings[listingId].seller || isModerator(msg.sender), 'SimpleNftMarketplace: Only listing owner or moderator');
    _;
  }

  modifier onlySeller(uint256 listingId) {
    require(msg.sender == _listings[listingId].seller, 'SimpleNftMarketplace: Only seller');
    _;
  }

  function initialize(address treasury) external initializer {
    __ValidateSignature_init(name(), version());
    __ListingManager_init(treasury);
  }

  function name() public pure returns (string memory) {
    return NAME;
  }

  function version() public pure returns (string memory) {
    return VERSION;
  }

  function createListing(address tokenContract, uint256 tokenId, uint256 salePrice) public returns (uint256 listingId) {
    return _createListing(tokenContract, tokenId, salePrice, msg.sender);
  }

  function buyListing(uint256 listingId) external returns (bool success) {
    return _buyListing(listingId, msg.sender);
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
    return _createListing(tokenContract, tokenId, salePrice, seller);
  }

  function buyListing(uint256 listingId, address buyer, uint8 v, bytes32 r, bytes32 s) external returns (bool success) {
    require(_verifyBuyListing(listingId, buyer, v, r, s), 'SimpleNftMarketplace: invalid signature');
    return _buyListing(listingId, buyer);
  }

  // Moderator || Listing creator
  function cancelListing(uint256 listingId) external onlyListingOwnerOrModerator(listingId) returns (bool success) {
    return _cancelListing(listingId);
  }

  function editListingPrice(uint256 listingId, uint256 newPrice) external onlySeller(listingId) returns (bool) {
    return _editListingPrice(listingId, newPrice);
  }

  function changeToken(IERC20Upgradeable contractAddress) external onlyAdmin returns (bool success) {
    return _changeToken(contractAddress);
  }

  // Admin
  function changeSupportedContract(address contractAddress, bool isSupported) external onlyAdmin returns (bool success) {
    return _changeSupportedContract(contractAddress, isSupported);
  }

  function changeTransactionFee(uint32 newTransactionFee) external onlyAdmin returns (bool success) {
    return _changeTransactionFee(newTransactionFee);
  }

  // Treasury
  function withdrawTransactionFee() external onlyTreasury returns (bool success) {
    return _withdrawTransactionFee();
  }

  // Moderator
  function blacklistToken(address tokenContract, uint256 tokenId, bool isBlackListed) external onlyModerator returns (bool success) {
    return _blacklistToken(tokenContract, tokenId, isBlackListed);
  }

  function blacklistUser(address userAddress, bool set) external onlyModerator returns (bool success) {
    return _blacklistUser(userAddress, set);
  }

  // Read operation

  function listingPrice(uint256 listingId) external view returns (uint256 listingPrice) {
    Listing storage listing = _listings[listingId];
    return listing.salePrice;
  }

  function isListingActive(uint256 listingId) external view returns (bool isActive) {
    return _listings[listingId].buyer == address(0) && _listings[listingId].seller != address(0) && _listings[listingId].salePrice != 0;
  }

  function isBlacklistedUser(address userAddress) external view returns (bool isBlacklisted) {
    return _isBlacklistedUser(userAddress);
  }

  function isBlacklistedToken(address tokenContract, uint256 tokenId) external view returns (bool isBlacklisted) {
    return _isBlacklistedToken(tokenContract, tokenId);
  }

  function isSupportedContract(address tokenContract) external view returns (bool isSupported) {
    return _isSupportedContract(tokenContract);
  }

  function calculateListingFee(uint256 listingId) external view returns (uint256 amount) {
    return _calculateListingFee(listingId);
  }
}
