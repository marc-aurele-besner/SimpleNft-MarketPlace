require('dotenv').config({ path: __dirname + '/.env' });
require('@nomicfoundation/hardhat-toolbox');
require('hardhat-awesome-cli');
require('transaction-retry-tool');
require('@openzeppelin/hardhat-upgrades');

const { RPC_MAINNET, RPC_GOERLI, PRIVATE_KEY_MAINNET, PRIVATE_KEY_GOERLI, ETHERSCAN_API_KEY, POLYSCAN_API_KEY } = process.env;
let { DUMMY_PRIVATE_KEY } = process.env;

// if (!DUMMY_PRIVATE_KEY) throw new Error('Please set your DUMMY_PRIVATE_KEY in a .env.development file');
if (!DUMMY_PRIVATE_KEY) DUMMY_PRIVATE_KEY = '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80';

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    hardhat: {},
    mainnet: {
      url: `${RPC_MAINNET}`,
      chainId: 1,
      gas: 15000000,
      gasPrice: 2000000000,
      accounts: [`${PRIVATE_KEY_MAINNET || DUMMY_PRIVATE_KEY}`]
    },
    goerli: {
      url: `${RPC_GOERLI}`,
      chainId: 5,
      gas: 15000000,
      gasPrice: 5000000000,
      accounts: [`${PRIVATE_KEY_GOERLI || DUMMY_PRIVATE_KEY}`]
    },
    mumbai: {
      url: `${RPC_GOERLI}`,
      chainId: 5,
      gas: 15000000,
      gasPrice: 5000000000,
      accounts: [`${PRIVATE_KEY_GOERLI || DUMMY_PRIVATE_KEY}`]
    },
    anvil9999: {
      url: `http://127.0.0.1:8545`,
      chainId: 9999,
      gas: 15000000,
      gasPrice: 2000000000,
      accounts: [`0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80`]
    }
  },
  etherscan: {
    apiKey: {
      mainnet: `${ETHERSCAN_API_KEY}`,
      goerli: `${ETHERSCAN_API_KEY}`,
      mumbai: `${POLYSCAN_API_KEY}`
    }
  },
  solidity: {
    version: '0.8.19',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  mocha: {
    timeout: 200000
  }
};