// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

abstract contract ListingManager {

    struct Listing {
        address tokenContract;
        uint tokenId;
        uint salePrice;
        address seller;
        address buyer;
        uint listingTimestamp;
        uint buyTimestamp;
    }

    uint256 private _listingId = 0;
    mapping(uint256 => Listing) private _listings;
    
    event ListingCreated();
    event Sale();

    function _createListing(address tokenContract, uint256 tokenId, uint256 salePrice) internal returns (uint256 listingId) {
        Listing memory listing = Listing(
            tokenContract,
            tokenId,
            salePrice,
            msg.sender,
            address(0),
            block.timestamp,
            0
        );
        _listings[_listingId] = listing;
        _listingId++;
        
        emit ListingCreated();
    }

    function _buyListing(uint256 listingId) internal returns (bool success) {

    }

}
