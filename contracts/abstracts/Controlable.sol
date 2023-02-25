// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

abstract contract Controlable {
    mapping(address => mapping(uint => bool)) private blacklistToken;
    mapping(address => bool) private blacklistUser;
    mapping(address => bool) public admin;
    mapping(address => bool) public treasury;
    mapping(address => bool) public moderator;

    event TransactionFeeChanged();

    modifier onlyModerator() {
        require(moderator[msg.sender] == true, "Is not a moderator");
        _;
    }

    function _changeSupportedContract(address contractAddress) internal returns (bool success) {

    }

    function _changeTransactionFee(uint32 transactionFee) internal returns (bool success) {

    }

    // Treasury
    function _withdrawTransactionFee() internal returns (bool success) {

    }

    // Moderator
    function _blacklistToken(address tokenContract, uint256 tokenId) internal onlyModerator returns (bool success) {
        blacklistToken[tokenContract][tokenId] = true;
    }

    function _blacklistUser(address userAddress) internal onlyModerator returns (bool success) {
        blacklistUser[userAddress] = true; 
    }

    function transactionFee() public returns (uint32 transactionFee) {
        return transactionFee;
    }

    function token() public returns (address tokenAddress) {
        return tokenAddress;
    }

    function isAdmin(address account) public returns (bool isAdmin) {
        return admin[account];
    }

    function isTreasury(address account) public returns (bool isTreasury) {
        return treasury[account];
    }

    function isModerator(address account) public returns (bool isModerator) {
        return moderator[account];
    }
}
