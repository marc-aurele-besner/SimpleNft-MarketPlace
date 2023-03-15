// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'foundry-test-utility/contracts/utils/console.sol';
import { CheatCodes } from 'foundry-test-utility/contracts/utils/cheatcodes.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol';
import { Constants } from './constants.t.sol';
import { Errors } from './errors.t.sol';
import { TestStorage } from './testStorage.t.sol';

import { MockERC20 } from '../../mocks/MockERC20.sol';
import { MockERC721 } from '../../mocks/MockERC721.sol';
import { SimpleNftMarketplace } from '../../SimpleNftMarketplace.sol';

interface IERC721 {
  function mint(address sender, uint256 tokenId) external;

  function approve(address to, uint256 tokenId) external;
}

interface IERC20 {
  function mint(address sender, uint256 amount) external;

  function approve(address to, uint256 amount) external;
}

contract Functions is Constants, Errors, TestStorage {
  SimpleNftMarketplace public marketplace;

  MockERC20 public token;

  MockERC721 public nft1;
  MockERC721 public nft2;
  MockERC721 public nft3;

  enum TestType {
    Standard
  }

  function initialize_tests(uint8 LOG_LEVEL_) public returns (SimpleNftMarketplace) {
    // Set general test settings
    _LOG_LEVEL = LOG_LEVEL_;
    vm.roll(1);
    vm.warp(100);
    vm.startPrank(ADMIN);

    marketplace = new SimpleNftMarketplace();

    token = new MockERC20();
    nft1 = new MockERC721();
    nft2 = new MockERC721();
    nft3 = new MockERC721();

    marketplace.initialize(TREASSURY);

    vm.stopPrank();
    vm.roll(block.number + 1);
    vm.warp(block.timestamp + 100);

    return marketplace;
  }

  event TransactionFeeChanged(uint32 indexed oldFee, uint32 indexed newFee);
  event SupportedContractRemoved(address indexed contractAddress);
  event SupportedContractAdded(address indexed contractAddress);
  event ListingCreated(uint256 listingId, address tokenContract, uint256 tokenId, uint256 salePrice, address seller);
  event Sale(uint256 listingId, address buyer);
  event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

  function helper_createListing(address sender, address tokenContract, uint256 tokenId, uint256 salePrice, RevertStatus revertType_) public {
    verify_revertCall(revertType_);
    vm.prank(sender);
    marketplace.createListing(tokenContract, tokenId, salePrice);

    // Verify
    if (revertType_ == RevertStatus.Success) {
      assertEq(marketplace.listingPrice(0), 100);
      assertTrue(marketplace.isListingActive(0), 'Functions: isListingActive');
    }
  }

  function helper_createListing(address sender, address tokenContract, uint256 tokenId, uint256 salePrice) public {
    helper_createListing(sender, tokenContract, tokenId, salePrice, RevertStatus.Success);
  }

  function helper_buyListing(address sender, uint256 listingId, RevertStatus revertType_) public {
    verify_revertCall(revertType_);
    vm.prank(sender);
    marketplace.buyListing(listingId);
  }

  function helper_buyListing(address sender, uint256 listingId) public {
    helper_buyListing(sender, listingId, RevertStatus.Success);
  }

  function helper_createListing(
    address sender,
    address tokenContract,
    uint256 tokenId,
    uint256 salePrice,
    address seller,
    uint8 v,
    bytes32 r,
    bytes32 s,
    RevertStatus revertType_
  ) public {
    vm.prank(sender);
    marketplace.createListing(tokenContract, tokenId, salePrice, seller, v, r, s);
  }

  function helper_createListing(
    address sender,
    address tokenContract,
    uint256 tokenId,
    uint256 salePrice,
    address seller,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) public {
    helper_createListing(sender, tokenContract, tokenId, salePrice, seller, v, r, s, RevertStatus.Success);
  }

  function helper_buyListing(address sender, uint256 listingId, address buyer, uint8 v, bytes32 r, bytes32 s, RevertStatus revertType_) public {
    verify_revertCall(revertType_);
    vm.prank(sender);
    marketplace.buyListing(listingId, buyer, v, r, s);
  }

  function helper_buyListing(address sender, uint256 listingId, address buyer, uint8 v, bytes32 r, bytes32 s) public {
    vm.prank(sender);
    marketplace.buyListing(listingId, buyer, v, r, s);
  }

  function helper_cancelListing(address sender, uint256 listingId) public {
    vm.prank(sender);
    marketplace.cancelListing(listingId);
  }

  function helper_changeToken(address sender, IERC20Upgradeable contractAddress, RevertStatus revertType) public {
    if (revertType == RevertStatus.Success) assertEq(marketplace.token(), address(0));

    verify_revertCall(revertType);
    vm.prank(sender);
    marketplace.changeToken(contractAddress);

    if (revertType == RevertStatus.Success) assertEq(marketplace.token(), address(token));
  }

  function helper_changeToken(address sender, IERC20Upgradeable contractAddress) public {
    helper_changeToken(sender, contractAddress, RevertStatus.Success);
  }

  function helper_changeSupportedContract(address sender, address contractAddress, bool isSupported, RevertStatus revertType) public {
    if (revertType == RevertStatus.Success) assertTrue(!marketplace.isSupportedContract(contractAddress));

    verify_revertCall(revertType);
    vm.prank(sender);
    marketplace.changeSupportedContract(contractAddress, isSupported);

    if (revertType == RevertStatus.Success) assertTrue(marketplace.isSupportedContract(contractAddress));
  }

  function helper_changeSupportedContract(address sender, address contractAddress, bool isSupported) public {
    helper_changeSupportedContract(sender, contractAddress, isSupported, RevertStatus.Success);
  }

  function helper_changeTransactionFee(address sender, uint32 newTransactionFee) public {
    vm.prank(sender);
    marketplace.changeTransactionFee(newTransactionFee);
  }

  function helper_withdrawTransactionFee() public {
    vm.prank(TREASSURY);
    marketplace.withdrawTransactionFee();
  }

  function helper_mint_approve721(address nft, address sender, uint256 tokenId) public {
    IERC721(nft).mint(sender, tokenId);
    vm.prank(sender);
    IERC721(nft).approve(address(marketplace), tokenId);
  }

  function helper_mint_approve20(address sender, uint256 amount) public {
    token.mint(sender, amount);
    vm.prank(sender);
    token.approve(address(marketplace), amount);
  }

  function helper_blacklistUser(address sender, address userAddress, bool set) public {
    vm.prank(sender);
    marketplace.blacklistUser(userAddress, set);
  }

  function helper_blacklistToken(address sender, address tokenContract, uint256 tokenId, bool isBlackListed) public {
    vm.prank(sender);
    marketplace.blacklistToken(tokenContract, tokenId, isBlackListed);
  }
}
