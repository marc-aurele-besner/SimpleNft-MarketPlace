const deployERC721 = async() => {
    const MockERC721 = await ethers.getContractFactory('MockERC721'); 
    mockERC721 = await MockERC721.deploy();
    const MockERC721Instance = await mockERC721.deployed();
    return MockERC721Instance;
}

const mintERC721 = async(to, tokenId) => {
    mockERC721.mint(to, tokenId) 
}

module.exports= {
    deployERC721,
    mintERC721
}