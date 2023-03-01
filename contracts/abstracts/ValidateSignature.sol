// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol';

abstract contract ValidateSignature is EIP712Upgradeable {

    function __ValidateSignature_init(string memory name, string memory version) internal onlyInitializing {
        __EIP712_init(name, version);
    }


}