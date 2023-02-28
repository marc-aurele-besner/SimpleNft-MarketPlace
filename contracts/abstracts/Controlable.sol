// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/AccessControl.sol";

interface IERC20 {
    function balanceOf(
        address account
    ) external returns (uint256);

    function transfer(
        address to,
        uint256 amount
    ) external returns (bool);
}

abstract contract Controlable {

    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");
    bytes32 public constant TREASURY_ROLE = keccak256("TREASURY_ROLE");

    mapping(address => mapping(uint => bool)) private blacklistToken;
    mapping(address => bool) private blacklistUser;
    
    string public transactionFee;

    event TransactionFeeChanged(uint indexed oldFee, uint indexed newFee);

    mapping(address => bool) supportedContracts;
    function _changeSupportedContract(address contractAddress) internal returns (bool success) {
        require(msg.sender == owner, "Vous n'avez pas les autorisations nécessaires.");

        if (supportedContracts[contractAddress]) {
        // Le contrat est déjà pris en charge, donc on le supprime
            supportedContracts[contractAddress] = false;
            emit SupportedContractRemoved(contractAddress);
            return true;
        } else {
            // Le contrat n'est pas pris en charge, donc on l'ajoute
            supportedContracts[contractAddress] = true;
            emit SupportedContractAdded(contractAddress);
            return true;
        }
    }

    uint32 public transactionFee;
    function _changeTransactionFee(uint32 transactionFee) internal returns (bool success) {
        require(msg.sender == owner, "Vous n'avez pas les autorisations nécessaires.");

        transactionFee = newTransactionFee;
        emit TransactionFeeChanged(newTransactionFee);
        return true;
    }

    // Treasury

    function _changeTransactionFee(uint32 _transactionFee) internal onlyRole(DEFAULT_ADMIN_ROLE) returns (bool success) {
        transactionFee = _transactionFee;
        emit TransactionFeeChanged(_transactionFee, transactionFee);
    }

    // Treasury
    function _withdrawTransactionFee(address tokenAddress) internal onlyRole(TREASURY_ROLE) returns (bool success) {
        IERC20 token = IERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        require(token.transfer(msg.sender, balance), "Controlable: Transfer failed");
        return true;
    }

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