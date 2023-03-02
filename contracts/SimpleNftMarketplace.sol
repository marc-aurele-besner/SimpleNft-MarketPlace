// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";

import './abstracts/ListingManager.sol';
import './abstracts/ValidateSignature.sol';

contract SimpleNftMarketplace is ListingManager, ValidateSignature {
  string public constant NAME = "SimpleNft-MarketPlace";
  string public constant VERSION = "0.0.1";

  modifier onlyListingOwnerOrModerator(uint256 listingId) {
    require(msg.sender == _listings[_listingId].seller || isModerator(msg.sender), 'Only listing owner or moderator');
    _;
  }

  bytes32 private constant _CREATE_LISTING_TYPEHASH =
    keccak256("CreateListing(address tokenContract,uint256 tokenId,uint256 salePrice,address seller)");
  bytes32 private constant _BUY_LISTING_TYPEHASH =
    keccak256("BuyListing(uint256 listingId,address buyer)");

  function initialize() external initializer {
    __ValidateSignature_init(name(), version());
  }

  function name() external view returns (string memory) {
    return NAME;
  }

  function version() external view returns (string memory) {
    return VERSION;
  }

  function createListing(address tokenContract, uint256 tokenId, uint256 salePrice) external returns (uint256 listingId) {
    _createListing(tokenContract, tokenId, salePrice, msg.sender);
  }

  function buyListing(uint256 listingId) external returns (bool success) {
    _buyListing(listingId);
  }

  function createListing(
    address tokenContract,
    uint256 tokenId,
    uint256 salePrice,
    address seller,
    uint8 r,
    bytes32 s,
    bytes32 v
  ) external returns (uint256 listingId) {
    bytes32 structHash = keccak256(abi.encode(_CREATE_LISTING_TYPEHASH, tokenContract, tokenId, salePrice, seller));

    bytes32 hash = _hashTypedDataV4(structHash);

    address signer = ECDSAUpgradeable.recover(hash, v, r, s);
    // require(signer == seller, "SimpleNftMarketplace: invalid signature");

    _createListing(tokenContract, tokenId, salePrice, msg.sender);
  }

  function buyListing(uint256 listingId, address buyer, uint8 r, bytes32 s, bytes32 v) external returns (bool success) {

    bytes32 structHash = keccak256(abi.encode(_BUY_LISTING_TYPEHASH, listingId, buyer));

    bytes32 hash = _hashTypedDataV4(structHash);

    // address signer = ECDSAUpgradeable.recover(hash, v, r, s);
    // require(signer == buyer, "SimpleNftMarketplace: invalid signature");
    
    _buyListing(listingId, buyer);
  }

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

  function calculateListingFee(uint256 listingId) external view returns (uint256 amount) {
    return _calculateListingFee(listingId);
  }
}
