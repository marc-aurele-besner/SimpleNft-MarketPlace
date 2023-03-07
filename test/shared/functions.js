const deployERC721 = async() => {
  const MockERC721 = await ethers.getContractFactory('MockERC721'); 
  mockERC721 = await MockERC721.deploy();
  const MockERC721Instance = await mockERC721.deployed();
  return MockERC721Instance;
}

const mintERC721 = async(to, tokenId) => {
  mockERC721.mint(to, tokenId) 
}

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

const mintERC721 = async (_to, _tokenId) => {
  mockERC721.mint(_to, _tokenId);
};

module.exports = {
  sendRawTxn,
  checkRawTxnResult,
  getRandomInt,
  returnCurrentTimestamp,
  deployERC721,
  mintERC721
};
