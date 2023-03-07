const { network } = require('hardhat')

const constants = require('../../constants')

const signCreateListing = async (
    contractAddress,
    sourceWallet,
    tokenContract,
    tokenId,
    salePrice,
    seller
  ) => {
    var signature = await sourceWallet._signTypedData(
      {
        name: constants.CONTRACT_NAME,
        version: constants.CONTRACT_VERSION,
        chainId: network.config.chainId,
        verifyingContract: contractAddress,
      },
      {
        CreateListing: [
          {
            name: 'tokenContract',
            type: 'address',
          },
          {
            name: 'tokenId',
            type: 'uint256',
          },
          {
            name: 'salePrice',
            type: 'uint256',
          },
          {
            name: 'seller',
            type: 'address',
          }
        ],
      },
      {
        tokenContract,
        tokenId,
        salePrice,
        seller
      }
    )
    return ethers.utils.splitSignature(signature);
}

const signBuyListing = async (
    contractAddress,
    sourceWallet,
    listingId,
    buyer
  ) => {
    var signature = await sourceWallet._signTypedData(
      {
        name: constants.CONTRACT_NAME,
        version: constants.CONTRACT_VERSION,
        chainId: network.config.chainId,
        verifyingContract: contractAddress,
      },
      {
        BuyListing: [
          {
            name: 'listingId',
            type: 'uint256',
          },
          {
            name: 'buyer',
            type: 'address',
          }
        ],
      },
      {
        listingId,
        buyer
      }
    )
    return ethers.utils.splitSignature(signature);
}

module.exports = {
  signCreateListing,
  signBuyListing
}