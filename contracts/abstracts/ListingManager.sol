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

    uint private listingId = 0;
    mapping(uint => Listing) private _listings;
    
    event Listing();
    event Sale();

    function _createListing(address tokenContract, uint256 tokenId, uint256 salePrice) internal returns (uint256 listingId) {
        Listing memory listing = Listing(
            tokenContract,
            tokenId,
            salePrice
        );

        listingId++;
        _listings[listingsId] = listing;
        
        emit Listing();
    }

    function _buyListing(uint256 listingId) internal returns (bool success) {

    }

}
