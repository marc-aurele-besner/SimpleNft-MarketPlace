// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol';

abstract contract ValidateSignature is EIP712Upgradeable {
  bytes32 private constant _CREATE_LISTING_TYPEHASH = keccak256('CreateListing(address tokenContract,uint256 tokenId,uint256 salePrice,address seller)');
  bytes32 private constant _BUY_LISTING_TYPEHASH = keccak256('BuyListing(uint256 listingId,address buyer)');

  function __ValidateSignature_init(string memory name, string memory version) internal onlyInitializing {
    __EIP712_init(name, version);
  }

  function _verifyCreateListing(
    address tokenContract,
    uint256 tokenId,
    uint256 salePrice,
    address seller,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) internal view returns (bool success) {
    bytes32 structHash = keccak256(abi.encode(_CREATE_LISTING_TYPEHASH, tokenContract, tokenId, salePrice, seller));

    bytes32 hash = _hashTypedDataV4(structHash);

    address signer = ECDSAUpgradeable.recover(hash, v, r, s);
    require(signer == seller, 'ValidateSignature: invalid signature');

    return true;
  }

  function _verifyBuyListing(uint256 listingId, address buyer, uint8 v, bytes32 r, bytes32 s) internal view returns (bool success) {
    bytes32 structHash = keccak256(abi.encode(_BUY_LISTING_TYPEHASH, listingId, buyer));

    bytes32 hash = _hashTypedDataV4(structHash);

    address signer = ECDSAUpgradeable.recover(hash, v, r, s);
    require(signer == buyer, 'ValidateSignature: invalid signature');

    return true;
  }
}
