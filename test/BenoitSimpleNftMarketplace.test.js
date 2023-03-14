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

  //#37 read function tests

  // it('does it return true if a token is blacklisted (should be)', async () => {});

  // it('does it return true if a contract is supported (should be)', async () => {});

  // // buy / sell
  // it('Does user can buy NFT (trade eth for token)(should be)', async function () {});
  // it('Does user can sell NFT (trade eth for token)(should be)', async function () {});
  // // WithDrawEth/ Send
});
