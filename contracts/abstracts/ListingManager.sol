// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './Controlable.sol';

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

  event ListingCreated();
  event Sale();

  function _calculateListingFee(uint256 listingId) internal view returns (uint256 amount) {
    uint256 fee = (_listings[listingId].salePrice * transactionFee) / BASE_TRANSACTION_FEE;
    return fee;
  }

  function _createListing(address tokenContract, uint256 tokenId, uint256 salePrice) internal returns (uint256 listingId) {
    // To-Do: Receive nfts with safeTransferFrom

    Listing memory listing = Listing(tokenContract, tokenId, salePrice, msg.sender, address(0), block.timestamp, 0);
    _listings[_listingId] = listing;
    _listingId++;

    emit ListingCreated();
  }

  function _buyListing(uint256 listingId) internal returns (bool success) {
    require(!_listings[listingId].buyTimestamp, 'Listing already sold');

    uint256 listingFee = _calculateListingFee(listingId);
    uint256 amount = _listings[listingId].salePrice - listingFee;

    _token.safeTransferFrom(msg.sender, address(this), _listings[listingId].salePrice);
    _listings[listingId].seller.transfer(amount);
    IERC721(_listings[listingId].tokenContract).safeTransferFrom(address(this), msg.sender, _listings[listingId].tokenId);

    _listings[listingId].buyer = msg.sender;
    _listings[listingId].buyTimestamp = block.timestamp;

    _accumulatedTransactionFee += listingFee;

    emit Sale();
  }
}
