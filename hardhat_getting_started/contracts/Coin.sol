// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

contract Coin {
    // public will make variables accessible from other contracts
    // the declaration below roughly transaltes to:
    // function minter() external view returns (address) { return minter; }

    // external means the function can only be called from outside the
    // contract. Can't be called using the this.minter() syntax. More gas
    // effiecient than `public` for functions that don't need to be called
    // internally.

    // view means that the function promises not to modify the blockchain
    // state. Can read state variables but not modify them. No gas cost when
    // called externally (unless called from another contract). Cannot emit
    // events, create contracts, use selfdestruct, send ether i.e
    address public minter;

    // mappings can be seen as hash tables
    // initilaized in such a way that every key exists and is mapped to
    // a value whose byte representation is all zeros.
    // it is not posssible to obtain a list of all keys in a mapping, or a
    // list of all values.
    mapping(address => uint) public balances;

    // events allow clients to react to specific contract changes
    event Sent(address from, address to, uint amount);

    // errors allow to provide context about why an operation failed
    error InsufficientBalance(uint requested, uint available);

    constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter); // can only be called by contract creator
        balances[receiver] += amount;
    }

    function send(address receiver, uint amount) public {
        require(
            amount <= balances[msg.sender],
            InsufficientBalance(amount, balances[msg.sender])
        );
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
