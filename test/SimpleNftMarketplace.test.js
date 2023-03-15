const { time, loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { anyValue } = require('@nomicfoundation/hardhat-chai-matchers/withArgs');
const { expect } = require('chai');

const Helper = require('./shared');

describe('SimpleNftMarketplace', function () {
  async function deployOneYearLockFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const SimpleNftMarketplace = await ethers.getContractFactory('SimpleNftMarketplace');
    const simpleNftMarketplace = await SimpleNftMarketplace.deploy();

    return { simpleNftMarketplace, owner, otherAccount };
  }

  describe('Deployment', function () {
    it('Should deploy the contract', async function () {
      const { simpleNftMarketplace, owner, otherAccount } = await loadFixture(deployOneYearLockFixture);

      expect(true).to.be.true;
    });
  });

  describe('Default Return value', function () {
    it('Should return default value when calling getListingDetail', async function () {
      const { simpleNftMarketplace, owner, otherAccount } = await loadFixture(deployOneYearLockFixture);

      const details = await simpleNftMarketplace.getListingDetail(10000000);
      expect(details.tokenContract).to.be.equal('0x0000000000000000000000000000000000000000');
      expect(details.tokenId).to.be.equal(ethers.BigNumber.from(0));
      expect(details.salePrice).to.be.equal(ethers.BigNumber.from(0));
      expect(details.seller).to.be.equal('0x0000000000000000000000000000000000000000');
      expect(details.buyer).to.be.equal('0x0000000000000000000000000000000000000000');
      expect(details.listingTimestamp).to.be.equal(ethers.BigNumber.from(0));
      expect(details.buyTimestamp).to.be.equal(ethers.BigNumber.from(0));
    });
  });

  describe('SimpleNftMarketplace', function () {
    before(async function () {
      [provider, owner, user1, user2, user3] = await Helper.setupProviderAndAccount();
    });

    beforeEach(async function () {
      contract = await Helper.setupContract(true);
    });

    it('Should return default value when calling getListingDetail', async function () {
      const { simpleNftMarketplace, owner, otherAccount } = await loadFixture(deployOneYearLockFixture);

      const MockERC20 = await ethers.getContractFactory('MockERC20');
      mockERC20 = await MockERC20.deploy();
      await mockERC20.deployed();

      const signature = await Helper.signatures.signCreateListing(contract.address, owner, mockERC20.address, 1, 100, owner.address);
      // await contract.createListing(mockERC20.address, 1, 100, owner.address, signature.v, signature.r, signature.s);

      //  await contract['createListing(address,uint256,uint256)']();
      // await contract['createListing(address,uint256,uint256,address,uint8,bytes32,bytes32)'](mockERC20.address, 1, 100, owner.address, signature.v, signature.r, signature.s);
      // console.log('signature', signature);
    });

    it('Should return MODERATOR_ROLE()', async function () {
      const { simpleNftMarketplace, owner, otherAccount } = await loadFixture(deployOneYearLockFixture);

      const AdminRole = await simpleNftMarketplace.MODERATOR_ROLE();

      console.log('AdminRole', AdminRole);
      // const signature = await Helper.signatures.signCreateListing(contract.address, user1, mockERC721.address, 1, 100, user1.address);
      // await contract
      //   .connect(user1)
      //   ['createListing(address,uint256,uint256,address,uint8,bytes32,bytes32)'](
      //     mockERC721.address,
      //     1,
      //     100,
      //     user1.address,
      //     signature.v,
      //     signature.r,
      //     signature.s
      //   );

      // const details = await contract.getListingDetail(0);
      // expect(details.tokenContract).to.be.equal(mockERC721.address);
      // expect(details.tokenId).to.be.equal(1);
      // expect(details.salePrice).to.be.equal(100);
      // expect(details.seller).to.be.equal(user1.address);
      // expect(details.buyer).to.be.equal('0x0000000000000000000000000000000000000000');
      // // expect(details.listingTimestamp).to.be.equal(ethers.BigNumber.from(0));
      // expect(details.buyTimestamp).to.be.equal(ethers.BigNumber.from(0));
    });
  });
});
