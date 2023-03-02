// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './Controlable.sol';

import '@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol';
// IERC721ReceiverUpgradeable

abstract contract ListingManager is Controlable {
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
  uint256 private _listingId = 0;
  mapping(uint256 => Listing) internal _listings;

  event ListingCreated(uint256 listingId, address tokenContract, uint256 tokenId, uint256 salePrice, address seller);
  event Sale(uint256 listingId, address buyer);

  function _calculateListingFee(uint256 listingId) internal view returns (uint256 amount) {
    uint256 fee = (_listings[listingId].salePrice * uint256(_transactionFee)) / BASE_TRANSACTION_FEE;
    return fee;
  }

  function _createListing(address tokenContract, uint256 tokenId, uint256 salePrice, address seller) internal returns (uint256 listingId) {
    require(salePrice > 0, 'Sell price must be above zero');

    IERC721Upgradeable(tokenContract).safeTransferFrom(seller, address(this), tokenId);

    Listing memory listing = Listing(tokenContract, tokenId, salePrice, seller, address(0), block.timestamp, 0);
    _listings[_listingId] = listing;
    listingId = _listingId;
    _listingId++;

    emit ListingCreated(listingId, tokenContract, tokenId, salePrice, seller);
  }

  function _buyListing(uint256 listingId, address buyer) internal returns (bool success) {
    Listing memory listing = _listings[listingId];
    require(listing.buyTimestamp == 0, 'Listing already sold');

    uint256 listingFee = _calculateListingFee(listingId);
    uint256 amount = listing.salePrice - listingFee;

    _token.transferFrom(buyer, address(this), listing.salePrice);
    _token.transferFrom(address(this), listing.seller, amount);
    IERC721Upgradeable(listing.tokenContract).safeTransferFrom(address(this), buyer, listing.tokenId);

    _listings[listingId].buyer = buyer;
    _listings[listingId].buyTimestamp = block.timestamp;

    _accumulatedTransactionFee += listingFee;

    emit Sale(listingId, buyer);
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
