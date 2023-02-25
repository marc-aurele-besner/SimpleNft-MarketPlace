// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

abstract contract Controlable {
    mapping(address => mapping(uint => bool)) private blacklistToken;
    mapping(address => bool) private blacklistUser;
    mapping(address => bool) public admin;
    mapping(address => bool) public treasury;
    mapping(address => bool) public moderator;
    
    string public transactionFee;

    event TransactionFeeChanged(uint indexed oldFee, uint indexed newFee);

    modifier onlyModerator() {
        require(moderator[msg.sender] == true, "Is not a moderator");
        _;
    }

    modifier onlyAdmin() {
        require(admin[msg.sender] == true, "Is not an admin");
        _;
    }

    function _changeSupportedContract(address contractAddress) internal returns (bool success) {

    }

    function _changeTransactionFee(uint32 _transactionFee) internal onlyAdmin returns (bool success) {
        transactionFee = _transactionFee;
        emit TransactionFeeChanged(_transactionFee, transactionFee);
    }

    // Treasury
    // function _withdrawTransactionFee() internal onlyAdmin returns (bool success) {
    //     (success, ) = payable(treasury).call{ value: address.treasury.balance }('');
    // }

    // Moderator
    function _blacklistToken(address tokenContract, uint256 tokenId) internal onlyModerator returns (bool success) {
        blacklistToken[tokenContract][tokenId] = true;
    }

    function _blacklistUser(address userAddress) internal onlyModerator returns (bool success) {
        blacklistUser[userAddress] = true; 
    }

    function transactionFee() public returns (uint32 _transactionFee) {
        return transactionFee;
    }

    function token() public returns (address tokenAddress) {
        
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
