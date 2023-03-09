// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Vm } from 'foundry-test-utility/contracts/utils/vm.sol';
import { DSTest } from 'foundry-test-utility/contracts/utils/test.sol';

contract Errors is DSTest {
  Vm public constant vm = Vm(address(uint160(uint256(keccak256('hevm cheat code')))));

  mapping(RevertStatus => string) private _errors;

  // Add a revert error to the enum of errors.
  enum RevertStatus {
    // 0
    Success,
    // 1
    SkipValidation,
    MerkleProofInvalidMultiProof,
    OwnableCallerNotOwner,
    NewOwnerIsZero,
    MintableMaxSupplyReached,
    MintableMaxMintReached,
    ControlablePublicMintingStartInPast,
    ControlablePublicMintingStartBeforeWhitelistMinting,
    SimpleNftTransactionValueBelowMintPrice
  }

  // Associate your error with a revert message and add it to the mapping.
  constructor() {
    _errors[RevertStatus.MerkleProofInvalidMultiProof] = 'MerkleProof: invalid multiproof';
    _errors[RevertStatus.OwnableCallerNotOwner] = 'Ownable: caller is not the owner';
    _errors[RevertStatus.NewOwnerIsZero] = 'Ownable: new owner is the zero address';
    _errors[RevertStatus.MintableMaxSupplyReached] = 'Mintable: max supply reached';
    _errors[RevertStatus.MintableMaxMintReached] = 'Mintable: max mint reached';
    _errors[RevertStatus.ControlablePublicMintingStartInPast] = "Controlable: Public minting can't start in the past";
    _errors[RevertStatus.ControlablePublicMintingStartBeforeWhitelistMinting] = "Controlable: Public minting can't start before whitelist minting";
    _errors[RevertStatus.SimpleNftTransactionValueBelowMintPrice] = 'SimpleNft: Transaction value below mint price';
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
