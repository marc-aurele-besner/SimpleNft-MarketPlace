// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './Controlable.sol';

import '@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol';

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
  event Sale();

  function _createListing(address tokenContract, uint256 tokenId, uint256 salePrice, address seller) internal returns (uint256 listingId) {
    require(salePrice > 0, 'Sell price must be above zero');

    IERC721(tokenContract).safeTransferFrom(seller, address(this), tokenId);

    Listing memory listing = Listing(tokenContract, tokenId, salePrice, seller, address(0), block.timestamp, 0);
    _listings[_listingId] = listing;
    _listingId++;

    emit ListingCreated(listingId, tokenContract, tokenId, salePrice, seller);
  }

  function _buyListing(uint256 listingId) internal returns (bool success) {
    // To-Do: Receive token with transferFrom or safeTransferFrom
    // Calculate fees
    // Increment fee counter
    // Calculate rest of amount to send to seller
    // To-Do: Send sale amount minus fees to seller
  }
  function getListingDetail(uint256 listingId) public view returns (Listing memory) {
    return _listings[listingId];
  }
  
}
