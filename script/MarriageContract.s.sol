// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/MarriageContract.sol";

contract MarriageContractScript is Script {
    function run(bytes memory input) public override returns (bytes memory) {
        MarriageContract contract = new MarriageContract()
        contract.initialize(input);
        return abi.encode(contract);
    }
}
