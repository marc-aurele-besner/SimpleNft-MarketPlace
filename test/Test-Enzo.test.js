const { time, loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const Helper = require('./shared');

describe('Test-Enzo', function () {
  before(async function () {
    [provider, owner, user1, user2, user3] = await Helper.setupProviderAndAccount();
  });

  beforeEach(async function () {
    contract = await Helper.setupContract();
  });

  it('Does the blacklistUser function work without moderator access ? (should not be)', async function () {
    await expect(contract.connect(user1).blacklistUser(user2.address, true)).to.be.revertedWith(Helper.errors.CALLER_NOT_MODERATOR);
  });

  it('Does the blacklistToken function work without moderator access ? (should not be)', async function () {
    await Helper.deployERC721();
    await Helper.mintERC721(user1.address, 1);

    await expect(contract.connect(user1).blacklistToken(mockERC721.address, 0, true)).to.be.revertedWith(Helper.errors.CALLER_NOT_MODERATOR);
  });

  it('Does the blacklistUser function work with moderator access (blacklist and unBlacklist) ? (should be)', async function () {
    await contract.blacklistUser(user1.address, true);
    expect(await contract.isBlacklistedUser(user1.address)).to.be.equal(true);

    await contract.blacklistUser(user1.address, false);
    expect(await contract.isBlacklistedUser(user1.address)).to.be.equal(false);
  });

  it('Does the blacklistToken function work with moderator access (blacklist and unBlacklist) ? (should be)', async function () {
    await Helper.deployERC721();
    await Helper.mintERC721(user1.address, 1);

    await contract.blacklistToken(mockERC721.address, 0, true);
    expect(await contract.isBlacklistedToken(mockERC721.address, 0)).to.be.equal(true);

    await contract.blacklistToken(mockERC721.address, 0, false);
    expect(await contract.isBlacklistedToken(mockERC721.address, 0)).to.be.equal(false);
  });

  it('Does it possible to change the transaction fees as the admin ? (Should be)', async function () {
    const fees = await contract.transactionFee();
    await expect(fees).to.be.equal(0);

    await contract.changeTransactionFee(10);

    const newFees = await contract.transactionFee();
    await expect(newFees).to.be.equal(10);
  });

  it('Does it possible to change the transaction fees without admin access ? (Should not be)', async function () {
    const fees = await contract.transactionFee();
    await expect(fees).to.be.equal(0);

    await expect(contract.connect(user1).changeTransactionFee(10)).to.be.revertedWith(Helper.errors.CALLER_NOT_ADMIN);

    const newFees = await contract.transactionFee();
    await expect(newFees).to.be.equal(0);
  });

  it('Does it possible to create a listing and return detail of it ? (Should be)', async function () {
    await Helper.deployERC721();
    await Helper.mintERC721(user1.address, 1);
    await contract.connect(user1).createListing(mockERC721.address, 0, 100);

    const details = await simpleNftMarketplace.getListingDetail(0);
    expect(details.tokenContract).to.be.equal(mockERC721.address);
    expect(details.tokenId).to.be.equal(0);
    expect(details.salePrice).to.be.equal(100);
    expect(details.seller).to.be.equal(user1.address);
    expect(details.buyer).to.be.equal('0x0000000000000000000000000000000000000000');
    // expect(details.listingTimestamp).to.be.equal(ethers.BigNumber.from(0));
    expect(details.buyTimestamp).to.be.equal(ethers.BigNumber.from(0));
  });
});

/* Scenario test

    - Est-ce que les fonctions public returns pour les roles fonctionnent ? (should be)
    - Est-il possible d'assigner le rôle de modérateur à une adresse, que cette adresse blacklist un token, blacklist un user ? (shoulde be)
    - Est-il possible de withdraw les frais de transaction en tant que treasury, admin, no role ? (should be, should be, should not be)
    - Est-il possible de créer un listing et de buy ce listing ? (should be)
    - Est-il possible en tant que modérateur de blacklist un token, ensuite de créer un listing de ce token ? (should not be)
    - Est-il possible en étant une adresse blacklist de créer un listing ? (should not be)
    - Est-il possible en étant une adresse blacklist de buy un listing ? (should not be)
    - Est-il possible en tant que modérateur de cancel un listing ? (should be)
    - Est-il possible de regarder si tel token ou telle user est blacklist ? (should be)
    - Est-il possible créer un listing, en tant que modérateur (étant informé que cet user à volé le token) de cancel le listing, de blacklist le token, de blacklist le user et de vérifier si les blacklists ont bien fonctionné ? (should be)

  */
