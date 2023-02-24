// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./abstracts/Controlable.sol";
import "./abstracts/ListingManager.sol";
import "./abstracts/ValidateSignature.sol";

contract SimpleNftMarketplace is Controlable, ListingManager, ValidateSignature {

}
