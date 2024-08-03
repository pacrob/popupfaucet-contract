// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";


contract Faucet is Ownable {

    constructor(address initialOwner) Ownable(initialOwner) {}

    // Mapping to store the amount of Ether received for each event code
    mapping(string => uint256) public eventPayments;

    // Event emitted whenever Ether is received for an event code
    event PaymentReceived(string eventCode, uint256 amount, address sender);
    // Event emitted whenever a drip payment is sent
    event DripSent(address recipient, uint256 amount);

    // Function to accept Ether and record it under a specific event code
    function seedFunds(string calldata eventCode) external payable {
        require(msg.value > 0, "No Ether sent");

        // Update the mapping with the received amount
        eventPayments[eventCode] += msg.value;

        // Emit the event
        emit PaymentReceived(eventCode, msg.value, msg.sender);
    }

    // Function to send 0.0001 ETH to a specified address
    function drip(address recipient, string calldata eventCode) external {
        uint256 dripAmount = 0.0001 ether;

        // Ensure the contract has enough balance to send the drip
        require(address(this).balance >= dripAmount, "Insufficient contract balance");
        require(eventPayments[eventCode] >= dripAmount, "Insuffiecient event balance");

        eventPayments[eventCode] -= dripAmount;
        // Transfer the drip amount to the recipient
        payable(recipient).transfer(dripAmount);

        // Emit the event
        emit DripSent(recipient, dripAmount);
    }


    // Function to withdraw Ether from the contract by the owner
    function withdraw() onlyOwner external {
        // Tests:
        //  - can someone other than the owner withdraw?
        payable(msg.sender).transfer(address(this).balance);
    }

    // Fallback function to accept Ether sent directly to the contract
    receive() external payable {
        // Optional: you can handle direct transfers differently, but here we just accept it
    }

    fallback() external payable {
        // This fallback function will catch any non-existent function calls
    }
}
