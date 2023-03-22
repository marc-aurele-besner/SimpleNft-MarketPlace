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

    // it('Should return MODERATOR_ROLE()', async function () {
    //   const { simpleNftMarketplace, owner, otherAccount } = await loadFixture(deployOneYearLockFixture);

    //   const AdminRole = await simpleNftMarketplace.MODERATOR_ROLE();

    //   const MockERC20 = await ethers.getContractFactory('MockERC20');
    //   mockERC20 = await MockERC20.deploy();
    //   await mockERC20.deployed();

    //   const MockERC721 = await ethers.getContractFactory('MockERC721');
    //   const mockERC721 = await MockERC721.deploy();
    //   await mockERC721.deployed();

    //   await mockERC721.mint(user1.address, 1);
    //   await mockERC721.connect(user1).setApprovalForAll(contract.address, true);

    //   await mockERC20.mint(user2.address, 1000);
    //   await mockERC20.connect(user2).approve(contract.address, 1000);

    //   await contract.changeToken(mockERC20.address);
    //   await contract.changeSupportedContract(mockERC721.address, true);

    //   const signature = await Helper.signatures.signCreateListing(contract.address, user1, mockERC721.address, 1, 100, user1.address);
    //   await contract
    //     .connect(user1)
    //     ['createListing(address,uint256,uint256,address,uint8,bytes32,bytes32)'](
    //       mockERC721.address,
    //       1,
    //       100,
    //       user1.address,
    //       signature.v,
    //       signature.r,
    //       signature.s
    //     );

    //   const signature2 = await Helper.signatures.signBuyListing(contract.address, user2, 0, user2.address);

    //   await contract.connect(user1)['buyListing(uint256,address,uint8,bytes32,bytes32)'](0, user2.address, signature2.v, signature2.r, signature2.s);

    //   // const details = await contract.getListingDetail(0);
    //   // expect(details.tokenContract).to.be.equal(mockERC721.address);
    //   // expect(details.tokenId).to.be.equal(1);
    //   // expect(details.salePrice).to.be.equal(100);
    //   // expect(details.seller).to.be.equal(user1.address);
    //   // expect(details.buyer).to.be.equal('0x0000000000000000000000000000000000000000');
    //   // // expect(details.listingTimestamp).to.be.equal(ethers.BigNumber.from(0));
    //   // expect(details.buyTimestamp).to.be.equal(ethers.BigNumber.from(0));
    // });
  });
});
