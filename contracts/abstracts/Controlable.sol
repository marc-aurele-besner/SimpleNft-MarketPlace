// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

abstract contract Controlable {

    event TransactionFeeChanged();

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
    
    function _changeTransactionFee(uint32 transactionFee) internal returns (bool success) {

    }

    // Treasury
    function _withdrawTransactionFee() internal returns (bool success) {

    }

    // Moderator
    function _blacklistToken(address tokenContract, uint256 tokenId) internal returns (bool success) {

    }
    function _blacklistUser(address userAddress) internal returns (bool success) {

    }

    function transactionFee() public returns (uint32 transactionFee) {

    }
    function token() public returns (address tokenAddress) {

    }

    function isAdmin(address account) public returns (bool isAdmin) {

    }
    function isTreasury(address account) public returns (bool isTreasury) {

    }
    function isModerator(address account) public returns (bool isModerator) {

    }
}
