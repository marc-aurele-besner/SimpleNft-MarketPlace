const { time, loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { expect } = require('chai');
const Helper = require('./shared');

describe('Test-Benoit', function () {
    before(async function () {
        [provider, owner, user1, user2, user3] = await
    Helper.setupProviderAndAccount();
    });

    beforeEach (async function () {
        contract = await Helper.setupContract()
    })
    it.only("does it return the correct listing price (should be)", async function () {
        await Helper.deployERC721();
        await Helper.mintERC721(user1.address, 1);
        await mockERC721.connect(user1).approve(contract.address, 1);
        await contract.connect(user1)['createListing(address,uint256,uint256)'](mockERC721.address, 1, 100);
        expect(await contract.listingPrice(1)).to.be.equal(100)
    });
})  

//#37 read function tests

it("does it return true is the listing is active (should be)", async () => {

});

it("does it return true is the listing is active (should be)", async () => {

});

it("does it return true if a user is blacklisted (should be)", async () => {

});

it("does it return true if a token is blacklisted (should be)", async () => {

});

it("does it return true if a contract is supported (should be)", async () => {

});

it("does it return the correct listing fee (should be)", async () => {

});
// buy / sell 
    it("Does user can buy NFT (trade eth for token)(should be)", async function () {
    
    });
    it("Does user can sell NFT (trade eth for token)(should be)", async function () {
    
    });
    // WithDrawEth/ Send
    it("Does user can withDrawEth from the marketplace (should be)", async function () {
    });
    it("Does user can sendEth to the marketplace (should  be)", async function () {
    });