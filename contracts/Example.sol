// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/access/Ownable.sol";


contract Example is Ownable {
  constructor(address initialOwner) Ownable(initialOwner) {}

  function exampleFunction() public view onlyOwner returns (string memory) {
    return "Hello, World!";
  }
}
