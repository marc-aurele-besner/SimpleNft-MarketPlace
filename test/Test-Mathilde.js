const { expect } = require('chai');
const { ethers } = require('hardhat');
const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');

describe('SimpleNftMarketplace', function () {
    let Contract;
    let owner, lucie, seller, moderator, admin, nonAdmin, treasury, nonTreasury, nonModerator;
    let listingId;
    
    beforeEach(async function () {
      [owner, lucie, seller, moderator, nonModerator, admin, nonAdmin, treasury, nonTreasury] = await ethers.getSigners();
      const Contract = await ethers.getContractFactory('SimpleNftMarketplace');
      contract = await Contract.deploy();
      await contract.deployed();
      await contract.initialize(lucie.address);
    });

    describe('Controlable.sol', function () {

      // function _isBlacklistedUser(address userAddress) internal view returns (bool isBlacklisted)
      it("", async function () { 
      });

      // function _isBlacklistedToken(address tokenContract, uint256 tokenId) internal view returns (bool isBlacklisted)
      it("", async function () { 
      });

      // function _isSupportedContract(address tokenContract) internal view returns (bool isSupported)
      it("", async function () { 
      });


      // function transactionFee() public view returns (uint32)
      it("Should return the correct transactionFee", async function () {
        const expectedTransactionFee = 100000;
        const currentTransactionFee = await contract.transactionFee();
        expect(currentTransactionFee).to.equal(expectedTransactionFee);
      });

      // function token() public view returns (address tokenAddress)
      it("Should return the token address", async function () {
        const currentTokenAddress = await contract.token();
        expect(currentTokenAddress).to.equal(await contract._token()); 
      });

      it("Should verify if administrator", async function () { 
        const adminRole = contract.DEFAULT_ADMIN_ROLE();
        await contract.grantRole(adminRole, admin.address);
        expect(await contract.isAdmin(owner.address)).to.be.true;
        expect(await contract.connect(admin).isAdmin(admin.address)).to.be.true;
      });
      it("Should verify if non-administrator", async function () {
        expect(await contract.connect(lucie).isAdmin(lucie.address)).to.be.false;
        expect(await contract.connect(nonAdmin).isAdmin(nonAdmin.address)).to.be.false;
      });

      it("Should verify if Treasury", async function () { 
        const treasuryRole = contract.TREASURY_ROLE();
        await contract.grantRole(treasuryRole, treasury.address);
        expect(await contract.connect(treasury).isTreasury(treasury.address)).to.be.true;
        expect(await contract.connect(lucie).isTreasury(lucie.address)).to.be.true;
      });
      it("Should verify if non-Treasury", async function () {
        expect(await contract.connect(owner).isTreasury(owner.address)).to.be.false;
        expect(await contract.connect(nonTreasury).isTreasury(nonTreasury.address)).to.be.false;
      });

      it("Should verify if Moderator", async function () { 
        const moderatorRole = contract.MODERATOR_ROLE();
        await contract.grantRole(moderatorRole, moderator.address);
        expect(await contract.connect(moderator).isModerator(moderator.address)).to.be.true;
        expect(await contract.isModerator(owner.address)).to.be.true;
      });
      it("Should verify if non-Moderator", async function () { 
        expect(await contract.connect(lucie).isModerator(lucie.address)).to.be.false;
        expect(await contract.connect(nonModerator).isModerator(nonModerator.address)).to.be.false;
      });
    });

    describe('ListingManager.sol', function () {

      // function _calculateListingFee(uint256 listingId) internal view returns (uint256 amount)
      it("", async function () { 
      });

      // function getListingDetail(uint256 listingId) public view returns (Listing memory)
      it("", async function () { 
      });

      // function isSold(uint256 listingId) public view returns (bool)
      it("", async function () { 
      });
    });

    describe('ValidateSignature.sol', function () {

      // function _verifyCreateListing(address tokenContract, uint256 tokenId, uint256 salePrice, address seller, uint8 v, bytes32 r, bytes32 s) internal view returns (bool success) 
      it("", async function () { 
      });

      // function _verifyBuyListing(uint256 listingId, address buyer, uint8 v, bytes32 r, bytes32 s) internal view returns (bool success) 
      it("", async function () { 
      });
    });

    describe('SimpleNftMarketplace.sol', function () {

      // function initialize(address treasury) external initializer
      it("", async function () { 
      });

      // function name() public pure returns (string memory) 
      it("Should return the correct NAME", async function () {
          const expectedName = "SimpleNft-MarketPlace";
          const actualName = await contract.name();
          expect(actualName).to.equal(expectedName);
      });

      // function version() public pure returns (string memory) 
      it("", async function () { 
      });

      // function createListing(address tokenContract, uint256 tokenId, uint256 salePrice) external returns (uint256 listingId)
      it("", async function () { 
      });

      // function buyListing(uint256 listingId) external returns (bool success)
      it("", async function () { 
      });

      // function createListing(address tokenContract, uint256 tokenId, uint256 salePrice, address seller, uint8 v, bytes32 r, bytes32 s) external returns (uint256 listingId)
      it("should create a new listing", async function () { 
      });
      it("should revert if user (seller) is blacklisted", async function () { 
      });
      it("should not create a listing if seller is blacklisted", async function () { 
      });
      it("should revert if contract token is blacklisted", async function () { 
      });
      it(" should not create a listing if token contract is blacklisted", async function () { 
      });
      it("should revert if contract token is not supported", async function () { 
      });
      it("should not create a listing if token contract is not supported", async function () { 
      });
      it('should not create a listing if sale price is zero', async function () {
      });
      // trouver comment tester la ligne : IERC721Upgradeable(tokenContract).safeTransferFrom(seller, address(this), tokenId);
      it('should add a new listing to _listings array', async function () {
      });
      it('should emit a ListingCreated event', async function () {
      });
      
      // function buyListing(uint256 listingId, address buyer, uint8 v, bytes32 r, bytes32 s) external returns (bool success)
      it("", async function () { 
      });

      // function cancelListing(uint256 listingId) external onlyListingOwnerOrModerator(listingId) returns (bool success)
      it("", async function () { 
      });

      // function changeSupportedContract(address contractAddress, bool isSupported) external onlyAdmin returns (bool success)
      it("", async function () { 
      });

      // function changeTransactionFee(uint32 newTransactionFee) external onlyAdmin returns (bool success)
      it("", async function () { 
      });

      // function withdrawTransactionFee() external onlyTreasury returns (bool success)
      it("", async function () { 
      });

      // function blacklistToken(address tokenContract, uint256 tokenId, bool isBlackListed) external onlyModerator returns (bool success)
      it("", async function () { 
      });

      // function blacklistUser(address userAddress, bool set) external onlyModerator returns (bool success)
      it("", async function () { 
      });

      // function listingPrice(uint256 listingId) external view returns (uint256 listingPrice)
      it("", async function () { 
      });

      // function isListingActive(uint256 listingId) external view returns (bool isActive)
      it("", async function () { 
      });

      // function isBlacklistedUser(address userAddress) external view returns (bool isBlacklisted) 
      it("", async function () { 
      });

      // function isBlacklistedToken(address tokenContract, uint256 tokenId) external view returns (bool isBlacklisted)
      it("", async function () { 
      });

      // function isSupportedContract(address tokenContract) external view returns (bool isSupported)
      it("", async function () { 
      });

      // function calculateListingFee(uint256 listingId) external view returns (uint256 amount)
      it("", async function () { 
      }); 
    });
});