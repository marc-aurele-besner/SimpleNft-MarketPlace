# Sample NFT MARKETPLACE Hardhat Project

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Table of contents
* [General info](#general-info)
* [Functionality](#functionality)
* [Setup](#setup)
* [Documentation](#documentation)

## General info

This project demonstrates a basic NFT's Marketplace contract setup with Hardhat and Foundry.

> **Warning**
> This smart contract repository was created for educational purposes only, to teach the basics of Solidity programming, testing with Hardhat and Foundry. It is not recommended for use in production as it has not undergone extensive testing and may contain undiscovered bugs and errors. Please use at your own risk.

## Functionality

**These contracts have these functionality**:

- NFT listing
- token and address blacklist (for prevention of possible stolen nft)
- Roles (moderation, treasury and admin)
- ability to change transaction fees and withdraw them

## Setup

### Install Dependencies

```bash
npm install
```

### Run test with Hardhat

```bash
npx hardhat test
```

### List all Hardhat tasks

```bash
npx hardhat help
```

### Run test with Foundry

```bash
forge test
```

## Documentation

- [Hardhat Documentation](https://hardhat.org/getting-started/)
- [Foundry Documentation](https://book.getfoundry.sh/index.html)