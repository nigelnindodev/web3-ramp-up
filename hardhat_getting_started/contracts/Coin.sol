// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

contract Coin {
    // public will make variables accessible from other contracts
    // the declaration below roughly translates to:
    // function minter() external view returns (address) { return minter; }

    // external means the function can only be called from outside the
    // contract. Can't be called using the this.minter() syntax. More gas
    // efficient than `public` for functions that don't need to be called
    // internally.

    // view means that the function promises not to modify the blockchain
    // state. Can read state variables but not modify them. No gas cost when
    // called externally (unless called from another contract). Cannot emit
    // events, create contracts, use selfdestruct, send ether i.e
    address public minter;

    // mappings can be seen as hash tables
    // initilaized in such a way that every key exists and is mapped to
    // a value whose byte representation is all zeros.
    // it is not possible to obtain a list of all keys in a mapping, or a
    // list of all values.
    mapping(address => uint) public balances;

    // events allow clients to react to specific contract changes
    event Sent(address from, address to, uint amount);

    // errors allow to provide context about why an operation failed
    error InsufficientBalance(uint requested, uint available);

    constructor() {
        minter = msg.sender;
    }

    function mint(address _receiver, uint _amount) public {
        require(msg.sender == minter); // can only be called by contract creator
        balances[_receiver] += _amount;
    }

    function send(address _receiver, uint _amount) public {
        require(
            _amount <= balances[msg.sender],
            InsufficientBalance(_amount, balances[msg.sender])
        );
        balances[msg.sender] -= _amount;
        balances[_receiver] += _amount;
        emit Sent(msg.sender, _receiver, _amount);
    }
}
