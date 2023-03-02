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
  event Sale(uint256 listingId, address buyer);

  function _calculateListingFee(uint256 listingId) internal view returns (uint256 amount) {
    uint256 fee = (_listings[listingId].salePrice * transactionFee) / BASE_TRANSACTION_FEE;
    return fee;
  }

  function _createListing(address tokenContract, uint256 tokenId, uint256 salePrice, address seller) internal returns (uint256 listingId) {
    require(salePrice > 0, 'Sell price must be above zero');

    IERC721(tokenContract).safeTransferFrom(seller, address(this), tokenId);

    Listing memory listing = Listing(tokenContract, tokenId, salePrice, seller, address(0), block.timestamp, 0);
    _listings[_listingId] = listing;
    _listingId++;

    emit ListingCreated(listingId, tokenContract, tokenId, salePrice, seller);
  }

  function _buyListing(uint256 listingId, address buyer) internal returns (bool success) {
    require(!_listings[listingId].buyTimestamp, 'Listing already sold');

    uint256 listingFee = _calculateListingFee(listingId);
    uint256 amount = _listings[listingId].salePrice - listingFee;

    _token.safeTransferFrom(buyer, address(this), _listings[listingId].salePrice);
    _token.safeTransferFrom(address(this), _listings[listingId].seller, amount);
    IERC721(_listings[listingId].tokenContract).safeTransferFrom(address(this), buyer, _listings[listingId].tokenId);

    _listings[listingId].buyer = buyer;
    _listings[listingId].buyTimestamp = block.timestamp;

    _accumulatedTransactionFee += listingFee;

    emit Sale(listingId, buyer);
  }
 
  function getListingDetail(uint256 listingId) public view returns (Listing memory) {
    return _listings[listingId];
  }
  
}
