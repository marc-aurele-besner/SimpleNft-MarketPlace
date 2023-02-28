const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");


/*
    Scénario :

    A user wants to sell an NFT and creates an ad by providing the necessary information,address of the NFT contract, NFT item, selling price. (should be)
    A user wants to sell an NFT and creates with negative sales price (should not)
    A user wants to try to buy with listingId, but doesn't exist or not active (should not)
    A moderator wants to cancel with the listingID (should be)
        if the user tries to cancel when it doesn't belong to him (should not)
    A user wants to buy from a blacklist address (should not)
    A user wants to create a listing and buy this listing (should be)
    A moderator blacklists a specific user by providing the user's address (should be) --multisig pour que ce soit validé par plusieurs modérateurs et non 1 seul pour les abus ? 
        if the user doesn't exist (should not)
    An admin changes the transaction fee for an amount much higher than the gas price (should not)
    Submit transaction to the corresponding network to communicate with the blockchain
    A user with a crypto wallet account (metamask) gets authorization on the marketplace 
*/
