const { expect } = require('chai');

const constants = require('../../constants');

const sendRawTxn = async (input, sender, ethers, provider) => {
  const txCount = await provider.getTransactionCount(sender.address);
  const rawTx = {
    chainId: network.config.chainId,
    nonce: ethers.utils.hexlify(txCount),
    to: input.to,
    value: input.value || 0x00,
    gasLimit: ethers.utils.hexlify(3000000),
    gasPrice: ethers.utils.hexlify(25000000000),
    data: input.data
  };
  const rawTransactionHex = await sender.signTransaction(rawTx);
  const { hash } = await provider.sendTransaction(rawTransactionHex);
  return await provider.waitForTransaction(hash);
};

const checkRawTxnResult = async (input, sender, error) => {
  let result;
  if (error)
    if (network.name === 'hardhat') await expect(sendRawTxn(input, sender, ethers, ethers.provider)).to.be.revertedWith(error);
    else expect.fail('AssertionError: ' + error);
  else {
    result = await sendRawTxn(input, sender, ethers, ethers.provider);
    expect(result.status).to.equal(1);
  }
  return result;
};

const getRandomInt = (min, max) => {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min) + min);
};

const returnCurrentTimestamp = async () => {
  const currentBlockNumber = await provider.getBlockNumber();
  const block = await provider.getBlock(currentBlockNumber);
  return block.timestamp;
};

const deployERC721 = async () => {
  const MockERC721 = await ethers.getContractFactory('MockERC721');
  mockERC721 = await MockERC721.deploy();
  const MockERC721Instance = await mockERC721.deployed();
  return MockERC721Instance;
};

const mintERC721 = async (contract, _to, _tokenId) => {
  await contract.mint(_to, _tokenId);
};

const approveERC721 = async (contract, sender, _hasApprove, _tokenId, error) => {
  const input = await contract.connect(sender).approve(_hasApprove, _tokenId);
  await checkRawTxnResult(input, sender, error);
};

const createAListing = async (sender, _tokenId, salePrice) => {
  const mockERC721 = await deployERC721();
  await mintERC721(mockERC721, sender.address, _tokenId);
  await approveERC721(mockERC721, sender, contract.address, _tokenId);

  await contract.changeSupportedContract(mockERC721.address, true);
  await contract.connect(sender)['createListing(address,uint256,uint256)'](mockERC721.address, _tokenId, salePrice);
};

const deployERC20 = async () => {
  const MockERC20 = await ethers.getContractFactory('MockERC20');
  mockERC20 = await MockERC20.deploy();
  const MockERC20Instance = await mockERC20.deployed();
  return MockERC20Instance;
};

const mintERC20 = async (contract, _to, _amount) => {
  await contract.mint(_to, _amount);
};

const deployAndMintERC20 = async (_sender, _amount) => {
  const mockERC20 = await deployERC20();
  mintERC20(mockERC20, _sender, _amount);
};

module.exports = {
  sendRawTxn,
  checkRawTxnResult,
  getRandomInt,
  returnCurrentTimestamp,
  deployERC721,
  mintERC721,
  approveERC721,
  createAListing,
  deployERC20,
  mintERC20,
  deployAndMintERC20
};
