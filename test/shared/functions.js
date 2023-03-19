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
  const mockERC721 = await MockERC721.deploy();
  await mockERC721.deployed();
  return mockERC721;
};

const mintERC721 = async (contract, _to, _tokenId) => {
  await contract.mint(_to, _tokenId);
};

const approveERC721 = async (contract, sender, _hasApprove, _tokenId, error) => {
  const input = await contract.connect(sender).approve(_hasApprove, _tokenId);
  await checkRawTxnResult(input, sender, error);
};

const deploy_Mint_ApproveERC721 = async (sender, _tokenId) => {
  const mockERC721 = await deployERC721();
  await mintERC721(mockERC721, sender.address, _tokenId);
  await approveERC721(mockERC721, sender, contract.address, _tokenId);
  return mockERC721;
};

const deployERC20 = async () => {
  const MockERC20 = await ethers.getContractFactory('MockERC20');
  const mockERC20 = await MockERC20.deploy();
  const MockERC20Instance = await mockERC20.deployed();
  return MockERC20Instance;
};

const mintERC20 = async (contract, _to, _amount) => {
  await contract.mint(_to, _amount);
  expect(await contract.balanceOf(_to)).to.equal(_amount);
};

const approveERC20 = async (contract, sender, spenderAddress, _amount) => {
  await contract.connect(sender).approve(spenderAddress, _amount);
  expect(await contract.allowance(sender.address, spenderAddress)).to.equal(_amount);
};

const deploy_Mint_ApproveERC20 = async (sender, spenderAddress, _amount) => {
  const mockERC20 = await deployERC20();
  await mintERC20(mockERC20, sender.address, _amount);
  await approveERC20(mockERC20, sender, spenderAddress, _amount);
  return mockERC20;
};

const changeSupportedContract = async (contract, sender, nftAddress, value, error) => {
  await contract.connect(sender).changeSupportedContract(nftAddress, value);
  // await checkRawTxnResult(input, sender, error);
  if (!error) expect(await contract.isSupportedContract(nftAddress)).to.be.equal(value);
};

const create_listing = async (sender, contractAddress, tokenId, price, listingId) => {
  await contract.connect(sender)['createListing(address,uint256,uint256)'](contractAddress, tokenId, price);
  expect(await contract.listingPrice(listingId)).to.be.equal(price);
};

const changeSupportedContractIsSupported = async (contractAddress) => {
  expect(await contract.isSupportedContract(contractAddress)).to.be.equal(false);
  await contract.changeSupportedContract(contractAddress, true);
  expect(await contract.isSupportedContract(contractAddress)).to.be.equal(true);
};

const moderator = async (userAddress) => {
  expect(await contract.isModerator(userAddress)).to.be.equal(false);
  await contract.grantRole(await contract.MODERATOR_ROLE(), userAddress);
  expect(await contract.isModerator(userAddress)).to.be.equal(true);
};

module.exports = {
  sendRawTxn,
  checkRawTxnResult,
  getRandomInt,
  returnCurrentTimestamp,
  deployERC721,
  mintERC721,
  approveERC721,
  deploy_Mint_ApproveERC721,
  deployERC20,
  mintERC20,
  approveERC20,
  deploy_Mint_ApproveERC20,

  changeSupportedContract,

  create_listing,
  changeSupportedContractIsSupported,
  moderator
};