// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol';

abstract contract Controlable is AccessControlUpgradeable {
  bytes32 public constant MODERATOR_ROLE = keccak256('MODERATOR_ROLE');
  bytes32 public constant TREASURY_ROLE = keccak256('TREASURY_ROLE');

  IERC20Upgradeable internal _token;

  mapping(address => mapping(uint => bool)) private blacklistToken;
  mapping(address => bool) private blacklistUser;
  mapping(address => bool) private supportedContracts;

  uint32 internal _transactionFee; // 100_000 = 1%
  uint256 internal _accumulatedTransactionFee;

  event TransactionFeeChanged(uint32 indexed oldFee, uint32 indexed newFee);
  event SupportedContractRemoved(address indexed contractAddress);
  event SupportedContractAdded(address indexed contractAddress);

  function __Controlable_init(address treasury) internal onlyInitializing {
    __AccessControl_init();
    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    _setupRole(MODERATOR_ROLE, _msgSender());
    _setupRole(TREASURY_ROLE, treasury);
  }

  modifier onlyAdmin() {
    require(isAdmin(msg.sender), 'Controlable: Only admin');
    _;
  }

  modifier onlyModerator() {
    require(isModerator(msg.sender), 'Controlable: Only moderator');
    _;
  }

  modifier onlyTreasury() {
    require(isTreasury(msg.sender), 'Controlable: Only treasury');
    _;
  }

  function _changeToken(IERC20Upgradeable contractAddress) internal returns (bool success) {
    _token = contractAddress;
    return true;
  }

  function _changeSupportedContract(address contractAddress, bool isSupported) internal returns (bool success) {
    supportedContracts[contractAddress] = isSupported;
    if (isSupported) {
      emit SupportedContractAdded(contractAddress);
    } else {
      emit SupportedContractRemoved(contractAddress);
    }
    return true;
  }

  function _changeTransactionFee(uint32 transactionFee_) internal returns (bool success) {
    uint32 oldFee = _transactionFee;
    _transactionFee = transactionFee_;
    emit TransactionFeeChanged(oldFee, transactionFee_);
    return true;
  }

  // Treasury
  function _withdrawTransactionFee() internal returns (bool success) {
    require(_token.transfer(msg.sender, _accumulatedTransactionFee), 'Controlable: Transfer failed');
    return true;
  }

  // Moderator
  function _blacklistToken(address tokenContract, uint256 tokenId, bool isBlacklisted) internal returns (bool success) {
    if (isBlacklisted == true) {
      blacklistToken[tokenContract][tokenId] = true;
    } else {
      blacklistToken[tokenContract][tokenId] = false;
    }
    success = true;
  }

  function _blacklistUser(address userAddress, bool set) internal returns (bool success) {
    if (set == true) {
      blacklistUser[userAddress] = true;
    } else {
      blacklistUser[userAddress] = false;
    }
    success = true;
  }

  function _isBlacklistedUser(address userAddress) internal view returns (bool isBlacklisted) {
    return blacklistUser[userAddress];
  }

  function _isBlacklistedToken(address tokenContract, uint256 tokenId) internal view returns (bool isBlacklisted) {
    return blacklistToken[tokenContract][tokenId];
  }

  function _isSupportedContract(address tokenContract) internal view returns (bool isSupported) {
    return supportedContracts[tokenContract];
  }

  function accumulatedFees() public view onlyAdmin returns (uint256) {
    return _accumulatedTransactionFee;
  }

  function transactionFee() public view returns (uint32) {
    return _transactionFee;
  }

  function token() public view returns (address tokenAddress) {
    return address(_token);
  }

  function giveModeratorAccess(address account) external onlyAdmin returns (bool success) {
    _grantRole(MODERATOR_ROLE, account);
    return true;
  }

  function giveTreasuryAccess(address account) external onlyAdmin returns (bool success) {
    _grantRole(TREASURY_ROLE, account);
    return true;
  }

  function isAdmin(address account) public view returns (bool) {
    return hasRole(DEFAULT_ADMIN_ROLE, account);
  }

  function isTreasury(address account) public view returns (bool) {
    return hasRole(TREASURY_ROLE, account);
  }

  function isModerator(address account) public view returns (bool) {
    return hasRole(MODERATOR_ROLE, account);
  }

  function addRole(bytes32 role, address account) external onlyAdmin returns (bool success) {
    grantRole(role, account);
    return true;
  }

  function removeRole(bytes32 role, address account) external onlyAdmin returns (bool success) {
    revokeRole(role, account);
    return true;
  }
}
