// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

abstract contract Controlable {

    event TransactionFeeChanged();

    function _changeSupportedContract(address contractAddress) internal returns (bool success) {

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
    
    // Admin || Team management

    // if you want to resell the NFTmarketPlace : 
    function transferOwnership(address newAdmin) external require(newAdmin != address(0), "new admin is the zero address") {
        require(msg.sender == admin, "caller is not the admin");
        require(newAdmin != address(0), "new admin is the zero address");
    }
    // adding new address to addModerator

    function addModerator(address account) internal returns (bool success) {
       require(msg.sender == admin, "caller is not the admin");
       require(account != address(0), "new admin is the zero address");
    }
    function removeModerator(address account) internal returns(bool success) {
       require(msg.sender == admin, "caller is not the admin");
       require(account != address(0), "new admin is the zero address");
    }

    }
    function promoteModerator(address account) internal returns(bool success) {
       require(msg.sender == admin, "caller is not the admin");
       require(account != address(0), "new admin is the zero address");
    }

    function demoteModerator(address account) internal returns(bool success) {
       require(msg.sender == admin, "caller is not the admin");
       require(account != address(0), "new admin is the zero address");
    }


