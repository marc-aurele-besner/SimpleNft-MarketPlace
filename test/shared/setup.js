const { network } = require('hardhat');
const constants = require('../../constants');
const functions = require('./functions');

console.log('\x1b[34m', `${constants.FIGLET_NAME}\n`, '\x1b[32m', 'Connected to network: ', '\x1b[33m', network.name, '\x1b[0m');

const setupContract = async () => {
  // Get contract artifacts
  const ContractFactory = await ethers.getContractFactory(constants.CONTRACT_NAME);

  // Deploy contracts
  const contract = await ContractFactory.deploy();
  const contractInstance = await contract.deployed();
// pourquoi return contractInstance ici ?
  return contractInstance;
};

const setupProviderAndAccount = async () => {
  if (network.name === 'hardhat' || network.name === 'localhost') provider = ethers.provider;
  else provider = new ethers.providers.JsonRpcProvider(network.config.url);

  const owner = new ethers.Wallet(ethers.Wallet.fromMnemonic(network.config.accounts.mnemonic, `m/44'/60'/0'/0/0`).privateKey, provider);
  const user1 = new ethers.Wallet(ethers.Wallet.fromMnemonic(network.config.accounts.mnemonic, `m/44'/60'/0'/0/1`).privateKey, provider);
  const user2 = new ethers.Wallet(ethers.Wallet.fromMnemonic(network.config.accounts.mnemonic, `m/44'/60'/0'/0/2`).privateKey, provider);
  const user3 = new ethers.Wallet(ethers.Wallet.fromMnemonic(network.config.accounts.mnemonic, `m/44'/60'/0'/0/3`).privateKey, provider);
  if (network.name === 'hardhat' || network.name === 'localhost') {
    if ((await user1.getBalance()).lt(ethers.utils.parseEther('1')))
      await owner.sendTransaction({
        to: user1.address,
        value: ethers.utils.parseEther('1')
      });
    if ((await user2.getBalance()).lt(ethers.utils.parseEther('1')))
      await owner.sendTransaction({
        to: user2.address,
        value: ethers.utils.parseEther('1')
      });
    if ((await user3.getBalance()).lt(ethers.utils.parseEther('1')))
      await owner.sendTransaction({
        to: user3.address,
        value: ethers.utils.parseEther('1')
      });
  }
  return [provider, owner, user1, user2, user3];
};

module.exports = {
  setupContract,
  setupProviderAndAccount
};