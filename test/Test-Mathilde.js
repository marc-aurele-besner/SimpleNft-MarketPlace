const { expect } = require('chai');
const { ethers } = require('hardhat');
const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const Helper = require('./shared');

describe('SimpleNftMarketplace', function () {
  let Contract, token;
  let owner, lucie, seller, moderator, admin, nonAdmin, treasury, nonTreasury, nonModerator, account;
  let listingId;

  beforeEach(async function () {
    [owner, lucie, seller, moderator, nonModerator, admin, nonAdmin, treasury, nonTreasury, account] = await ethers.getSigners();
    const Contract = await ethers.getContractFactory('SimpleNftMarketplace');
    contract = await Contract.deploy();
    await contract.deployed();
    await contract.initialize(lucie.address);
  });

  describe('Controlable.sol', function () {
    it('Should return the correct initial transactionFee', async function () {
      const expectedTransactionFee = 0;
      const currentTransactionFee = await contract.transactionFee();
      expect(currentTransactionFee).to.equal(expectedTransactionFee);
    });
    it('Should return the correct transactionFee, after change', async function () {
      await contract.changeTransactionFee(100000);
      const expectedTransactionFee = 100000;
      const currentTransactionFee = await contract.transactionFee();
      expect(currentTransactionFee).to.equal(expectedTransactionFee);
    });

    it('Should return a null token address before setting', async function () {
      const currentTokenAddress = await contract.token();
      expect(currentTokenAddress).to.equal('0x0000000000000000000000000000000000000000');
    });
    it('Should return the correct token address', async function () {
      const mockERC20 = await Helper.deployERC20();
      await contract.changeToken(mockERC20.address);
      const expectedTokenAddress = mockERC20.address;
      const currentTokenAddress = await contract.token();
      expect(currentTokenAddress).to.equal(expectedTokenAddress);
    });

    it('Should verify if administrator', async function () {
      const adminRole = contract.DEFAULT_ADMIN_ROLE();
      await contract.grantRole(adminRole, admin.address);
      expect(await contract.isAdmin(owner.address)).to.be.true;
      expect(await contract.connect(admin).isAdmin(admin.address)).to.be.true;
    });
    it('Should verify if non-administrator', async function () {
      expect(await contract.connect(lucie).isAdmin(lucie.address)).to.be.false;
      expect(await contract.connect(nonAdmin).isAdmin(nonAdmin.address)).to.be.false;
    });

    it('Should verify if Treasury', async function () {
      const treasuryRole = contract.TREASURY_ROLE();
      await contract.grantRole(treasuryRole, treasury.address);
      expect(await contract.connect(treasury).isTreasury(treasury.address)).to.be.true;
      expect(await contract.connect(lucie).isTreasury(lucie.address)).to.be.true;
    });
    it('Should verify if non-Treasury', async function () {
      expect(await contract.connect(owner).isTreasury(owner.address)).to.be.false;
      expect(await contract.connect(nonTreasury).isTreasury(nonTreasury.address)).to.be.false;
    });

    it('Should verify if Moderator', async function () {
      const moderatorRole = contract.MODERATOR_ROLE();
      await contract.grantRole(moderatorRole, moderator.address);
      expect(await contract.connect(moderator).isModerator(moderator.address)).to.be.true;
      expect(await contract.isModerator(owner.address)).to.be.true;
    });
    it('Should verify if non-Moderator', async function () {
      expect(await contract.connect(lucie).isModerator(lucie.address)).to.be.false;
      expect(await contract.connect(nonModerator).isModerator(nonModerator.address)).to.be.false;
    });

    it('Should add a role to an account', async function () {
      const moderatorRole = contract.MODERATOR_ROLE();
      const adminRole = contract.DEFAULT_ADMIN_ROLE();

      expect(await contract.connect(admin).isAdmin(admin.address)).to.be.false;
      expect(await contract.connect(account).isModerator(account.address)).to.be.false;

      await contract.grantRole(adminRole, admin.address);
      await contract.connect(admin).addRole(moderatorRole, account.address);
      const hasRole = await contract.hasRole(moderatorRole, account.address);
      expect(hasRole).to.equal(true);
    });
    it('Should only be callable by an admin', async function () {
      const moderatorRole = contract.MODERATOR_ROLE();
      await expect(contract.connect(lucie).addRole(moderatorRole, account.address)).to.be.revertedWith(Helper.errors.CALLER_NOT_ADMIN);
    });

    it('Should remove a role to an account', async function () {
      const moderatorRole = contract.MODERATOR_ROLE();
      const adminRole = contract.DEFAULT_ADMIN_ROLE();

      expect(await contract.connect(admin).isAdmin(admin.address)).to.be.false;
      expect(await contract.connect(account).isModerator(account.address)).to.be.false;

      await contract.grantRole(adminRole, admin.address);
      await contract.connect(admin).addRole(moderatorRole, account.address);
      const hasRole = await contract.hasRole(moderatorRole, account.address);

      expect(hasRole).to.equal(true);

      await contract.connect(admin).removeRole(moderatorRole, account.address);
      const hasRole1 = await contract.hasRole(moderatorRole, account.address);
      expect(hasRole1).to.equal(false);
    });
    it('Should only be callable by an admin', async function () {
      const moderatorRole = contract.MODERATOR_ROLE();
      await expect(contract.connect(lucie).removeRole(moderatorRole, account.address)).to.be.revertedWith(Helper.errors.CALLER_NOT_ADMIN);
    });
    it('Can not remove role from itself, only admin', async function () {
      const moderatorRole = contract.MODERATOR_ROLE();
      const adminRole = contract.DEFAULT_ADMIN_ROLE();

      expect(await contract.connect(admin).isAdmin(admin.address)).to.be.false;
      expect(await contract.connect(account).isModerator(account.address)).to.be.false;

      await contract.grantRole(adminRole, admin.address);
      await contract.connect(admin).addRole(moderatorRole, account.address);
      const hasRole = await contract.hasRole(moderatorRole, account.address);
      await expect(contract.connect(account).removeRole(moderatorRole, account.address)).to.be.revertedWith(Helper.errors.CALLER_NOT_ADMIN);
    });
  });

  describe('ListingManager.sol', function () {
    // function getListingDetail(uint256 listingId) public view returns (Listing memory)
    it('', async function () {});

    // function isSold(uint256 listingId) public view returns (bool)
    it('', async function () {});
  });

  describe('SimpleNftMarketplace.sol', function () {
    // function initialize(address treasury) external initializer
    it('', async function () {});

    // function name() public pure returns (string memory)
    it('Should return the correct NAME', async function () {
      const expectedName = 'SimpleNftMarketplace';
      const actualName = await contract.name();
      expect(actualName).to.equal(expectedName);
    });

    // function version() public pure returns (string memory)
    it('Should return the correct VERSION', async function () {
      const expectedVersion = '0.0.1';
      const actualVersion = await contract.version();
      expect(actualVersion).to.equal(expectedVersion);
    });

    // function createListing(address tokenContract, uint256 tokenId, uint256 salePrice) external returns (uint256 listingId)
    it('should create a new listing', async function () {
      // const tokenContract = '0x123...';
      // const tokenId = 1;
      // const salePrice = ethers.utils.parseEther('1');
    });

    it('should revert if user (seller) is blacklisted', async function () {});
    it('should not create a listing if seller is blacklisted', async function () {});
    it('should revert if contract token is blacklisted', async function () {});
    it(' should not create a listing if token contract is blacklisted', async function () {});
    it('should revert if contract token is not supported', async function () {});
    it('should not create a listing if token contract is not supported', async function () {});
    it('should not create a listing if sale price is zero', async function () {});
    // trouver comment tester la ligne : IERC721Upgradeable(tokenContract).safeTransferFrom(seller, address(this), tokenId);
    it('should add a new listing to _listings array', async function () {});
    it('should emit a ListingCreated event', async function () {});

    // function buyListing(uint256 listingId) external returns (bool success)
    it('', async function () {});

    // function createListing(address tokenContract, uint256 tokenId, uint256 salePrice, address seller, uint8 v, bytes32 r, bytes32 s) external returns (uint256 listingId)
    it('should create a new listing', async function () {});

    // function _verifyCreateListing(address tokenContract, uint256 tokenId, uint256 salePrice, address seller, uint8 v, bytes32 r, bytes32 s) internal view returns (bool success)
    // it("should return true for a valid signature", async function () {
    //   const tokenContract = '0x123...';
    //   const tokenId = 1;
    //   const salePrice = ethers.utils.parseEther('1');
    //   const seller1 = seller.address;

    //   const message = {tokenContract, tokenId, salePrice, seller1};
    //   const signature = await seller._signTypedData(message);
    //   const { v, r, s } = ethers.utils.splitSignature(signature);

    //   const success = await contract._verifyCreateListing(tokenContract, tokenId, salePrice, seller1, v, r, s);
    //   expect(success).to.be.true;
    // });

    // function buyListing(uint256 listingId, address buyer, uint8 v, bytes32 r, bytes32 s) external returns (bool success)
    // it("", async function () {
    // });

    // // function cancelListing(uint256 listingId) external onlyListingOwnerOrModerator(listingId) returns (bool success)
    // it("", async function () {
    // });

    // // function changeSupportedContract(address contractAddress, bool isSupported) external onlyAdmin returns (bool success)
    // it("", async function () {
    // });

    // // function changeTransactionFee(uint32 newTransactionFee) external onlyAdmin returns (bool success)
    // it("", async function () {
    // });

    // // function withdrawTransactionFee() external onlyTreasury returns (bool success)
    // it("", async function () {
    // });

    // // function blacklistToken(address tokenContract, uint256 tokenId, bool isBlackListed) external onlyModerator returns (bool success)
    // it("", async function () {
    // });

    // // function blacklistUser(address userAddress, bool set) external onlyModerator returns (bool success)
    // it("", async function () {
    // });

    // // function listingPrice(uint256 listingId) external view returns (uint256 listingPrice)
    // it("", async function () {
    // });

    // // function isListingActive(uint256 listingId) external view returns (bool isActive)
    // it("", async function () {
    // });

    // // function isBlacklistedUser(address userAddress) external view returns (bool isBlacklisted)
    // it("", async function () {
    // });

    // // function isBlacklistedToken(address tokenContract, uint256 tokenId) external view returns (bool isBlacklisted)
    // it("", async function () {
    // });

    // // function isSupportedContract(address tokenContract) external view returns (bool isSupported)
    // it("", async function () {
    // });

    // // function calculateListingFee(uint256 listingId) external view returns (uint256 amount)
    // it("", async function () {
    // });
  });
});
