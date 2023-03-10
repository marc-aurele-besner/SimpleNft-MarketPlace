// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Vm } from 'foundry-test-utility/contracts/utils/vm.sol';
import { DSTest } from 'foundry-test-utility/contracts/utils/test.sol';

contract Errors is DSTest {
  Vm public constant vm = Vm(address(uint160(uint256(keccak256('hevm cheat code')))));

  mapping(RevertStatus => string) private _errors;

  // Add a revert error to the enum of errors.
  enum RevertStatus {
    Success,
    SkipValidation,
    OnlyAdmin
  }

  // Associate your error with a revert message and add it to the mapping.
  constructor() {
    _errors[RevertStatus.OnlyAdmin] = 'Controlable: Only admin';
  }

  // Return the error message associated with the error.
  function _verify_revertCall(RevertStatus revertType_) internal view returns (string storage) {
    return _errors[revertType_];
  }

  // Expect a revert error if the revert type is not success.
  function verify_revertCall(RevertStatus revertType_) public {
    if (revertType_ != RevertStatus.Success && revertType_ != RevertStatus.SkipValidation) vm.expectRevert(bytes(_verify_revertCall(revertType_)));
  }
}
