const { time, loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { anyValue } = require('@nomicfoundation/hardhat-chai-matchers/withArgs');
const { expect } = require('chai');
const Helper = require('./shared/setup');

describe('SimpleNftMarketplace', function () {
  before(async function () {
    [provider, owner, user1, user2, user3] = await Helper.setupProviderAndAccount();
  });

  beforeEach(async function () {
    contract = await Helper.setupContract([user1.address, user2.address]);
  });

  it('Should return default value when calling getListingDetail', async function () {});
});

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
