// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

// A contract is a collection of code (functions) and data (state)
// that resides at a specific address on the Ethereium blockchain.

contract SimpleStorage {
    uint storedData;

    // As of now, anyone can call the set function to overwrite the
    // existing number
    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
