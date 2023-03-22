// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'foundry-test-utility/contracts/utils/console.sol';
import { CheatCodes } from 'foundry-test-utility/contracts/utils/cheatcodes.sol';
import { Signatures } from 'foundry-test-utility/contracts/shared/signatures.sol';
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

  function balanceOf(address owner) external view returns (uint256 balance);

  function ownerOf(uint256 tokenId) external view returns (address owner);
}

interface IERC20 {
  function mint(address sender, uint256 amount) external;

  function approve(address to, uint256 amount) external;
}

contract Functions is Constants, Errors, TestStorage, Signatures {
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

    marketplace.giveModeratorAccess(MODERATOR);

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

  function verify_buyListing(
    uint256 listingId,
    address buyer,
    address seller,
    uint256 startBuyerBalance,
    uint256 startSellerBalance,
    uint256 startMarketplaceBalance
  ) public {
    uint256 endBuyerBalance = token.balanceOf(buyer);
    uint256 endSellerBalance = token.balanceOf(seller);
    uint256 endMarketplaceBalance = token.balanceOf(address(marketplace));
    uint256 listingPrice = marketplace.listingPrice(listingId);

    assertTrue(marketplace.isSold(listingId), 'Listing is not sold');
    assertTrue(!marketplace.isListingActive(listingId), 'Listing is active');
    assertEq(endBuyerBalance, startBuyerBalance - listingPrice, 'Buyer balance is incorrect');

    uint256 transactionFee = marketplace.transactionFee();
    uint256 fee = (listingPrice * transactionFee) / marketplace.BASE_TRANSACTION_FEE();

    assertEq(endSellerBalance, startSellerBalance + (listingPrice - fee), 'Seller balance is incorrect');
    assertEq(endMarketplaceBalance, startMarketplaceBalance + fee, 'Marketplace balance is incorrect');
  }

  function verify_createListing(
    uint256 listingId,
    address seller,
    address tokenContract,
    uint256 tokenId,
    uint256 salePrice,
    uint256 startSellerBalance,
    uint256 startMarketplaceBalance
  ) public {
    uint256 endSellerBalance = IERC721(tokenContract).balanceOf(seller);
    uint256 endMarketplaceBalance = IERC721(tokenContract).balanceOf(address(marketplace));

    assertTrue(marketplace.isListingActive(listingId), 'Listing is not active');
    assertEq(marketplace.listingPrice(listingId), salePrice);
    assertEq(IERC721(tokenContract).ownerOf(tokenId), address(marketplace));
    assertEq(IERC721(tokenContract).balanceOf(address(marketplace)), startMarketplaceBalance + 1);
    assertEq(IERC721(tokenContract).balanceOf(seller), startSellerBalance - 1);
  }

  function verify_cancelListing(uint256 listingId, uint256 startSellerBalance, uint256 startMarketplaceBalance) public {
    SimpleNftMarketplace.Listing memory listingDetail = marketplace.getListingDetail(listingId);

    uint256 endSellerBalance = IERC721(listingDetail.tokenContract).balanceOf(listingDetail.seller);
    uint256 endMarketplaceBalance = IERC721(listingDetail.tokenContract).balanceOf(address(marketplace));

    assertTrue(!marketplace.isListingActive(listingId), 'Listing should be inactive');
    assertEq(marketplace.listingPrice(listingId), 0, 'Listing price should be 0');
    assertEq(IERC721(listingDetail.tokenContract).ownerOf(listingDetail.tokenId), listingDetail.seller);
    assertEq(IERC721(listingDetail.tokenContract).balanceOf(address(marketplace)), startMarketplaceBalance - 1);
    assertEq(IERC721(listingDetail.tokenContract).balanceOf(listingDetail.seller), startSellerBalance + 1);
  }

  function helper_createListing(address seller, address tokenContract, uint256 tokenId, uint256 salePrice, RevertStatus revertType_) public {
    uint256 startSellerBalance = IERC721(tokenContract).balanceOf(seller);
    uint256 startMarketplaceBalance = IERC721(tokenContract).balanceOf(address(marketplace));

    verify_revertCall(revertType_);
    vm.prank(seller);
    uint256 listingId = marketplace.createListing(tokenContract, tokenId, salePrice);

    // Verify
    if (revertType_ == RevertStatus.Success) {
      verify_createListing(listingId, seller, tokenContract, tokenId, salePrice, startSellerBalance, startMarketplaceBalance);
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

  function helper_generateSignature(
    address sender,
    address nftContract,
    uint256 tokenId,
    uint256 salePrice,
    uint256 sellerPk
  ) public returns (address seller, uint8 v, bytes32 r, bytes32 s) {
    seller = vm.addr(sellerPk);
    bytes32 domainSeparator = keccak256(
      abi.encode(
        keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
        keccak256(bytes(CONTRACT_NAME)),
        keccak256(bytes(CONTRACT_VERSION)),
        block.chainid,
        address(marketplace)
      )
    );
    bytes32 structHash = keccak256(
      abi.encode(
        keccak256('CreateListing(address tokenContract,uint256 tokenId,uint256 salePrice,address seller)'),
        address(nftContract),
        tokenId,
        salePrice,
        seller
      )
    );

    (v, r, s) = signature_signHash(sellerPk, SignatureType.eip712, domainSeparator, structHash);
  }

  function helper_generateSignatureAndCreateListing(
    address sender,
    address nftContract,
    uint256 tokenId,
    uint256 salePrice,
    uint256 sellerPk,
    RevertStatus revertType_
  ) public {
    (address seller, uint8 v, bytes32 r, bytes32 s) = helper_generateSignature(sender, nftContract, tokenId, salePrice, sellerPk);

    helper_createListing(sender, address(nftContract), tokenId, salePrice, seller, v, r, s, revertType_);
  }

  function helper_generateSignatureAndCreateListing(address sender, address nftContract, uint256 tokenId, uint256 salePrice, uint256 sellerPk) public {
    helper_generateSignatureAndCreateListing(sender, nftContract, tokenId, salePrice, sellerPk, RevertStatus.Success);
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
    uint256 startSellerBalance = IERC721(tokenContract).balanceOf(seller);
    uint256 startMarketplaceBalance = IERC721(tokenContract).balanceOf(address(marketplace));

    verify_revertCall(revertType_);
    vm.prank(sender);
    uint256 listingId = marketplace.createListing(tokenContract, tokenId, salePrice, seller, v, r, s);

    // Verify
    if (revertType_ == RevertStatus.Success) {
      verify_createListing(listingId, seller, tokenContract, tokenId, salePrice, startSellerBalance, startMarketplaceBalance);
    }
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

  function helper_generateSignatureAndBuyListing(address sender, uint256 listingId, uint256 buyerPk, RevertStatus revertType_) public {
    address buyer = vm.addr(buyerPk);
    bytes32 domainSeparator = keccak256(
      abi.encode(
        keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
        keccak256(bytes(CONTRACT_NAME)),
        keccak256(bytes(CONTRACT_VERSION)),
        block.chainid,
        address(marketplace)
      )
    );
    bytes32 structHash = keccak256(abi.encode(keccak256('BuyListing(uint256 listingId,address buyer)'), listingId, buyer));

    (uint8 v, bytes32 r, bytes32 s) = signature_signHash(buyerPk, SignatureType.eip712, domainSeparator, structHash);

    helper_buyListing(sender, listingId, buyer, v, r, s, revertType_);
  }

  function helper_generateSignatureAndBuyListing(address sender, uint256 listingId, uint256 buyerPk) public {
    helper_generateSignatureAndBuyListing(sender, listingId, buyerPk, RevertStatus.Success);
  }

  function helper_buyListing(address sender, uint256 listingId, address buyer, uint8 v, bytes32 r, bytes32 s, RevertStatus revertType_) public {
    uint256 startBuyerBalance = token.balanceOf(buyer);
    uint256 startMarketplaceBalance = token.balanceOf(address(marketplace));

    SimpleNftMarketplace.Listing memory listingDetail = marketplace.getListingDetail(listingId);

    uint256 startSellerBalance = token.balanceOf(listingDetail.seller);

    if (revertType_ == RevertStatus.OverUnderflow) vm.expectRevert(abi.encodeWithSignature('Panic(uint256)', 0x11));
    else verify_revertCall(revertType_);
    vm.prank(sender);
    marketplace.buyListing(listingId, buyer, v, r, s);

    if (revertType_ == RevertStatus.Success) {
      verify_buyListing(listingId, buyer, listingDetail.seller, startBuyerBalance, startSellerBalance, startMarketplaceBalance);
    }
  }

  function helper_buyListing(address sender, uint256 listingId, address buyer, uint8 v, bytes32 r, bytes32 s) public {
    helper_buyListing(sender, listingId, buyer, v, r, s, RevertStatus.Success);
  }

  function helper_cancelListing(address sender, uint256 listingId, RevertStatus revertType_) public {
    SimpleNftMarketplace.Listing memory listingDetail = marketplace.getListingDetail(listingId);

    uint256 startSellerBalance = IERC721(listingDetail.tokenContract).balanceOf(listingDetail.seller);
    uint256 startMarketplaceBalance = IERC721(listingDetail.tokenContract).balanceOf(address(marketplace));

    verify_revertCall(revertType_);
    vm.prank(sender);
    marketplace.cancelListing(listingId);

    if (revertType_ == RevertStatus.Success) {
      verify_cancelListing(listingId, startSellerBalance, startMarketplaceBalance);
    }
  }

  function helper_cancelListing(address sender, uint256 listingId) public {
    helper_cancelListing(sender, listingId, RevertStatus.Success);
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

  function helper_blacklist_user(address sender, address userAddress, bool set, RevertStatus revertType) public {
    if (revertType == RevertStatus.Success) assertTrue(!marketplace.isBlacklistedUser(userAddress));

    verify_revertCall(revertType);
    vm.prank(sender);
    marketplace.blacklistUser(userAddress, set);

    if (revertType == RevertStatus.Success) assertTrue(marketplace.isBlacklistedUser(userAddress));
  }

  function helper_blacklist_user(address sender, address userAddress, bool set) public {
    helper_blacklist_user(sender, userAddress, set, RevertStatus.Success);
  }

  function helper_blacklist_token(address sender, address contractAddress, uint256 tokenId, bool set, RevertStatus revertType) public {
    if (revertType == RevertStatus.Success) assertTrue(!marketplace.isBlacklistedToken(contractAddress, tokenId));

    verify_revertCall(revertType);
    vm.prank(sender);
    marketplace.blacklistToken(contractAddress, tokenId, set);

    if (revertType == RevertStatus.Success) assertTrue(marketplace.isBlacklistedToken(contractAddress, tokenId));
  }

  function helper_blacklist_token(address sender, address contractAddress, uint256 tokenId, bool set) public {
    helper_blacklist_token(sender, contractAddress, tokenId, set, RevertStatus.Success);
  }

  function helper_editListingPrice(address sender, uint256 listingId, uint256 newPrice, RevertStatus revertType) public {
    verify_revertCall(revertType);
    vm.prank(sender);
    marketplace.editListingPrice(listingId, newPrice);

    if (revertType == RevertStatus.Success) {
      assertEq(marketplace.listingPrice(listingId), newPrice, 'Listing price not updated');
    }
  }
}
