const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("SimpleNftMarketplace", function () {
  async function deployOneYearLockFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const SimpleNftMarketplace = await ethers.getContractFactory("SimpleNftMarketplace");
    const simpleNftMarketplace = await SimpleNftMarketplace.deploy();

    return { simpleNftMarketplace, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should deploy the contract", async function () {
      const { simpleNftMarketplace, owner, otherAccount } = await loadFixture(deployOneYearLockFixture);

      expect(true).to.be.true;
    });
  });

  describe("Default Return value", function () {
    it("Should return default value when calling getListingDetail", async function () {
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
});
