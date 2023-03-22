// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './Controlable.sol';
import 'hardhat/console.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol';

import '@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol';

abstract contract ListingManager is Controlable, IERC721ReceiverUpgradeable {
  struct Listing {
    address tokenContract;
    uint tokenId;
    uint salePrice;
    address seller;
    address buyer;
    uint listingTimestamp;
    uint buyTimestamp;
  }

  uint32 public constant BASE_TRANSACTION_FEE = 100_000;
  uint256 private _listingId;
  mapping(uint256 => Listing) internal _listings;

  event ListingCreated(uint256 listingId, address tokenContract, uint256 tokenId, uint256 salePrice, address seller);
  event Sale(uint256 listingId, address buyer);

  function __ListingManager_init(address treasury) internal onlyInitializing {
    __Controlable_init(treasury);
  }

  function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
    return this.onERC721Received.selector;
  }

  function _calculateListingFee(uint256 listingId) internal view returns (uint256 amount) {
    uint256 fee = (_listings[listingId].salePrice * uint256(_transactionFee)) / BASE_TRANSACTION_FEE;
    return fee;
  }

  function _createListing(address tokenContract, uint256 tokenId, uint256 salePrice, address seller) internal returns (uint256 listingId) {
    require(!_isBlacklistedUser(seller), 'ListingManager: User is blacklisted');
    require(!_isBlacklistedToken(tokenContract, tokenId), 'ListingManager: Contract token is blacklisted');
    require(_isSupportedContract(tokenContract), 'ListingManager: Contract token is not supported');
    require(salePrice > 0, 'ListingManager: Sell price must be above zero');

    IERC721Upgradeable(tokenContract).safeTransferFrom(seller, address(this), tokenId);

    Listing memory listing = Listing(tokenContract, tokenId, salePrice, seller, address(0), block.timestamp, 0);
    _listings[_listingId] = listing;
    listingId = _listingId;
    _listingId++;

    emit ListingCreated(listingId, tokenContract, tokenId, salePrice, seller);
  }

  function _buyListing(uint256 listingId, address buyer) internal returns (bool success) {
    Listing memory listing = _listings[listingId];
    require(listing.buyTimestamp == 0, 'ListingManager: Listing already sold');
    require(listing.salePrice > 0, 'ListingManager: Sell price must be above zero or listing does not exist');
    require(!_isBlacklistedUser(listing.seller), 'ListingManager: Seller is blacklisted');
    require(!_isBlacklistedUser(buyer), 'ListingManager: Buyer is blacklisted');
    require(_isSupportedContract(listing.tokenContract), 'ListingManager: Contract token is not supported');

    uint256 listingFee = _calculateListingFee(listingId);
    uint256 amount = listing.salePrice - listingFee;

    _token.transferFrom(buyer, address(this), listing.salePrice);
    _token.transfer(listing.seller, amount);
    IERC721Upgradeable(listing.tokenContract).safeTransferFrom(address(this), buyer, listing.tokenId);

    _listings[listingId].buyer = buyer;
    _listings[listingId].buyTimestamp = block.timestamp;

    _accumulatedTransactionFee += listingFee;

    emit Sale(listingId, buyer);
    return true;
  }

  function _editListingPrice(uint256 listingId, uint256 newPrice) internal returns (bool) {
    _listings[listingId].salePrice = newPrice;
    return true;
  }

  function _cancelListing(uint256 listingId) internal returns (bool) {
    Listing memory listing = _listings[listingId];

    _listings[listingId].salePrice = 0;

    IERC721Upgradeable(listing.tokenContract).safeTransferFrom(address(this), listing.seller, listing.tokenId);
    return true;
  }

  function getListingDetail(uint256 listingId) public view returns (Listing memory) {
    return _listings[listingId];
  }

  function isSold(uint256 listingId) public view returns (bool) {
    if (_listings[listingId].buyTimestamp != 0) {
      return true;
    }
    return false;
  }
}
