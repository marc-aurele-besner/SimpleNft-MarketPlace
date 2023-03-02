const { expect } = require('chai');
const { ethers } = require('hardhat');
const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');

// Créer des sénarios pour chaque fonction du fichier Controlable.sol, ListingManager.sol, 
// ValidateSignature.sol, SimpleNftMarketplace.sol

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
  
    describe('onlyListingOwnerOrModerator', function () {
      it('should allow the seller to call the function', async function () {
// logique a écrire 
      });
  
      it('should allow a moderator to call the function', async function () {
// logique a écrire 
      });
  
      it('should not allow someone who is not the seller or moderator to call the function', async function () {
// logique a écrire 
      });
    });

    describe('name', function () {
        it("Should return the correct NAME", async function () {
            const expectedName = "SimpleNft-MarketPlace";
            const actualName = await contract.NAME;
            expect(actualName).to.equal(expectedName);
    });
  });
  