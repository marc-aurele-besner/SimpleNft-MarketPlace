const { time, loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const Helper = require('./shared');

describe('Test-Benoit', function () {
  before(async function () {
    [provider, owner, user1, user2, user3] = await Helper.setupProviderAndAccount();
  });

  beforeEach(async function () {
    contract = await Helper.setupContract();
  });
  it('does it return the correct listing price (should be)', async function () {
    const mockERC721 = await Helper.deployERC721();
    await Helper.mintERC721(mockERC721, user1.address, 1);
    await Helper.approveERC721(mockERC721, user1, contract.address, 1);
    await contract.changeSupportedContract(mockERC721.address, true);
    expect(await contract.isSupportedContract(mockERC721.address)).to.be.equal(true);
    await contract.connect(user1)['createListing(address,uint256,uint256)'](mockERC721.address, 1, 100);
    expect(await contract.listingPrice(0)).to.be.equal(100);
  });
  it('does it return true if the listing is active (should be)', async function () {
    const mockERC721 = await Helper.deployERC721();

    await Helper.mintERC721(mockERC721, user1.address, 1);
    await Helper.approveERC721(mockERC721, user1, contract.address, 1);
    await contract.changeSupportedContract(mockERC721.address, true);
    await contract.connect(user1)['createListing(address,uint256,uint256)'](mockERC721.address, 1, 100);

    expect(await contract.isListingActive(0)).to.equal(true);

    const detail = await contract.getListingDetail(0);
    const address0 = '0x0000000000000000000000000000000000000000';

    expect(await detail.tokenContract).to.be.equal(mockERC721.address);
    expect(await detail.tokenId).to.be.equal(1);
    expect(await detail.salePrice).to.be.equal(100);
    expect(await detail.seller).to.be.equal(user1.address);
    expect(await detail.buyer).to.be.equal(address0);
  });

  it('does it return true if a user is blacklisted (should be)', async function () {
    expect(await contract.isBlacklistedUser(user1.address)).to.be.equal(false);
    await contract.blacklistUser(user1.address, true);
    expect(await contract.isBlacklistedUser(user1.address)).to.be.equal(true);
  });

  it('does it return true if a user is not blacklisted (should not)', async function () {
    expect(await contract.isBlacklistedUser(user1.address)).to.be.equal(false);
    await contract.blacklistUser(user1.address, false);
    expect(await contract.isBlacklistedUser(user1.address)).to.be.equal(false);
  });

  it('does it return true if a token is blacklisted (should be)', async function () {
    const mockERC721 = await Helper.deployERC721();
    await Helper.mintERC721(mockERC721, user1.address, 1);
    expect(await contract.isBlacklistedToken(mockERC721.address, 1)).to.be.equal(false);
    await contract.blacklistToken(mockERC721.address, 1, true);
    expect(await contract.isBlacklistedToken(mockERC721.address, 1)).to.be.equal(true);
  });

  it('Does user 2 can buy NFT to user 1 (should be)', async function () {
    const mockERC721 = await Helper.deploy_Mint_ApproveERC721(user1, 1);
    await contract.changeSupportedContract(mockERC721.address, true);

    await contract.connect(user1)['createListing(address,uint256,uint256)'](mockERC721.address, 1, 50);

    const token = await Helper.deploy_Mint_ApproveERC20(user2, contract.address, 60);
    await contract.changeToken(token.address);
    expect(await contract.connect(user2).callStatic['buyListing(uint256)'](0)).to.be.equal(true);
    await contract.connect(user2)['buyListing(uint256)'](0);
  });

  it('Does user 2 can buy NFT to user 1 if his balance is insufficient (should not)', async function () {
    const mockERC721 = await Helper.deploy_Mint_ApproveERC721(user1, 1);
    await contract.changeSupportedContract(mockERC721.address, true);

    await contract.connect(user1)['createListing(address,uint256,uint256)'](mockERC721.address, 1, 50);

    const token = await Helper.deploy_Mint_ApproveERC20(user2, contract.address, 40);
    await contract.changeToken(token.address);
    await expect(contract.connect(user2).callStatic['buyListing(uint256)'](0)).to.be.reverted;
  });

  it('does it return true if a contract is supported (should be)', async function () {
    const mockERC721 = await Helper.deployERC721();
    await Helper.mintERC721(mockERC721, user1.address, 1);
    await Helper.approveERC721(mockERC721, user1, contract.address, 1);

    expect(await contract.isSupportedContract(mockERC721.address)).to.be.equal(false);
    await contract.changeSupportedContract(mockERC721.address, true);
    expect(await contract.isSupportedContract(mockERC721.address)).to.be.equal(true);
  });

  it('is admin able to promote user to moderator (should be)', async function () {
    expect(await contract.isModerator(user1.address)).to.be.equal(false);
    await contract.grantRole(await contract.MODERATOR_ROLE(), user1.address);
    expect(await contract.isModerator(user1.address)).to.be.equal(true);
  });

  it('is moderator able to promote user to moderator (should not)', async function () {
    expect(await contract.isModerator(user1.address)).to.be.equal(false);
    await contract.grantRole(await contract.MODERATOR_ROLE(), user1.address);
    expect(await contract.isModerator(user1.address)).to.be.equal(true);

    expect(await contract.isModerator(user2.address)).to.be.equal(false);
    await expect(contract.connect(user1).grantRole(await contract.MODERATOR_ROLE(), user2.address)).to.be.reverted;
  });

  it('is moderator able to promote user to moderator (should not)', async function () {
    expect(await contract.isModerator(user1.address)).to.be.equal(false);
    await contract.grantRole(await contract.MODERATOR_ROLE(), user1.address);
    expect(await contract.isModerator(user1.address)).to.be.equal(true);

    expect(await contract.isModerator(user2.address)).to.be.equal(false);
    await expect(contract.connect(user1).grantRole(await contract.MODERATOR_ROLE(), user2.address)).to.be.reverted;
  });

  it('is Admin able to revokeRole (should be)', async function () {
    await contract.grantRole(await contract.MODERATOR_ROLE(), user1.address);
    expect(await contract.isModerator(user1.address)).to.be.equal(true);

    await contract.removeRole(await contract.MODERATOR_ROLE(), user1.address);
    expect(await contract.isModerator(user1.address)).to.be.equal(false);
  });

  it('is Moderator able to revokeRole (should not)', async function () {
    await contract.grantRole(await contract.MODERATOR_ROLE(), user1.address);
    await contract.grantRole(await contract.MODERATOR_ROLE(), user2.address);
    expect(await contract.isModerator(user1.address)).to.be.equal(true);
    expect(await contract.isModerator(user1.address)).to.be.equal(true);

    await expect(contract.connect(user1).removeRole(await contract.MODERATOR_ROLE(), user2.address)).to.be.reverted;
  });

  it('is Admin able to give Treasury Access (should be)', async function () {
    expect(await contract.isTreasury(user1.address)).to.be.equal(false);
    await contract.grantRole(await contract.TREASURY_ROLE(), user1.address);
    expect(await contract.isTreasury(user1.address)).to.be.equal(true);
  });

  it('is Moderator able to give Treasury Access to other user or to himself(should not)', async function () {
    await contract.grantRole(await contract.MODERATOR_ROLE(), user1.address);
    expect(await contract.isModerator(user1.address)).to.be.equal(true);

    expect(await contract.isTreasury(user2.address)).to.be.equal(false);

    await expect(contract.connect(user1).grantRole(await contract.TREASURY_ROLE(), user2.address)).to.be.reverted;
    await expect(contract.connect(user1).grantRole(await contract.TREASURY_ROLE(), user1.address)).to.be.reverted;
  });

  it('Is Admin able to change transaction fee (should be)', async function () {
    await contract.changeTransactionFee(1);
    expect(await contract.transactionFee()).to.be.equal(1);
    await contract.changeTransactionFee(5);
    expect(await contract.transactionFee()).to.be.equal(5);
  });

  it('Is Moderator or user able to change transaction fee (should not)', async function () {
    await contract.grantRole(await contract.MODERATOR_ROLE(), user1.address);
    expect(await contract.isModerator(user1.address)).to.be.equal(true);
    await expect(contract.connect(user1).changeTransactionFee(15)).to.be.reverted;
    await expect(contract.connect(user2).changeTransactionFee(15)).to.be.reverted;
  });

  it('Is Seller able to editListingPrice (should be). Is User/Moderator/Admin able to editListingPrice (should not)', async function () {
    const mockERC721 = await Helper.deploy_Mint_ApproveERC721(user1, 1);
    await contract.changeSupportedContract(mockERC721.address, true);
    expect(await contract.isSupportedContract(mockERC721.address)).to.be.equal(true);

    await contract.connect(user1)['createListing(address,uint256,uint256)'](mockERC721.address, 1, 50);
    expect(await contract.listingPrice(0)).to.be.equal(50);

    await contract.connect(user1).editListingPrice(0, 100);
    expect(await contract.listingPrice(0)).to.be.equal(100);

    await expect(contract.connect(user2).editListingPrice(0, 100)).to.be.reverted;

    await contract.grantRole(await contract.MODERATOR_ROLE(), user3.address);
    await expect(contract.connect(user3).editListingPrice(0, 100)).to.be.reverted;

    await expect(contract.editListingPrice(0, 100)).to.be.reverted;
  });

  it('Does seller can cancelListing (should be)', async function () {
    const mockERC721 = await Helper.deploy_Mint_ApproveERC721(user1, 1);
    await Helper.changeSupportedContractIsSupported(mockERC721.address);

    await Helper.create_listing(user1, mockERC721.address, 1, 50, 0);

    await contract.connect(user1).cancelListing(0);
    expect(await contract.isListingActive(0)).to.be.equal(false);
  });

  it('does moderator helper works (should be)', async function () {
    await Helper.moderator(user2.address);
    expect(await contract.isModerator(user2.address)).to.be.equal(true);
  });

  it('Does moderator can cancelListing (should be)', async function () {
    const mockERC721 = await Helper.deploy_Mint_ApproveERC721(user1, 1);
    await Helper.changeSupportedContractIsSupported(mockERC721.address);
    await Helper.create_listing(user1, mockERC721.address, 1, 50, 0);

    await Helper.moderator(user2.address);
    expect(await contract.connect(user2).callStatic.cancelListing(0)).to.be.equal(true);
  });

  // it.only('Does moderator can cancelListing (should be)', async function () {
  //   const mockERC721 = await Helper.deploy_Mint_ApproveERC721(user1, 1);
  //   await Helper.changeSupportedContractIsSupported(mockERC721.address);
  //   await Helper.create_listing(user1, mockERC721.address, 1, 50, 0);

  //   await Helper.moderator(user2.address);
  //   console.log(user2.address);

  //   await expect(contract.connect(user2).cancelListing(0)).to.be.equal(true);
  // });
});

// await contract.grantRole(await contract.MODERATOR_ROLE(), user2.address);
// expect(await contract.isModerator(user2.address)).to.be.equal(true);
// await contract.connect(user2).cancelListing(0);
// expect(await contract.isListingActive(0)).to.be.equal(false);

// await contract.grantRole(await contract.MODERATOR_ROLE(), user3.address);
// expect(await contract.isModerator(user3.address)).to.be.equal(true);
// await expect(contract.connect(user2).cancelListing(0)).to.be.reverted;
//
