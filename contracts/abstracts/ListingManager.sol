// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

abstract contract ListingManager {
    
    event Listing();
    event Sale();

    function _createListing(address tokenContract, uint256 tokenId, uint256 salePrice) internal returns (uint256 listingId) {

    }

    function _buyListing(uint256 listingId) internal returns (bool success) {

    }

}
