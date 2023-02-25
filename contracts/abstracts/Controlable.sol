// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/AccessControl.sol";
abstract contract Controlable {

    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");
    bytes32 public constant TREASURY_ROLE = keccak256("TREASURY_ROLE");

    mapping(address => mapping(uint => bool)) private blacklistToken;
    mapping(address => bool) private blacklistUser;
    
    string public transactionFee;

    event TransactionFeeChanged(uint indexed oldFee, uint indexed newFee);

    function _changeSupportedContract(address contractAddress) internal returns (bool success) {

    }

    function _changeTransactionFee(uint32 _transactionFee) internal onlyRole(DEFAULT_ADMIN_ROLE) returns (bool success) {
        transactionFee = _transactionFee;
        emit TransactionFeeChanged(_transactionFee, transactionFee);
    }

    // Treasury
    // function _withdrawTransactionFee() internal onlyAdmin returns (bool success) {
    //     (success, ) = payable(treasury).call{ value: address.treasury.balance }('');
    // }

    // Moderator
    function _blacklistToken(address tokenContract, uint256 tokenId, bool set) internal onlyRole(MODERATOR_ROLE) returns (bool success) {
        if (set == true) {
            blacklistToken[tokenContract][tokenId] = true;
        } else {
            delete blacklistToken[tokenContract][tokenId];
        }
    }

    function _blacklistUser(address userAddress, bool set) internal onlyRole(MODERATOR_ROLE) returns (bool success) {
        if (set == true) {
            blacklistUser[userAddress] = true; 
        } else {
            delete blacklistuser[userAddress];
        }
    }

    function transactionFee() public returns (uint32 _transactionFee) {
        return transactionFee;
    }

    function token() public returns (address tokenAddress) {
        
    }

    function isAdmin(address account) public returns (bool isAdmin) {
        return hasRole(DEFAULT_ADMIN_ROLE, account);
    }

    function isTreasury(address account) public returns (bool isTreasury) {
        return hasRole(TREASURY_ROLE, account);
    }

    function isModerator(address account) public returns (bool isModerator) {
        return hasRole(MODERATOR_ROLE, account);
    }
}
