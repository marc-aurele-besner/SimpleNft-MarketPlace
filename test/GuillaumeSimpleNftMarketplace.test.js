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























  /* Scenario test
    - Est-il possible de changer les frais de transaction en étant l'admin (Should be)
    - Est-il possible de changer les frais de transaction en étant pas admin (Should not be)
    - Est-il possible de changer les frais de transaction en étant l'admin (Should be)
    - Est-ce que les fonctions public returns pour les roles fonctionnent ? (should be)
    - Est-il possible d'assigner le rôle de modérateur à une adresse, que cette adresse blacklist un token, blacklist un user ? (shoulde be)
    - Est-il possible de withdraw les frais de transaction en tant que treasury, admin, no role ? (should be, should be, should not be)
    - Est-il possible de créer un listing et de buy ce listing ? (should be)
    - Est-il possible en tant que modérateur de blacklist un token, ensuite de créer un listing de ce token ? (should not be)
    - Est-il possible en étant une adresse blacklist de créer un listing ? (should not be)
    - Est-il possible en étant une adresse blacklist de buy un listing ? (should not be)
    - Est-il possible en tant que modérateur de cancel un listing ? (should be)
    - Est-il possible de regarder si tel token ou telle user est blacklist ? (should be)
    - Est-il possible créer un listing, en tant que modérateur (étant informé que cet user à volé le token) de cancel le listing, de blacklist le token, de blacklist le user et de vérifier si les blacklists ont bien fonctionné ? (should be)
  */