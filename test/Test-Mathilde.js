const { expect } = require('chai');
const { ethers } = require('hardhat');
const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');

describe('SimpleNftMarketplace', function () {
    let Contract;
    let owner, seller, moderator;
    let listingId;
    
    beforeEach(async function () {
      [owner, seller, moderator] = await ethers.getSigners();
      const Contract = await ethers.getContractFactory('SimpleNftMarketplace');
      contract = await Contract.deploy();
      await contract.deployed();
    });

    describe('name', function () {
        it("Should return the correct NAME", async function () {
            const expectedName = "SimpleNft-MarketPlace";
            const actualName = await contract.name();
            expect(actualName).to.equal(expectedName);
    });
  });
});